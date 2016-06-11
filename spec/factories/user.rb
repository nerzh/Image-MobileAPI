FactoryGirl.define do

  factory :user do
    email { "email@gmail.com" }
    password "password"
    password_confirmation "password"
    api_token ""

    factory :user_with_images do
      images { [build(:image)] }
    end
  end

  factory :image do
    orig_name "IMG_0019.JPG"
    id '1'
    file_name "1.JPG"
    path Rails.root.join( 'spec', 'fixtures', 'email@gmail.com', '1' )
    url ['localhost:3000','uploads','email@gmail.com','1','1.JPG'].join('/')
    resized_files { [build(:resized_file)] }
  end

  factory :resized_file do
    id '2'
    file_name "2.JPG"
    size "100x100"
    path Rails.root.join( 'spec', 'fixtures', 'email@gmail.com', '1' )
    url ['localhost:3000','uploads','email@gmail.com','1','2.JPG'].join('/')
  end

end