class ImagesController < ApplicationController
  ##
  # Recupera imagens de todos os usuarios passados por id
  ##
  def users
  	# criar um zip e enviar
  	# send_data -- gz

	style = params.include?('style') ? params[:style] : :small
  	users = User.find(params[:id].split(','), :select => "id, photo_file_name")

  	users.each do |u|
  		path = u.photo.path(style)
  		send_file(path, { :content_type => 'image', :filename => u.id }) unless path.nil?
  	end
  end

end
