class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :validatable, :encryptable,
    :token_authenticatable # autenticacao por token

  # before_save :ensure_authentication_token!

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :authentication_token
  
  # def ensure_authentication_token!
    # reset_authentication_token! if authentication_token.blank? 
  # end

end
