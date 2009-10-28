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

class FaviconIcon < Image
  
  THUMBNAILS = { }

  has_attachment :content_type => ['image/vnd.microsoft.icon'],  
                 :thumbnails => THUMBNAILS,
                 :storage => :file_system, :path_prefix => 'public/images/photos',
                 :max_size => 5.megabytes,
                 :processor => 'Rmagick'

  def before_save
    self.store = attachable
  end
  
end
