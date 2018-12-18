class QuestionsController < ApplicationController

    def index
        begin 
            questions_length = Question.count
            if(params[:sort] == "needing_help")then
                questions = Question.where(status: false).limit(Question.pageSize).offset(params[:offset] || 0)
                questions_length = Question.where(status: false).count
                #seems like sort! doesn't applies
                questions = questions.sort do |a,b|
                    a.answers.count  <=> b.answers.count
                end
            else
                questions = Question.limit(Question.pageSize).offset(params[:offset] || 0)
                    .order((params[:sort] == "pending_first" ? 'status ASC,':'')+'created_at DESC')
            end
            json_questions = questions.map do |q|
                {
                    id: q.id,
                    type: "question",
                    attributes:{
                        title: q.title,
                        description: q.description[0, 120] + (q.description.length > 120 ? "..." : ""),
                        answers_count: q.answers.count,
                        solved: q.status
                    },
                    links:{
                        self: request.base_url+"/questions/#{q.id}"
                    }
                }
            end

            links = {self: request.original_url}
            links[:next] = request.base_url+"/questions?offset=#{Integer(params[:offset] || 0).succ}" unless questions_length <= (Integer(params[:offset] || 0).succ) * Question.pageSize
            links[:previous] = request.base_url+"/questions?offset=#{Integer(params[:offset] || 0).pred}" unless Integer(params[:offset] || 0).pred < 0

            render json: {
                links: links,
                data: json_questions
            }, status: :ok
        rescue
            renderError $!.message, 500
        end
    end

    def show id=nil
        begin
            question = Question.find_by!(id: (id || params[:id]))
            
            response = {
                links: {self: request.original_url},
                data: {
                    type: "question",
                    id: question.id,
                    attributes: {
                        title: question.title,
                        description: question.description,
                        status: question.status,
                        created_at: question.created_at,
                        updated_at: question.updated_at
                    },
                    relationships:{
                        author:{
                            id: question.user_id,
                            attributes:{
                                screen_name: question.user.screen_name
                            }
                        }
                    }
                },
            }
            response[:data][:relationships][:solved_answer] = {
                type: "answer",
                id: question.answer_id,
                links: {
                    self: request.base_url+"/questions/#{question.answer_id}"
                }
            } unless question.answer_id == nil

            if(params[:answers])then
                response[:answers] = AnswersController.new.index question.id, request
            end

            if(id == nil)then
                render json: response.to_json, status: :ok
            else
                response.to_json
            end
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue
            renderError $!.message, 500
        end
    end

    def new
        begin
            logged_user = getUserByToken
            question = logged_user.questions.create!(
                title: params[:title],
                description: params[:description]
            )
            render json: show(question.id), status: :created
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue ActiveRecord::RecordInvalid
            renderError $!.message, 400
        rescue TokenDoesntExist
            renderError $!.message, $!.httpResponse
        rescue
            renderError $!.message, 500
        end
    end

    def edit
        begin
            logged_user = getUserByToken
            question = Question.find_by!(id: params[:id])
            if(logged_user.id != question.user_id)then raise OwnerError end
            question.update!(
                title: params[:title] || question[:title],
                description: params[:description] || question[:description]
            )
            render json: show(question.id), status: :ok
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue ActiveRecord::RecordInvalid
            renderError $!.message, 400
        rescue OwnerError, TokenDoesntExist
            renderError $!.message, $!.httpResponse
        rescue
            renderError $!.message, 500
        end
    end

    def destroy
        begin
            logged_user = getUserByToken
            question = Question.find_by!(id: params[:id])
            if(logged_user.id != question.user_id)then raise OwnerError end
            question.destroy!
            render json: show(question.id), status: :no_content
        rescue ActiveRecord::RecordNotDestroyed
            renderError $!.message, 409
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue ActiveRecord::RecordInvalid
            renderError $!.message, 400
        rescue OwnerError, TokenDoesntExist
            renderError $!.message, $!.httpResponse
        rescue
            renderError $!.message, 500
        end
    end

    def update
        begin
            logged_user = getUserByToken
            question = Question.find_by!(id: params[:id])
            if(logged_user.id != question.user_id)then raise OwnerError end

            if(!question.answers.find_by(id: params[:answer_id]))then raise AnswerFromOtherQuestionError end

            question.update!(status: true, answer_id: params[:answer_id])
            render json: show(question.id), status: :no_content
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue OwnerError, TokenDoesntExist, AnswerFromOtherQuestionError
            renderError $!.message, $!.httpResponse
        rescue
            renderError $!.message, 500
        end
    end
end
