class ApplicationController < ActionController::API

    def renderJSON (object, status=:ok)
        render json: object, status: status
    end

end
