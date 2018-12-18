class UserController < ApplicationController
    def new
        begin
            new_user = User.new do |u|
                u.username = params[:username]
                u.password = User.encryptedPassword(params[:password])
                u.email = params[:email]
                u.screen_name = params[:screen_name]
            end
            new_user.save!
            renderJSON({
                :data => {
                    type: "user",
                    id: new_user.id,
                    attributes: User.userAttributes(new_user)
                }
            }, :created)
        rescue ActiveRecord::RecordInvalid
            render json: {
                errors: [{
                    status: 409,
                    title: "Record invalid",
                    detail: $!.message
                }]
            }, status: :conflict
        end
    end

    def login
        begin
            logged_user = User.find_by(username: params[:username], password: User.encryptedPassword(params[:password]))
            logged_user.tokens.where(["expire_at < ?", DateTime.now]).destroy_all
            tokens = logged_user.tokens.where(["expire_at > ?", DateTime.now]).order("expire_at DESC")
            if(tokens.length > 0)then
                t = tokens[0]
                t.update!(expire_at: Token.nextExpireDateTime)
            else
                t = logged_user.tokens.create(token: Token.createToken, expire_at: Token.nextExpireDateTime)
            end
            
            renderJSON({
                :data => {
                    type: "user",
                    id: logged_user.id,
                    attributes: ({:token => t.token}).merge(User.userAttributes(logged_user))
                }
            }, :ok)
        rescue ActiveRecord::RecordNotFound
            render json: {
                errors: [{
                    status: 404,
                    title: "User not found",
                    detail: $!.message
                }]
            }, status: :conflict
        end
    end
end
