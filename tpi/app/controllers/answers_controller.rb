class AnswersController < ApplicationController

    def index id=nil, req=nil
        begin
            answers = Question.find_by!(id: (id || params[:question_id])).answers.map do |a|
                {
                    type: 'answer',
                    id: a.id,
                    attributes: {
                        content: a.content,
                        created_at: a.created_at,
                        updated_at: a.updated_at
                    },
                    relationships: {
                        author: {
                            id: a.user_id
                        },
                        question:{
                            id: a.question_id,
                            links:{
                                self: (request || req).base_url+"/questions/#{a.question_id}"
                            }
                        }
                    }
                }
            end
            response = {
                links:{
                    self: (request || req).base_url+"/questions/#{(id || params[:question_id])}/answers"
                },
                data: answers
            }

            if (id)then
                response
            else
                render json: response, status: 200
            end
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue OwnerError, TokenDoesntExist, AnswerFromOtherQuestionError
            renderError $!.message, $!.httpResponse
        rescue
            renderError $!.message, 500
        end
    end

    def new
        begin
            checkContentType
            logged_user = getUserByToken
            Question.find_by!(id: params[:question_id])
                .answers.create!(content: params[:content], user_id: logged_user.id)
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue OwnerError, TokenDoesntExist, AnswerFromOtherQuestionError, QuestionSolved, MimeTypeError
            renderError $!.message, $!.httpResponse
        rescue
            renderError $!.message, 500
        end
    end

    def delete
        begin
            logged_user = getUserByToken
            Question.find_by!(id: params[:question_id])
                .answers.destroy!(content: params[:content], user_id: logged_user.id)
        rescue ActiveRecord::RecordNotFound
            renderError $!.message, 404
        rescue ActiveRecord::RecordNotDestroyed
            renderError $!.message, 409
        rescue OwnerError, TokenDoesntExist, AnswerFromOtherQuestionError, AnswerSolution
            renderError $!.message, $!.httpResponse
        rescue
            renderError $!.message, 500
        end 
    end
end
