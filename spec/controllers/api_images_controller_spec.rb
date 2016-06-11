require 'rails_helper'

describe Api::ImagesController do

  describe 'GET #index' do

    context 'standard behavior' do
      before(:each) do
        @user = login_user_with_images
      end

      it "response status 200" do
        get :index
        expect(response.status).to eq(200)
      end

      it "check hash" do
        get :index
        expect(json_response['1']['file_name']).to eq('1.JPG')
      end
    end

    context 'status error' do
      it "response with error" do
        get :index
        expect(response.status).to eq(401)
      end

      it "response error in http head" do
        get :index
        expect(response['APP_ERROR']).not_to be_empty
      end
    end
  end

  describe 'POST #new_image' do

    dir = File.new(Rails.root + 'spec/fixtures/files/1.JPG')
    let!(:file) { ActionDispatch::Http::UploadedFile.new(:tempfile => dir, :filename => File.basename(dir)) }

    before(:each) do
      @user = login_user
    end

    it "response status 201" do
      expect_any_instance_of( Api::ImagesController ).to receive( :save_image ).and_return( true )
      expect_any_instance_of( Api::ImagesController ).to receive( :resize_image ).and_return( true )
      post :new_image, {file: file, size: '120x120'}
      expect(response.status).to eq(201)
    end

    it "check hash" do
      hash = {test: 'response hash'}
      allow_any_instance_of( Api::ImagesController ).to receive( :save_image ).and_return( true )
      allow_any_instance_of( Api::ImagesController ).to receive( :resize_image ).and_return( hash )
      post :new_image, {file: file, size: '120x120'}
      expect(json_response['test']).to eq('response hash')
    end

  end

  describe 'POST #old_image' do

    before(:each) do
      @user = login_user_with_images
    end

    context 'size exist' do

      it "response status 201" do
        post :old_image, {id: 1, size: '100x100'}
        expect(response.status).to eq(201)
      end

      it "response object image in json" do
        post :old_image, {id: 1, size: '100x100'}
        expect(json_response['file_name']).to eq('2.JPG')
      end

    end

    context 'size not exist' do

      it "response status 201" do
        resized_image = ResizedFile.new( file_name: 'name')
        allow_any_instance_of( Api::ImagesController ).to receive( :resize_image ).and_return( resized_image )
        post :old_image, {id: 1, size: '150x150'}
        expect(response.status).to eq(201)
      end

      it "response object image in json" do
        resized_image = ResizedFile.new( file_name: 'name')
        allow_any_instance_of( Api::ImagesController ).to receive( :resize_image ).and_return( resized_image )
        post :old_image, {id: 1, size: '150x150'}
        expect(json_response['file_name']).to eq('name')
      end

      it "response status error" do
        post :old_image, {id: 1}
        expect(response.status).to eq(501)
      end

    end

  end

  # describe 'save_image' do
  #
  #   dir = File.new(Rails.root + 'spec/fixtures/files/1.JPG')
  #   let!(:file) { ActionDispatch::Http::UploadedFile.new(:tempfile => dir, :filename => File.basename(dir)) }
  #
  #
  #   before(:each) do
  #     @user = login_user
  #     controller = Api::ImagesController.new
  #     allow_any_instance_of( Api::ImagesController ).to receive( :response ).and_return( {APP_ERROR: nil} )
  #   end
  #
  #   it "file must be saved" do
  #     image = controller.save_image( @user, file )
  #     expect( File.exists? [image.path, image.file_name].join('/') ).to eq( true )
  #   end
  #
  #   it "user must to have image" do
  #     image = controller.save_image( @user, file )
  #     expect( @user.images.first ).to eq( image )
  #   end
  #
  #   it "bad argument file" do
  #     expect{ controller.save_image( @user, 'file' ) }.to raise_error
  #   end
  #
  #   it "bad argument current_user" do
  #     expect{ controller.save_image( '@user', file ) }.to raise_error
  #   end
  #
  # end

  # describe 'resize_image' do
  #
  #   before(:each) do
  #     @user = login_user
  #     @controller = Api::ImagesController.new
  #     @image = build(:image)
  #     @user.images << @image
  #     @size = '150x150'
  #     K = Struct.new(:env); request = K.new(env: {})
  #     allow_any_instance_of( Api::ImagesController ).to receive( :request ).and_return( request )
  #   end
  #
  #   context 'not error' do
  #
  #     it "return ResizedFile" do
  #       resize_file = @controller.resize_image( @image, @size, @user )
  #       expect(resize_file.class).to eq(ResizedFile)
  #     end
  #
  #     it "file exist" do
  #       resize_file = @controller.resize_image( @image, @size, @user )
  #       expect(File.exists? [resize_file.path, resize_file.file_name].join('/')).to eq( true )
  #     end
  #
  #     it "file format" do
  #       resize_file = @controller.resize_image( @image, @size, @user )
  #       image = MiniMagick::Image.open( [resize_file.path, resize_file.file_name].join('/') )
  #       expect( image.dimensions ).to eq( [150, 150] )
  #     end
  #
  #     it "insert image to user" do
  #       resize_file = @controller.resize_image( @image, @size, @user )
  #       expect( @user.images.first.resized_files ).to include( resize_file )
  #     end
  #
  #   end
  #
  #   context 'with error' do
  #
  #     it "bad argument image" do
  #       expect{ @controller.resize_image( '@image', @size, @user ) }.to raise_error
  #     end
  #
  #     it "bad argument size" do
  #       expect{ @controller.resize_image( @image, "@size", @user ) }.to raise_error
  #     end
  #
  #     it "bad argument @user" do
  #       expect{ @controller.resize_image( @image, @size, '@user' ) }.to raise_error
  #     end
  #
  #   end
  #
  # end

end