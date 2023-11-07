class Procedure < ApplicationRecord
  belongs_to :recipe
  
  validates :body, presence: true
  
  has_one_attached :process_image

  def get_process_image(width, height)
    unless process_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      process_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    process_image.variant(resize_to_limit: [width, height]).processed
  end
end
