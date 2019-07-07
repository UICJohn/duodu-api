class Comment < ActiveRecord::Base
  has_many :attachement, as: :attachable
end