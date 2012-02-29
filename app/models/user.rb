class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :validatable, :encryptable,
    :token_authenticatable # autenticacao por token

  # before_save :ensure_authentication_token!

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :authentication_token
  
  has_attached_file :photo,
    :styles => { :medium => "72x90#", :small => "25x30#", :forum => "40x40#" },
    :path => ":rails_root/media/:class/:id/photos/:style.:extension",
    :url => "/:class/:id/photos/:style.:extension",
    :default_url => "/images/no_image_:style.png"

  # def ensure_authentication_token!
    # reset_authentication_token! if authentication_token.blank? 
  # end

end
