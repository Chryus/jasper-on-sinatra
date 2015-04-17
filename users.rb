require_relative "base"

module Encoder
  module Routes
    class Users < Base
      post '/users' do
        user = User.new(params[:user])

        if user.save
          flash[:notice] = "User '#{user.username}' saved"
          redirect users_path
        else
          flash[:error] = "Error saving new user."
          erb :'users/index', locals: { users: User.all, new_user: user }
        end
      end

      delete '/users/:id' do |user_id|
        user = User[user_id]
        user.destroy
        flash[:notice] = "User '#{user.username}' has been deleted"
        redirect users_path
      end
    end
  end
end