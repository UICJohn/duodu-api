class V1::ReportPostsController < ApplicationController
  before_action :authenticate_user!

  def survey
    @survey = Survey.find_by(code_name: params[:survey_name])
  end

  def create
    if post = Post::Base.find_by(id: params[:post_id])
      user_survey = UserSurvey.new(report_params)
      
      user_survey.assign_attributes( user_id: current_user.id, target: post )

      user_survey.save ? success! : error!(user_survey.errors)

    else
      error!("Post Not Found")
    end
  end

  private

  def report_params
    params.require(:report).permit(:survey_id, :survey_option_id, :body)
  end
  
end
