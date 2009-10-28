# == Schema Information
#
# Table name: images
#
#  id              :integer(4)      not null, primary key
#  size            :integer(4)
#  height          :integer(4)
#  content_type    :string(255)
#  filename        :string(255)
#  thumbnail       :string(255)
#  type            :string(255)
#  attachable_id   :integer(4)
#  attachable_type :string(255)
#  store_id        :integer(4)
#  parent_id       :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class Image < ActiveRecord::Base
  
  #validates_presence_of :attachable_type, :attachable_id#,  :store_id

  THUMBNAILS = {:S25x25 => "25x25",
                :S75x75 => "75x75",
                :S100x120 => "100x120",
                :S130x130 => "130x130",
                :S160x160 => "160x160",
                :S225x225 => "225x225",
                :S280x280 => "280x280",
                :S365x355 => "365x355",
                :S550x440 => "550x440",
                :S650x250 => "650x250",}

  has_attachment :content_type => [:image],  
                 :thumbnails => THUMBNAILS,
                 :storage => :file_system, :path_prefix => 'public/images/photos',
                 :max_size => 5.megabytes,
                 :processor => 'Rmagick'
                 
  validates_as_attachment

#  validates_presence_of :attachable_id, :attachable_type, :type, :store_id
  belongs_to :attachable, :polymorphic => true
  belongs_to :store
  
  def before_save
    self.store = attachable.store if attachable
  end
  
end
