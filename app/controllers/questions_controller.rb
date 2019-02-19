class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy, :resolve]
  before_action :authenticate_user, only: [:create, :update, :destroy, :resolve]
  before_action :question_params, only: [:create,:update]
  before_action :check_if_owner, only: [:update, :destroy, :resolve]
  before_action :check_if_solved, only: [:update, :resolve, :destroy]

  # GET /questions 
  # :sort => ("needing_help" | "pending_first" | "latest") default="latest"
  def index
    if(params[:sort] == "needing_help")then
      questions = Question.where(status: false).order('created_at DESC').limit(Question.pageSize).sort do |a,b|
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
  def show
    render json: JSONAPI::ResourceSerializer.new(QuestionResource,
      include: ['answers'],
      
      fields:{
        questions: [:title, :user_id, :answer_count, :status, :answer_id, :description, :created_at, :updated_at],
        links: [:self],
        answers: [:user_id, :question_id, :content, :created_at, :updated_at]
      }).serialize_to_hash(QuestionResource.new(@question, nil))
  end

  # POST /questions
  def create
    @question = current_user.questions.new(question_params)

    if @question.save 
      render json: JSONAPI::ResourceSerializer.new(QuestionResource,
        fields:{
          questions: [:title, :user_id, :answer_count, :status, :answer_id, :description, :created_at, :updated_at],
          links: [:self],
        }).serialize_to_hash(QuestionResource.new(@question, nil)), status: :created
    else
      render json: {error:@question.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      render json: JSONAPI::ResourceSerializer.new(QuestionResource,
        fields:{
          questions: [:title, :user_id, :answer_count, :status, :answer_id, :description, :created_at, :updated_at],
          links: [:self]
        }).serialize_to_hash(QuestionResource.new(@question, nil)), status: :ok
    else
      render json: {error:@question.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  def destroy
    if(@question.answers.count > 0)
      render json: {error:{title: "Question ##{@question.id} has answers"}}, status: :unprocessable_entity
      return
    end
    @question.destroy
    render status: :no_content
  end

  def resolve
    a = @question.answers.find_by(id: resolve_params)
    if(a)
      # NoMethodError -> 'destroyed?'
      @question = Question.update(@question.id, status:true, answer_id:a.id)
      render json: JSONAPI::ResourceSerializer.new(QuestionResource,
        fields:{
          questions: [:title, :user_id, :answer_count, :status, :answer_id, :description, :created_at, :updated_at],
          links: [:self]
        }).serialize_to_hash(QuestionResource.new(@question, nil)), status: :ok
    else
      render json: {error: {title:"Answer ##{params[:answer_id]} doesn't belong to Question ##{@question.id}."}}, status: :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id] || params[:question_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: {title:"Question ##{params[:id] || params[:question_id]} not found"} }, status: :not_found
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:title, :description)
    rescue ActionController::ParameterMissing
      render json: {error: {title: "Params required: question{title, description, question_id}"}}, status: :bad_request
    end

    def check_if_owner

      unless current_user.id == @question.user_id
        render json: {error: {title: 'Token user must be the owner of the question'}}, status: :unauthorized
      end
    end
    
    def resolve_params
      params.require(:answer_id)
    rescue ActionController::ParameterMissing
      render json: {error: {title: "Params required: answer_id"}}, status: :bad_request
    end
    
    def check_if_solved
      if @question.status
        render json: {error: {title: "Question ##{@question.id} is already solved."}}, status: :unprocessable_entity
      end
    end

end
