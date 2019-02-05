class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :set_question, only: [:index, :create, :destroy]
  before_action :authenticate_user, only: [:create, :destroy]
  before_action :check_if_solved, only: [:create]
  before_action :check_if_owner, only: [:destroy]


  # GET /questions/:question_id/answers
  def index
    render json: JSONAPI::ResourceSerializer.new(AnswerResource, 
    fields:{
      answers: [:user_id, :question_id, :content, :created_at, :updated_at],
      links: [:self]
    }).serialize_to_hash(
      @answers.map {|a| AnswerResource.new(a, nil)}
    )
  end

  # POST /questions/:question_id/answers
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      render json: JSONAPI::ResourceSerializer.new(AnswerResource,
      fields:{
        answers: [:user_id, :question_id, :content, :created_at, :updated_at],
        links: [:self]
      }).serialize_to_hash(AnswerResource.new(@answer, nil))
    else
      render json: {data:@answer.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /answers/1
  def destroy
    if(@question.answer_id == @answer.id)
      render json: {data: "Answer is solution for ##{@question.id}. Cannot be deleted."}, status: :bad_request
    else
      @answer.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def answer_params
      params.require(:answer).permit(:content)
    end

    def set_question
      @question = Question.find(params[:question_id]) 
      @answers = @question.answers
    end
    def check_if_owner
      unless current_user.id == @answer.user_id
        render json: {data: 'Current user must be the owner of the answer'}, status: :bad_request
      end
    end

    def check_if_solved
      unless !@question.status
        render json: {data: "Question ##{@question.id} is already solved."}, status: :unprocessable_entity
      end
    end
end
