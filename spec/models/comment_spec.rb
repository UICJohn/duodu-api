require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#sub_comments' do
    before do
      @root_comment = create :comment, target: (create :sharehouse)
    end

    it 'should return all sub_comments' do
      comment1 = create :comment, target: @root_comment, body: 'comment1'
      sub_comment1 = create :comment, target: comment1, body: 'sub_comment1'
      sub_comment2 = create :comment, target: sub_comment1, body: 'sub_comment2'
      sub_comment3 = create :comment, target: comment1, body: 'sub_comment3'
      sub_comment4 = create :comment, target: sub_comment2, body: 'sub_comment4'
      sub_comment5 = create :comment, target: sub_comment4, body: 'sub_comment4'

      expect(@root_comment.sub_comments.count).to eq 6
      expect(comment1.sub_comments.count).to eq 5
      expect(sub_comment1.sub_comments.count).to eq 3
      expect(sub_comment2.sub_comments.count).to eq 2
      expect(sub_comment3.sub_comments.count).to eq 0
      expect(sub_comment4.sub_comments.count).to eq 1
    end
  end

  describe '#root' do
    before do
      @post = create :sharehouse
      @root_comment = create :comment, target: @post
    end

    it 'should return root of comment' do
      comment1 = create :comment, target: @root_comment, body: 'comment1'
      sub_comment1 = create :comment, target: comment1, body: 'sub_comment1'
      sub_comment2 = create :comment, target: sub_comment1, body: 'sub_comment2'
      sub_comment3 = create :comment, target: comment1, body: 'sub_comment3'
      sub_comment4 = create :comment, target: sub_comment2, body: 'sub_comment4'
      sub_comment5 = create :comment, target: sub_comment4, body: 'sub_comment4'

      expect(@root_comment.root).to eq @post
      expect(comment1.root).to eq @post
      expect(sub_comment1.root).to eq @post
      expect(sub_comment2.root).to eq @post
      expect(sub_comment3.root).to eq @post
      expect(sub_comment4.root).to eq @post
    end
  end
end
