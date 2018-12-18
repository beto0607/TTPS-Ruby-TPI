class OwnerError < StandardError
    def httpResponse
        401
    end
    def message
        "User doesn't own this question/answer"
    end
end

class TokenDoesntExist < StandardError
    def httpResponse
        400
    end
    def message
        "X-QA-Key not found in request's header or is invalid"
    end
end

class AnswerFromOtherQuestionError < StandardError
    def httpResponse
        400
    end
    def message
        "Answer doesn't belongs to question provided"
    end
end
class QuestionSolved < StandardError
    def httpResponse
        422
    end
    def message
        "Question has been set as solved"
    end
end
class AnswerSolution < StandardError
    def httpResponse
        409
    end
    def message
        "Question solver by this answer. Cannot be deleted."
    end
end

class ApplicationController < ActionController::API

    def renderJSON (object, status=:ok)
        render json: object, status: status
    end


    def getUserByToken
        t = Token.where("token = ? AND expire_at > ?", request.headers["X-QA-Key"], DateTime.now).take
        if(!t)then
            raise TokenDoesntExist 
        end
        t.user
    end

    def renderError message, httpResponseNumber
        render json: {
            status: httpResponseNumber,
            message: message
        }, status: httpResponseNumber
    end
end
