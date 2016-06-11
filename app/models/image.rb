class Image
  include Mongoid::Document
  include ResizeImageHelper
  mount_uploader :file, ImageUploader

  field :orig_name, type: String
  field :file, type: String

  embedded_in :user
  embeds_many :resized_files

end