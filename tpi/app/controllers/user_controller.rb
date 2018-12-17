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
                },
                :relationships => {
                    :questions => {},
                    :answers => {}
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
        rescue ActiveRecord::RecordNotFound
            
        rescue ActiveRecord::RecordInvalid

        end
    end
end
