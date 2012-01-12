class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user! # devise
  before_filter :start_user_session

  def start_user_session
    return nil unless user_signed_in?

    # montar sessao do usuario que acabou de logar
    unless user_session.include?(:curriculum_units) and user_session[:curriculum_units].nil?
      curriculum_units = CurriculumUnit.find_default_by_user_id(current_user.id)

      # apenas os ids das unidades curriculares a que o usuario pode ver
      ids_uc = curriculum_units.collect{|uc| uc['id'].to_i} if curriculum_units
      user_session[:curriculum_units] = ids_uc
    end

  end
end
