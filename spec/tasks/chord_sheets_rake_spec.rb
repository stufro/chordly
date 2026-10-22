require "rails_helper"
require "rake"

RSpec::Matchers.define_negated_matcher :not_change, :change

describe "chord_sheets:reclassify_lines", type: :task do
  subject(:task) { Rake::Task["chord_sheets:reclassify_lines"] }

  let(:active_user) { create(:user, current_sign_in_at: 11.months.ago) }
  let(:misclassified_content) do
    [{ "type" => "lyrics", "content" => "(D7)  G\r\n" }]
  end
  let!(:misclassified_sheet) do
    create(:chord_sheet, user: active_user, content: [
             { "type" => "chords", "content" => "[Verse 1]\r\n" },
             { "type" => "lyrics", "content" => "(D7)  G\r\n" },
             { "type" => "chords", "content" => "\r\n" },
             { "type" => "lyrics", "content" => "Am　　F\r\n" },
             { "type" => "lyrics", "content" => "So here it is" }
           ])
  end
  let!(:correct_sheet) { create(:chord_sheet, user: active_user, content_string: "G   Am\nMy great lyrics") }

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

  it "doesn't update sheets of users who haven't signed in for over a year" do
    inactive_user = create(:user, current_sign_in_at: 13.months.ago)
    inactive_sheet = create(:chord_sheet, user: inactive_user, content: misclassified_content)

    expect { task.invoke }.to output.to_stdout
                          .and(not_change { inactive_sheet.reload.content })
  end

  it "doesn't update sheets of users who have never signed in" do
    new_user = create(:user, current_sign_in_at: nil)
    new_user_sheet = create(:chord_sheet, user: new_user, content: misclassified_content)

    expect { task.invoke }.to output.to_stdout
                          .and(not_change { new_user_sheet.reload.content })
  end

  it "doesn't update sheets without a user" do
    trial_sheet = create(:chord_sheet, user: nil, content: misclassified_content)

    expect { task.invoke }.to output.to_stdout
                          .and(not_change { trial_sheet.reload.content })
  end

  it "only counts the sheets of recently active users in the report" do
    create(:chord_sheet, user: create(:user, current_sign_in_at: 13.months.ago), content: misclassified_content)

    expect { task.invoke }.to output("Updated 1 of 2 chord sheets\n").to_stdout
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
