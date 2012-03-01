class HomeController < ApplicationController
  def index
	@title = 'Web Service SOLAR'
  	@text = user_signed_in? ? 'Bem vindo' : 'Voce precisa estar logado para ter acesso'

	respond_to do |format|
		format.html
		format.xml  { render :xml => {:title => @title, :text => @text} }
		format.json  { render :json => {:title => @title, :text => @text} }
    end
  end
end
