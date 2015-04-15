require 'sinatra'

require_relative "routes/images"

module JasperOnSinatra
  class App < Sinatra::Application
    set :title, "Jasper on Sinatra"

    use Routes::Images

    before do
      @weight = session[:weight]
      @environment = settings.environment
    end

    before /images/ do
      @message = 'Jasper is pretty'
    end

    after do
      logger.info '<== Leaving request'
    end

    get '/jasper.pdf' do
      attachment
      content_type 'application/pdf'

      pdf = Prawn::Document.new
      pdf.text 'Jasper is a sweet sweet soul'
      pdf.render
    end

    get '/sessions/new' do
      erb :'/sessions/new', layout: true
    end

    post '/sessions' do
      session[:weight] = params[:weight]
      redirect '/images'
    end

    get '/' do
      erb :home, layout: true
    end

    post '/' do
      'Hello World via POST'
      params['wew']
    end

    put '/' do
      'Jasper via PUT'
    end

    delete '/' do
      "Jasper via DELETE #{params['wew']}"
    end

    # get '/:first_name/?:last_name?' do |first, last|
    #   'Hello #{first} #{last}'
    # end

    not_found do
      erb :'404', layout: false
    end
  end
end