require "rails_helper"

describe ApplicationController do
  before do
    allow(subject).to receive(:current_user).and_return user
    allow(subject).to receive(:redirect_to)
  end

  describe "#authorize" do
    context "when the trial user owns the trial sheet" do
      let(:user) { nil }

      it "returns nil" do
        session[:trial_user_id] = "abcdefg"
        expect(subject.authorize(ChordSheet.new(trial_user_id: "abcdefg", trial: true))).to be_nil
      end
    end

    context "when the trial user doesn't own the trial sheet" do
      let(:user) { nil }

      it "returns nil" do
        resource = ChordSheet.new(trial_user_id: "abcdefg", trial: true)
        subject.authorize(resource)

        expect(subject).to have_received(:redirect_to).with(
          "/",
          alert: "You are not authorized to view this #{resource.class.name.underscore.titleize}",
          code: 401
        )
      end
    end

    context "when the current user owns the resource" do
      let(:user) { instance_double User, :user, id: 1 }

      it "returns nil" do
        expect(subject.authorize(ChordSheet.new(user_id: 1))).to be_nil
      end
    end

    context "when the current user doesn't own the resource" do
      let(:user) { instance_double User, :user, id: 99 }

      it "returns nil" do
        resource = ChordSheet.new(user_id: 1)
        subject.authorize(resource)

        expect(subject).to have_received(:redirect_to).with(
          "/",
          alert: "You are not authorized to view this #{resource.class.name.underscore.titleize}",
          code: 401
        )
      end
    end
  end
end
