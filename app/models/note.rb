# == Schema Information
#
# Table name: notes
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  body          :text
#  viewed        :boolean(1)
#  noteable_id   :integer(4)
#  noteable_type :string(255)
#  user_id       :integer(4)
#  deleted_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Note < ActiveRecord::Base
  
  cattr_reader :per_page
  @@per_page = 10

  validates_presence_of :body, :noteable_id, :noteable_type, :user_id
  belongs_to :noteable, :polymorphic => true
  belongs_to :user

end
