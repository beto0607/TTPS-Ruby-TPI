class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy, :resolve]
  before_action :authenticate_user, only: [:create, :update, :destroy, :resolve]
  before_action :check_if_owner, only: [:update, :destroy, :resolve]
  before_action :check_if_solved, only: [:update, :resolve, :destroy]

  # GET /questions 
  # :sort => ("needing_help" | "pending_first" | "latest") default="latest"
  def index
    # I used an if statement because I don't know what value can come in
    # prams[:sort]. 
    if(params[:sort] == "needing_help")then
      questions = Question.needing_help.questionsLimit
    elsif(params[:sort] == "pending_first")then
      questions = Question.pending_first.questionsLimit
    else
      questions = Question.latest.questionsLimit
    end
    render_json serialize_models(questions, fields: {questions:index_fields}), :ok
  end

  # GET /questions/1
  def show
    if(params["answers"])then
      render_json serialize_model(@question, include: 'answers', fields: { answers: 'content,id'}), :ok
    else
      render_unique_question :ok
    end
  end

  # POST /questions
  def create
    if(question_params)then
      @question = current_user.questions.new(question_params)
      if @question.save 
        render_unique_question :created
      else
        render_json serialize_errors(@question.errors), :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /questions/1
  def update
    if(question_params)then
      if @question.update(question_params)
        render_unique_question :ok
      else
        render_json serialize_errors(@question.errors), :unprocessable_entity
      end
    end
  end

  # DELETE /questions/1
  def destroy
    if(@question.answers.count > 0)
      render_json serialize_errors("Question ##{@question.id} has answers"), :unprocessable_entity
      return
    end
    @question.destroy
    render status: :no_content
  end

  def resolve
    if(resolve_params)then
      a = @question.answers.find_by(id: resolve_params)
      if(a)
        # NoMethodError -> 'destroyed?'
        @question = Question.update(@question.id, status:true, answer_id:a.id)
        render_unique_question :ok
      else
        render json: {error: {title:"Answer ##{params[:answer_id]} doesn't belong to Question ##{@question.id}."}}, status: :bad_request
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id] || params[:question_id])
    rescue ActiveRecord::RecordNotFound
      render_json serialize_errors("Question ##{params[:id] || params[:question_id]} not found"), :not_found
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:title, :description) 
    end

    def check_if_owner
      unless current_user.id == @question.user_id
        render_json serialize_errors('Token user must be the owner of the question'), :unauthorized
      end
    end
    
    def resolve_params
      params.require(:answer_id)
    end
    
    def check_if_solved
      if @question.status
        render json: {error: {title: "Question ##{@question.id} is already solved."}}, status: :unprocessable_entity
      end
    end

    def index_fields
      #avoid render full description on index
      'id,title,description-short,status,answer-id,answers-counter,created-at,updated-at'
    end

    def show_fields
      #avoid render description-short on show, create, update, resolve
      'id,title,description,status,answer-id,answers-counter,created-at,updated-at'
    end

    def render_unique_question status=:ok
      render_json serialize_model(@question, fields:{
        questions: show_fields
      }), status
    end
end
