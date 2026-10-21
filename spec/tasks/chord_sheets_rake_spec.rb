require "rails_helper"
require "rake"

RSpec::Matchers.define_negated_matcher :not_change, :change

describe "chord_sheets:reclassify_lines", type: :task do
  subject(:task) { Rake::Task["chord_sheets:reclassify_lines"] }

  let!(:misclassified_sheet) do
    create(:chord_sheet, content: [
             { "type" => "chords", "content" => "[Verse 1]\r\n" },
             { "type" => "lyrics", "content" => "(D7)  G\r\n" },
             { "type" => "chords", "content" => "\r\n" },
             { "type" => "lyrics", "content" => "Am　　F\r\n" },
             { "type" => "lyrics", "content" => "So here it is" }
           ])
  end
  let!(:correct_sheet) { create(:chord_sheet, content_string: "G   Am\nMy great lyrics") }

  before { Rails.application.load_tasks unless Rake::Task.task_defined?("chord_sheets:reclassify_lines") }

  after do
    task.reenable
    ENV.delete("DRY_RUN")
  end

  it "remodels the lines of sheets that are misclassified" do
    expect { task.invoke }.to output.to_stdout
                          .and change { misclassified_sheet.reload.content }.to [
                            { "type" => "heading", "content" => "[Verse 1]\r\n" },
                            { "type" => "chords", "content" => "(D7)  G\r\n" },
                            { "type" => "lyrics", "content" => "\r\n" },
                            { "type" => "chords", "content" => "Am    F\r\n" },
                            { "type" => "lyrics", "content" => "So here it is" }
                          ]
  end

  it "records a version so the change can be restored" do
    expect { task.invoke }.to output.to_stdout
                          .and change { misclassified_sheet.versions.count }.by(1)
  end

  it "doesn't save sheets that are already correct" do
    expect { task.invoke }.to output.to_stdout
                          .and(not_change { correct_sheet.reload.updated_at })
  end

  it "reports how many sheets were updated" do
    expect { task.invoke }.to output("Updated 1 of 2 chord sheets\n").to_stdout
  end

  context "with DRY_RUN set" do
    before { ENV["DRY_RUN"] = "1" }

    it "doesn't save any changes" do
      expect { task.invoke }.to output.to_stdout
                            .and(not_change { misclassified_sheet.reload.content })
    end

    it "reports how many sheets would be updated" do
      expect { task.invoke }.to output("Would update 1 of 2 chord sheets\n").to_stdout
    end
  end
end
