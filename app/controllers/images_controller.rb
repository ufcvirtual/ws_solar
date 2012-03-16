class ImagesController < ApplicationController

  before_filter :authenticate_user!

  # GET /images/:id/users
  def users
    style = params.include?('style') ? params[:style] : :small
    # recupera apenas usuarios com fotos
    users = User.find(:all, :conditions => "id IN (#{params[:id]}) AND photo_file_name IS NOT NULL", :select => "id, photo_file_name")

    head(:bad_request) and return if users.empty?
    require 'zip/zip'

    tmp_zip = File.join('tmp', "#{Time.now.to_i.to_s}.zip") # nome do zip eh um timestamp
    Zip::ZipFile.open(tmp_zip, Zip::ZipFile::CREATE) { |zipfile|
      # verificar se todos os usuarios possuem foto
      users.each do |user|
        if (not user.photo_file_name.nil? and File.exists?(user.photo.path(style)))
          filename = "#{user.id}.#{user.photo_file_name.split('.').last}"
          zipfile.add(filename, user.photo.path(style))
        end
      end
    }

    send_file tmp_zip
    File.delete(tmp_zip) # os usuarios podem modificar suas fotos deixando o mesmo nome, por isso o zip nao sera mantido
  end
end
