require "rails_helper"

describe "ChordPro" do
  let(:user) { create(:user) }
  let(:chord_pro_content) do
    <<~TEXT
      {title: You Are My Sunshine}

      {c:Verse 1}
      [G]The other night dear as I lay sleeping
      So I hung my [D7]head and [G]cried
    TEXT
  end

  before { sign_in user }

  describe "GET /chord_pro/new" do
    it "renders the new chord sheet form" do
      get new_chord_pro_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /chord_pro" do
    context "when given ChordPro content in the form" do
      subject(:post_content) do
        post chord_pro_index_path, params: { chord_sheet: { content: chord_pro_content } }
      end

      it "creates a chord sheet" do
        expect { post_content }.to change(ChordSheet, :count).by(1)
      end

      it "parses the title from the ChordPro" do
        post_content
        expect(ChordSheet.last.name).to eq("You Are My Sunshine")
      end

      it "marks the chord sheet as created from ChordPro" do
        post_content
        expect(ChordSheet.last).to be_created_from_chord_pro
      end

      it "assigns the current user" do
        post_content
        expect(ChordSheet.last.user).to eq(user)
      end

      it "redirects to the created chord sheet" do
        post_content
        expect(response).to redirect_to(ChordSheet.last)
      end
    end

    context "when given a ChordPro file upload" do
      subject(:post_file) do
        post chord_pro_index_path, params: { chord_sheet: { file: } }
      end

      let(:file) do
        Rack::Test::UploadedFile.new(
          StringIO.new(file_content),
          "text/plain",
          original_filename: "sunshine.cho"
        )
      end
      let(:file_content) { chord_pro_content }

      it "creates a chord sheet" do
        expect { post_file }.to change(ChordSheet, :count).by(1)
      end

      it "parses the title from the uploaded file" do
        post_file
        expect(ChordSheet.last.name).to eq("You Are My Sunshine")
      end

      it "redirects to the created chord sheet" do
        post_file
        expect(response).to redirect_to(ChordSheet.last)
      end
    end

    context "when the uploaded file is read as binary (ASCII-8BIT)" do
      subject(:post_file) do
        post chord_pro_index_path, params: { chord_sheet: { file: } }
      end

      let(:file) do
        Rack::Test::UploadedFile.new(
          StringIO.new(chord_pro_content.dup.force_encoding("ASCII-8BIT")),
          "text/plain",
          original_filename: "sunshine.cho"
        )
      end

      it "creates a chord sheet without raising an encoding error" do
        expect { post_file }.to change(ChordSheet, :count).by(1)
      end

      it "parses the title" do
        post_file
        expect(ChordSheet.last.name).to eq("You Are My Sunshine")
      end
    end

    context "when the uploaded file contains invalid UTF-8 byte sequences" do
      subject(:post_file) do
        post chord_pro_index_path, params: { chord_sheet: { file: } }
      end

      let(:file) do
        Rack::Test::UploadedFile.new(
          StringIO.new("{title: Caf\xE9}\n[G]invalid \xFF byte".dup.force_encoding("ASCII-8BIT")),
          "text/plain",
          original_filename: "corrupt.cho"
        )
      end

      it "scrubs the invalid bytes and still creates a chord sheet" do
        expect { post_file }.to change(ChordSheet, :count).by(1)
      end
    end

    context "when creation fails" do
      it "sets a flash alert" do
        post chord_pro_index_path(format: :turbo_stream), params: { chord_sheet: { content: "" } }
        expect(flash[:alert]).to include("Failed to create chord sheet")
      end
    end
  end
end
