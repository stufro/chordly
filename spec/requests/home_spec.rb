require "rails_helper"

describe "Home" do
  describe "GET /" do
    context "when signed in" do
      before { sign_in create(:user) }

      it "returns ok" do
        get authenticated_root_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "when not signed in" do
      it "returns ok" do
        get unauthenticated_root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /home/roadmap" do
    it "returns ok" do
      get roadmap_home_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /home/about" do
    it "returns ok" do
      get about_home_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /home/privacy" do
    it "returns ok" do
      get privacy_home_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /home/features" do
    it "returns ok" do
      get features_home_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /asset_frame" do
    context "when the asset is permitted" do
      it "returns ok" do
        get asset_frame_path, params: { asset: "features_gif" }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the asset is not permitted" do
      it "returns not acceptable" do
        get asset_frame_path, params: { asset: "../../etc/passwd" }
        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end
end
