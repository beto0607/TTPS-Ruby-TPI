class UserTokenController < Knock::AuthTokenController
    skip_before_action :verify_authenticity_token
    def auth_params
        params.require(:auth).permit :username, :password
    end

    #include Knock::Authenticable
    def create
        p entity
        render json: { 
            token: auth_token.token,
            user: JSONAPI::ResourceSerializer.new(UserResource,
            fields:{
                users:[:screen_name, :email, :username],
                liks:[:self]
            }).serialize_to_hash(UserResource.new(entity, nil))
            
        }, status: :created
    end
  
end
