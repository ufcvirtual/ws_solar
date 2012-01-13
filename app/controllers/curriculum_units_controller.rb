class CurriculumUnitsController < ApplicationController

  def index
    @curriculum_units = curriculum_units_of_user

    respond_to do |format|
      format.xml  { render :xml => @curriculum_units }
      format.json  { render :json => @curriculum_units }
    end
  end

  def show
    respond_to do |format|
      c_units_of_user = curriculum_units_of_user.collect{|uc| uc['curriculum_unit_id'].to_i}

      if c_units_of_user.include?(params[:id].to_i)
        @curriculum_unit = CurriculumUnit.find(params[:id])

        format.xml  { render :xml => @curriculum_unit }
        format.json  { render :json => @curriculum_unit }
      else
        format.xml  { render :xml => {}.to_xml }
        format.json  { render :json => {}.to_json }
      end
    end
  end

  private

  def curriculum_units_of_user(user_id = current_user.id)
      CurriculumUnit.find_default_by_user_id(user_id)
  end

end
