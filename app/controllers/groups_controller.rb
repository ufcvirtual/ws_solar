class GroupsController < ApplicationController

  def index
    @groups = CurriculumUnit.find_user_groups_by_curriculum_unit_and_user(params[:curriculum_unit_id], current_user.id)

    respond_to do |format|
      format.xml  { render :xml => @groups }
      format.json  { render :json => @groups }
    end
  end

  def show
  end

end
