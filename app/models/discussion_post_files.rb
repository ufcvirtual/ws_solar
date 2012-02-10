class DiscussionPostFiles < ActiveRecord::Base

  belongs_to :discussion_post
  
  validates :attachment_file_name, :presence => true
  validates_attachment_size :attachment, :less_than => 10.kilobyte

  # recebera apenas arquivos de audio -- fazer validacao para este tipo por enquanto - 2012-02-08

  has_attached_file :attachment,
    :path => ":rails_root/media/discussions/post/:id_:basename.:extension",
    :url => "/media/discussions/post/:id_:basename.:extension"
end
