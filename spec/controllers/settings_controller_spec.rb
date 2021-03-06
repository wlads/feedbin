require 'rails_helper'

describe SettingsController do
  describe "#help" do
    it "works" do
      get :help
    end
  end

  describe "#settings" do
    it "works" do
      get :settings
    end
  end

  describe "#account" do
    it "works" do
      get :account
    end
  end


  describe "#settings_update" do
    let(:settings_params) {
      {
        entry_sort: 'DESC',
        starred_feed_enabled: "true",
        precache_images: "true",
        show_unread_count: "true",
        sticky_view_inline: "false",
        mark_as_read_confirmation: "true",
        apple_push_notification_device_token: '123foo'
      }
    }

    it "updates settings" do
      user = create(:user)
      sign_in user

      post :settings_update, user: settings_params, id: user.id

      user.reload

      settings_params.each do |key, value|
        expect(user.send(key)).to eq value
      end

      expect(response).to redirect_to settings_url
    end
  end
end
