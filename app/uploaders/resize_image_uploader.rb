class ResizeImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{self.class.current_user.email}/#{model.image.id}"
  end

  def filename
    ext = File.extname(super)
    model.id.to_s + ext
  end

  process :resize

  def resize
    self.class.version :resize do
      process resize_to_fit: size_of_image.split('x')
      def full_filename(for_file = model.file)
        filename
      end
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
