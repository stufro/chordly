namespace :chord_sheets do
  desc "Remodel the lines of every chord sheet with the current parser. Set DRY_RUN=1 to only report changes."
  task reclassify_lines: :environment do
    dry_run = ENV["DRY_RUN"].present?
    updated = 0

    ChordSheet.find_each do |chord_sheet|
      content = ChordSheetModeller.new(chord_sheet.content.pluck("content").join).parse.as_json
      next if content == chord_sheet.content

      chord_sheet.update!(content:) unless dry_run
      updated += 1
    end

    $stdout.puts "#{dry_run ? 'Would update' : 'Updated'} #{updated} of #{ChordSheet.count} chord sheets"
  end
end
