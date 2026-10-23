require "rails_helper"
require "aws-sdk-s3"

describe DatabaseBackupJob do
  let(:s3_client) { Aws::S3::Client.new(stub_responses: true) }
  let(:uploads) { {} }

  before do
    allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
    s3_client.stub_responses(:put_object, lambda { |context|
      uploads[context.params[:key]] = context.params[:body].read
      {}
    })
  end

  it "uploads a gzipped copy of each database", :aggregate_failures do
    described_class.perform_now

    expect(uploads.keys).to contain_exactly(match(%r{\Atest/test-\d{8}T\d{6}Z\.sqlite3\.gz\z}))
    expect(ActiveSupport::Gzip.decompress(uploads.values.first)).to start_with("SQLite format 3")
  end

  it "removes its temporary files" do
    expect { described_class.perform_now }.not_to(change { Rails.root.glob("tmp/test-*") })
  end

  it "removes its temporary files when the upload fails", :aggregate_failures do
    s3_client.stub_responses(:put_object, "InternalError")

    expect { described_class.perform_now }.to raise_error(Aws::S3::Errors::InternalError)
    expect(Rails.root.glob("tmp/test-*")).to be_empty
  end

  it "deletes backups older than seven days" do
    s3_client.stub_responses(:list_objects_v2, contents: [
                               { key: "test/test-old.sqlite3.gz", last_modified: 8.days.ago },
                               { key: "test/test-recent.sqlite3.gz", last_modified: 1.day.ago }
                             ])

    described_class.perform_now

    deleted_keys = s3_client.api_requests.select { it[:operation_name] == :delete_object }.map { it[:params][:key] }
    expect(deleted_keys).to eq(["test/test-old.sqlite3.gz"])
  end

  it "does nothing while another backup is running" do
    Rails.root.join("tmp/database_backup.lock").open(File::RDWR | File::CREAT) do |lock|
      lock.flock(File::LOCK_EX)

      described_class.perform_now
    end

    expect(s3_client.api_requests).to be_empty
  end
end
