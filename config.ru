require "./app"

app = Rack::Builder.new do

  use Warden::Manager do |config|
    config.default_startegies :password

    config.serialize_into_session{ |user| user.id }

    config.serialize_from_session{ |user_id| User.where(id: user_id) }

    config.failure_app = JasperOnSinatra::App
  end

  Warden::Manager.before_failure do |env, opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.first(username: params['user']['username'])

      if user.nil?
        fail!("The username you entered does not exist.")
      elsif user.authenticate(params['user']['password'])
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  map "/" do
    run JasperOnSinatra::App
  end
end

run app