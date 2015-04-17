require_relative "base"

module Encoder
  module Routes
    class Logins < base
        get '/login' do
          erb :'logins/new'
        end

        post 'login' do
          env['warden'].authenticate!
          if env['warden'].authenticated?
            flash[:notice] = 'Successfully logged in.'
            redirect '/dashboard'
          else
            flash[:error] = 'Login failed.'
            redirect '/login'
          end
        end

        get '/logout' do
          env['warden'].logout
          flash[:notice] = 'Successfully logged out.'
          redirect '/login'
        end

        post '/unauthenticated' do
          redirect '/login'
        end
      end
    end
  end
end