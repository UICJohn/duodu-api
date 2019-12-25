require 'rails_helper'

RSpec.describe Notification, type: :model do
  before do
    @template = create :notification_template, body: "body with \#{user.username}", title: "title with \#{ user.username }"
  end

  describe '#title' do
    it 'should interplate string with variable' do
      notification = create :notification, template_id: @template.id
      expect(notification.title).to eq "title with #{ notification.user.username }"
    end
  end

  describe '#body' do
    it 'should interplate string with variable' do
      notification = create :notification, template_id: @template.id
      expect(notification.body).to eq "body with #{ notification.user.username }"
    end
  end

end
