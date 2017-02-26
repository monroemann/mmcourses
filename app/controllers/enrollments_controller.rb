class EnrollmentsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_authorized_for_current_course, only: [:show]
    
  def create
    current_user.enrollments.create(course: current_course)
    redirect_to course_path(current_course)
  end

  private
    
  def current_course
    @current_course ||= Course.find(params[:course_id])
  end

  def require_authorized_for_current_course
    if current_course.user != current_user && 
        if !current_lesson.section.course.user.enrolled_in?(current_course)
            redirect_to course_path(current_course), 
            alert: 'You are not enrolled in this course'
        end
    end

end
