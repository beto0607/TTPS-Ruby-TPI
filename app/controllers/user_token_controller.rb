class UserTokenController < Knock::AuthTokenController
    
    # Knock::AuthTokenController wants to show :not_found when params are invalid.
    # So I add a handler and invoke :auth_params first of all.
    prepend_before_action :auth_params
    skip_before_action :verify_authenticity_token

    def auth_params
        params.require(:auth).permit(:username, :password)
    rescue ActionController::ParameterMissing
        render json: {error: "Params required: auth{username, password}"}, status: :bad_request
    end

    # Customize response
    def create
        render json: {
            token: auth_token.token,
            user: JSONAPI::Serializer.serialize(entity)
        }, status: :created
    end

    # Customize response
    def not_found
        render json: { error: {title:"User not found"} }, status: :not_found
    end
end


