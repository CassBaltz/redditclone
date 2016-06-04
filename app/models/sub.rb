# == Schema Information
#
# Table name: subs
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :string           not null
#  moderator_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Sub < ActiveRecord::Base

  validates :title, :moderator_id, :description, presence: true
  validates :moderator_id, uniqueness: true

  belongs_to(
  :moderator,
  :class_name => 'User',
  foreign_key: :moderator_id,
  primary_key: :id
  )

  has_many(
  :posts,
  class_name: 'Post',
  foreign_key: :sub_id,
  primary_key: :id
  )
end
