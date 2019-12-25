require 'rails_helper'
require 'devise/jwt/test_helpers'
require 'rake'
load File.join(Rails.root, 'lib', 'tasks', 'posts.rake')

RSpec.describe 'Post Comments', type: :request do
  before do
    @user = create :wechat_user
    create :notification_template, tag: 'comment'
    create :notification_template, tag: 'reply'
    @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
  end

  describe 'index' do

    it 'should show all comment' do
      post = create :sharehouse
      comment = create :comment, target: post
      create :comment, target: post
      create :comment, target: post
      create :comment, target: comment
      get "/v1/post_comments", params:{ post_id: post.id }, headers: @headers
      expect(response).to be_successful
      comments = JSON.parse(response.body)['comments']
      expect(comments.count).to eq 3
      expect(comments.any? { |c| c['sub_comments'].present? }).to eq true
    end
  end

  describe '#create' do
    it 'should create comment for post' do
      post = create :housemate
      user = create :wechat_user
      expect {
        post "/v1/post_comments", params: { comment: { post_id: post.id, body: 'create post' } }, headers: @headers
      }.to change(Comment, :count).by 1
      expect(response).to be_successful
      comments = JSON.parse(response.body)['comments']
      expect(comments.count).to eq 1
      expect(Notification.count).to eq 1
    end
  end

  describe '#reply' do
    it 'should create comment for comment' do
      comment = create :comment, target: (create :housemate)
      expect {
        post "/v1/post_comments/#{comment.id}/reply", params: { comment: { body: 'sub comment' } }, headers: @headers
      }.to change(Comment, :count).by 1
      expect(response).to be_successful
      comments = JSON.parse(response.body)['comments']
      expect(comments.count).to eq 1
      expect(comments.first['sub_comments'].count).to eq 1
      expect(Notification.count).to eq 2
    end
  end

  describe '#destroy' do
    it 'should destroy comment' do
      comment = create :comment, user_id: @user.id, target: (create :housemate, user_id: @user.id)
      expect {
        delete "/v1/post_comments/#{comment.id}", headers: @headers
      }.to change(Comment, :count).by -1
      expect(response).to be_successful
    end

    it 'should not able to destroy comment' do
      comment = create :comment, target: (create :housemate, user_id: @user.id)
      expect {
        delete "/v1/post_comments/#{comment.id}", headers: @headers
      }.to change(Comment, :count).by 0
      expect(response).to be_successful
    end
  end

end
