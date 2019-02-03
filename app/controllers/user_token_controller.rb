require_dependency "knock/application_controller"

class UserTokenController < Knock::AuthTokenController
    skip_before_action :verify_authenticity_token

    def auth_params
        params.require(:auth).permit :username, :password
    end

    def to_json options = {}
        p "to_json UserTokenController"
        {token: @token}.to_json
    end
end
