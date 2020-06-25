class Instructor::LessonsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_authorized_for_current_section, only: [:create]
    before_action :require_authorized_for_current_lesson, only: [:update]
    protect_from_forgery with: :null_session

    def create
        @lesson = current_section.lessons.create(lesson_params)
        redirect_to instructor_course_path(current_section.course)
    end

    def edit
        @lesson = current_section.lessons.find(params[:id])
    end

    def update
        if current_lesson.section.course.user != current_user
            return render plain: "Not Allowed", status: :unauthorized
        end
        
        current_lesson.update_attributes(lesson_params)
        
        if current_lesson.valid?
            redirect_to lesson_path
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def current_lesson
        @current_lesson ||= Lesson.find(params[:id])
    end

    def require_authorized_for_current_section
        if current_section.course.user != current_user
            return render plain: 'Unauthorized', status: :unauthorized
        end
    end

    def require_authorized_for_current_lesson
        if current_lesson.section.course.user != current_user
            return render plain: 'Unauthorized', status: :unauthorized
        end
    end

    helper_method :current_section
    def current_section
        @current_section ||= Section.find(params[:section_id])
    end

    def lesson_params
        params.require(:lesson).permit(:title, :subtitle, :video, :row_order_position)
    end

end
