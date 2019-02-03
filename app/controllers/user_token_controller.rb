class UserTokenController < Knock::AuthTokenController
    skip_before_action :verify_authenticity_token
    def auth_params
        params.require(:auth).permit :username, :password
    end

    def create
        render json: { token: auth_token.token}, status: :created
    end
  
end
