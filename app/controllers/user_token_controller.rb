class UserTokenController < Knock::AuthTokenController
    prepend_before_action :auth_params
    skip_before_action :verify_authenticity_token

    def auth_params
        params.require(:auth).permit(:username, :password)
    rescue ActionController::ParameterMissing
        render json: {error: "Params required: username, password"}, status: :bad_request
    end

    # Customize response
    def create
        render json: { 
            token: auth_token.token,
            user: JSONAPI::ResourceSerializer.new(UserResource,
                fields:{
                    users:[:screen_name, :email, :username],
                    liks:[:self]
                }).serialize_to_hash(UserResource.new(entity, nil))
        }, status: :created
    end

    # Customize response
    def not_found
        render json: { error: {title:"User not found"} }, status: :not_found
    end
    
end
