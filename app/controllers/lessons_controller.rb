class LessonsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_authorized_for_current_course

    def show
    end

    private

    def require_authorized_for_current_course
        @creator = current_lesson.section.course.user
        if !current_user.enrolled_in?(current_lesson.section.course) && current_user != @creator
            redirect_to course_path(current_lesson.section.course), alert: 'You must be enrolled in the course to view lessons.'
        end
    end

    helper_method :current_lesson
    def current_lesson
        @current_lesson ||= Lesson.find(params[:id])
    end

end
