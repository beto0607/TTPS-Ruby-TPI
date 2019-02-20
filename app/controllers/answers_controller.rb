class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :set_question, only: [:index, :create, :destroy]
  before_action :authenticate_user, only: [:create, :destroy]
  before_action :check_if_solved, only: [:create]
  before_action :check_if_owner, only: [:destroy]


  # GET /questions/:question_id/answers
  def index
    render_json serialize_models(@answers), :ok
  end

  # POST /questions/:question_id/answers
  def create
    if(answer_params)then
      @answer = @question.answers.new(answer_params)
      @answer.user_id = current_user.id

      if @answer.save
        render_unique_question :created
      else
        render_json serialize_errors(@answer.errors), :unprocessable_entity
      end
    end
  end

  # DELETE /answers/1
  def destroy
    if(@question.answer_id == @answer.id)
      render_json serialize_errors("Answer is solution for ##{@question.id}. Cannot be deleted."), :bad_request
    else
      @answer.destroy
      render status: :no_content
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_json serialize_errors("Answer ##{params[:id] || params[:answer_id]} not found."), :not_found
    end

    # Only allow a trusted parameter "white list" through.
    def answer_params
      params.require(:answer).permit(:content)
    end

    def set_question
      @question = Question.find(params[:question_id]) 
      @answers = @question.answers
    rescue ActiveRecord::RecordNotFound
      render_json serialize_errors("Question ##{params[:question_id]} not found."), :not_found
    end

    def check_if_owner
      unless current_user.id == @answer.user_id
        render_json serialize_errors('Current user must be the owner of the answer.'), :unauthorized
      end
    end

    def check_if_solved
      unless !@question.status
        render_json serialize_errors("Question ##{@question.id} is already solved."), :unprocessable_entity
      end
    end


    def render_unique_question status=:ok
      render_json serialize_model(@answer), status
    end
end
