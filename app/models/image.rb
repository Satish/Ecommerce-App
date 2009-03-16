# == Schema Information
#
# Table name: images
#
#  id              :integer(4)      not null, primary key
#  size            :integer(4)
#  height          :integer(4)
#  width           :integer(4)
#  parent_id       :integer(4)
#  content_type    :string(255)
#  filename        :string(255)
#  thumbnail       :string(255)
#  type            :string(255)
#  attachable_id   :integer(4)
#  attachable_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Image < ActiveRecord::Base
  
  has_attachment :content_type => [:image],  
                 :thumbnails => {:S75x75 => "75x75",
                                 :S100x120 => "100x120",
                                 :S130x130 => "130x130",
                                 :S225x225 => "225x225",
                                 :S280x280 => "280x280",
                                 :S365x355 => "365x355",
                                 :S550x440 => "550x440",},
                 :storage => :file_system, :path_prefix => 'public/images/admin/products/photos',
                 :max_size => 5.megabytes,
                 :processor => 'Rmagick'
                 
  validates_as_attachment


end
