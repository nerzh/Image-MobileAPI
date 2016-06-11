class ResizedFile
  include Mongoid::Document
  mount_uploader :file, ResizeImageUploader

  field :file, type: String
  field :size, type: String

  embedded_in :image

end