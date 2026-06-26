require "rails_helper"

describe "Articles" do
  describe "GET /articles/:id" do
    context "when the article exists and is whitelisted" do
      it "returns ok" do
        get article_path("guide-to-using-chordly")
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the article is not whitelisted" do
      it "returns not found" do
        get article_path("secret-article")
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the article file does not exist on disk" do
      it "returns not found" do
        get article_path("beginners-guide-to-transposing")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
