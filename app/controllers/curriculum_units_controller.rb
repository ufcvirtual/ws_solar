class CurriculumUnitsController < ApplicationController

  def index
    @curriculum_units = CurriculumUnit.where(["id IN (?)", user_session[:curriculum_units]])

    respond_to do |format|
      format.xml  { render :xml => @curriculum_units }
      format.json  { render :json => @curriculum_units }
    end
  end

  def show
    respond_to do |format|
      if user_session[:curriculum_units].include?(params[:id].to_i)
        @curriculum_unit = CurriculumUnit.find(params[:id])

        format.xml  { render :xml => @curriculum_unit }
        format.json  { render :json => @curriculum_unit }
      else
        format.xml  { render :xml => {}.to_xml }
        format.json  { render :json => {}.to_json }
      end
    end
  end

end
