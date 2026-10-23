require "rails_helper"

describe "Admin" do
  let(:user) { create(:user, user_type:) }
  let(:user_type) { :admin }

  before { sign_in user }

  describe "/admin" do
    it "renders the admin page" do
      get "/admin"
      expect(response).to render_template(:index)
    end

    it "links to every chord sheet" do
      get "/admin"
      expect(response.parsed_body.css("a").pluck("href")).to include(admin_chord_sheets_path)
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get "/admin"
        expect(response).to redirect_to("/")
      end

      it "sets a flash message" do
        get "/admin"
        expect(flash[:alert]).to eq "You are not authorized to view this page"
      end
    end
  end

  describe "GET /admin/users/:id" do
    let(:target_user) { create(:user) }

    it "renders the user show page" do
      get admin_user_path(target_user)
      expect(response).to render_template(:show)
    end

    it "assigns the user" do
      get admin_user_path(target_user)
      expect(assigns(:user)).to eq target_user
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get admin_user_path(target_user)
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "GET /admin/chord_sheets" do
    def row_for(name)
      response.parsed_body.css("tbody tr").find { it.text.include?(name) }
    end

    it "shows a page of chord sheets at a time" do
      stub_const("Admin::BaseController::PER_PAGE", 2)
      create_list(:chord_sheet, 3)
      get admin_chord_sheets_path
      expect(response.parsed_body.css("tbody tr").size).to eq 2
    end

    it "shows the rest on the next page" do
      stub_const("Admin::BaseController::PER_PAGE", 2)
      create_list(:chord_sheet, 3)
      get admin_chord_sheets_path(page: 2)
      expect(response.parsed_body.css("tbody tr").size).to eq 1
    end

    it "ticks chord sheets that have been styled" do
      create(:line_style, :chords, :red, styleable: create(:chord_sheet, name: "Styled song"))
      get admin_chord_sheets_path
      expect(row_for("Styled song").text).to include("☑️")
    end

    it "leaves chord sheets with the built-in styles unticked" do
      create(:line_style, :chords, :bold, styleable: create(:chord_sheet, name: "Plain song"))
      get admin_chord_sheets_path
      expect(row_for("Plain song").text).not_to include("☑️")
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get admin_chord_sheets_path
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "GET /admin/chord_sheets/:id" do
    let(:chord_sheet) { create(:chord_sheet) }

    it "renders the chord sheet show page" do
      get admin_chord_sheet_path(chord_sheet)
      expect(response).to render_template(:show)
    end

    it "assigns the chord sheet" do
      get admin_chord_sheet_path(chord_sheet)
      expect(assigns(:chord_sheet)).to eq chord_sheet
    end

    it "styles each line by its type" do
      create(:line_style, :chords, :red, styleable: chord_sheet)

      get admin_chord_sheet_path(chord_sheet)

      expect(response.parsed_body.at_css(".chord-line")["style"]).to eq "font-weight: bold; color: #e03131"
    end

    context "when the user is not an admin" do
      let(:user_type) { :standard }

      it "redirects to home page" do
        get admin_chord_sheet_path(chord_sheet)
        expect(response).to redirect_to("/")
      end
    end
  end
end
