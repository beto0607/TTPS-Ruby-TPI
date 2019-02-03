class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]

  # GET /questions
  def index
    if(params[:sort] == "needing_help")then
      questions = Question.where(status: false).limit(Question.pageSize).sort do |a,b|
        a.answers.count  <=> b.answers.count
      end
    else
      questions = Question.all.limit(Question.pageSize)
        .order((params[:sort] == "pending_first" ? 'status ASC,':'')+'created_at DESC')
    end

    render json: JSONAPI::ResourceSerializer.new(QuestionResource, 
    fields:{
      questions: [:title, :user_id, :answer_count, :status, :answer_id, :description_short, :created_at, :updated_at],
      links: [:self]
    }).serialize_to_hash(
      questions.map {|q| QuestionResource.new(q, nil)}
    )
  end

  # GET /questions/1
  def show2
    render json: @question
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question, status: :created, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
  end

  def resolve
    nil
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:title, :description, :status, :user_id)
    end
end
