require 'rails_helper'

RSpec.describe Notification, type: :model do
  before do
    @template = create :notification_template, body: "body with \#{sender.username}", title: "title with \#{ user.username }"
    @post = create :sharehouse
  end

  describe '#title' do
    it 'should interplate string with variable' do
      notification = create :notification, template_id: @template.id, target: @post
      expect(notification.title).to eq "title with #{ notification.sender.username }"
    end
  end

  describe '#body' do
    it 'should interplate string with variable' do
      notification = create :notification, template_id: @template.id, target: @post
      expect(notification.body).to eq "body with #{ notification.sender.username }"
    end
  end

end
