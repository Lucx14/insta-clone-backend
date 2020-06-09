module FilesTestHelper
  extend self
  extend ActionDispatch::TestProcess

  def png_name
    'test_post_image.png'
  end

  def png
    upload(png_name, 'image/png')
  end

  def jpg_name
    'test_2_post_image.jpg'
  end

  def jpg
    upload(jpg_name, 'image/jpg')
  end

  def avatar_name
    'default_test_avatar.png'
  end

  def avatar_png
    upload(avatar_name, 'image/png')
  end

  private

  def upload(name, type)
    file_path = Rails.root.join('spec', 'support', 'assets', name)
    fixture_file_upload(file_path, type)
  end
end
