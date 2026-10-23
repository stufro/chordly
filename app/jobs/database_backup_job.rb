require "aws-sdk-s3"

class DatabaseBackupJob < ApplicationJob
  queue_as :default

  RETAIN_DAYS = 7
  BACKUP_BUCKET = "chordly-backups".freeze

  def perform
    Rails.root.join("tmp/database_backup.lock").open(File::RDWR | File::CREAT) do |lock|
      next unless lock.flock(File::LOCK_EX | File::LOCK_NB)

      databases.each { |source| back_up(source) }
      prune_old_backups
    end
  end

  private

  def databases
    ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).map(&:database).select { File.exist?(it) }
  end

  def back_up(source)
    db_name = File.basename(source, ".sqlite3")
    filename = "#{db_name}-#{Time.current.utc.strftime('%Y%m%dT%H%M%SZ')}.sqlite3"
    backup_path = Rails.root.join("tmp/#{filename}")
    compressed_path = Rails.root.join("tmp/#{filename}.gz")

    system("sqlite3 #{source} \".backup '#{backup_path}'\"", exception: true)
    system("gzip -c #{backup_path} > #{compressed_path}", exception: true)
    upload(compressed_path, "#{db_name}/#{filename}.gz")
  ensure
    FileUtils.rm_f([backup_path, compressed_path])
  end

  def upload(path, key)
    File.open(path, "rb") do |file|
      s3_client.put_object(bucket: BACKUP_BUCKET, key:, body: file)
    end
  end

  def prune_old_backups
    cutoff = RETAIN_DAYS.days.ago

    databases.each do |source|
      db_name = File.basename(source, ".sqlite3")
      s3_client.list_objects_v2(bucket: BACKUP_BUCKET, prefix: "#{db_name}/").contents.each do |object|
        s3_client.delete_object(bucket: BACKUP_BUCKET, key: object.key) if object.last_modified < cutoff
      end
    end
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(
      endpoint: "https://#{Rails.application.credentials.dig(:cloudflare, :account_id)}.r2.cloudflarestorage.com",
      access_key_id: Rails.application.credentials.dig(:cloudflare, :r2_access_key_id),
      secret_access_key: Rails.application.credentials.dig(:cloudflare, :r2_secret_access_key),
      region: "auto",
      request_checksum_calculation: "when_required",
      response_checksum_validation: "when_required"
    )
  end
end
