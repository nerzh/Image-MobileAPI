module ResizeImageHelper
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def get_images(permit_parameters, current_user)
      make_uploader_methods(permit_parameters, current_user)
      hash = Hash.new{ |hash, key| hash[key] = {} }
      current_user.images.each do |image|
        hash[image.id.to_s]['orig_name']       = image.orig_name
        hash[image.id.to_s]['url']             = image.file.url
        hash[image.id.to_s]['resized_files'] ||= []

        image.resized_files.each do |resized_file|
          resized_files                         = Hash.new{ |hash, key| hash[key] = {} }
          resized_files['image']['size']        = resized_file.size
          resized_files['image']['url']         = resized_file.file.url
          hash[image.id.to_s]['resized_files'] << resized_files
        end
      end
      hash
    end

    def new_image(permit_parameters, current_user)
      make_uploader_methods(permit_parameters, current_user)
      image         = create_image(permit_parameters[:file], current_user)
      resized_image = resize_image(image, permit_parameters[:size])
      hash_response(resized_image)
    end

    def old_image(permit_parameters, current_user)
      make_uploader_methods(permit_parameters, current_user)
      image = current_user.images.find_by(id: permit_parameters[:id])
      image.resized_files.each do |resized_file|
        return hash_response(resized_file) if resized_file.size == permit_parameters[:size]
      end
      hash_response( resize_image(image, permit_parameters[:size]) )
    end

    private

    def hash_response(resized_image)
      {
        orig_name: resized_image.image.orig_name,   size: resized_image.size,
        path:      resized_image.file.current_path, url:  resized_image.file.url
      }
    end

    def make_uploader_methods(permit_parameters, current_user)
      @@size         = permit_parameters[:size]
      @@current_user = current_user

      class << CarrierWave::Uploader::Base
        def size_of_image
          @@size
        end

        def current_user
          @@current_user
        end
      end
    end

    def create_image(file, current_user)
      image      = Image.new(orig_name: file.original_filename, user: current_user)
      image.file = file
      image.save! and return image
    end

    def resize_image(image, size)
      resized_file      = ResizedFile.new(size: size, image: image)
      resized_file.file = Rails.root.join(image.file.current_path).open
      resized_file.save! and return resized_file
    end

  end
end