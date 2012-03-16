class GroupsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @groups = CurriculumUnit.find_user_groups_by_curriculum_unit_and_user(params[:curriculum_unit_id], current_user.id)

    respond_to do |format|
      format.xml  { render :xml => @groups }
      format.json  { render :json => @groups }
    end
  end
end
