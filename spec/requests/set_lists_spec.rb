require "rails_helper"

describe "Set lists" do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "POST /set_lists" do
    context "when the set list creates successfully" do
      it "redirects to the set list" do
        post "/set_lists", params: { set_list: { name: "Foo" } }
        set_list = SetList.find_by(name: "Foo")

        expect(response).to redirect_to(set_list_path(set_list))
      end

      it "assigns the current user to the set list" do
        post "/set_lists", params: { set_list: { name: "Foo" } }
        set_list = SetList.find_by(name: "Foo")

        expect(set_list.user).to eq user
      end
    end

    context "when the set list fails to create" do
      it "renders the new page" do
        post "/set_lists", params: { set_list: { name: "" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH /set_list/:id" do
    context "when the set list updates successfully" do
      let(:set_list) { create(:set_list) }

      it "sets a flash message" do
        patch set_list_path(set_list, format: :turbo_stream), params: { id: set_list.id, set_list: { name: "Foo" } }

        expect(flash[:notice]).to eq "Changes saved"
      end
    end

    context "when the set list fails to update" do
      let(:set_list) { create(:set_list) }

      it "sets a flash message" do
        patch set_list_path(set_list, format: :turbo_stream), params: { id: set_list.id, set_list: { name: "" } }

        expect(flash[:alert]).to eq "Failed to update set list: Name can't be blank"
      end
    end
  end
end
