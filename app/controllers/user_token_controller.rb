require_dependency "knock/application_controller"

class UserTokenController < Knock::AuthTokenController
    skip_before_action :verify_authenticity_token

    def auth_params
        params.require(:auth).permit :username, :password
    end
    
    def auth_token2
        p entity.id
        Knock::AuthToken.new payload: {"user":"#{entity.id}"}
    end
  
end
