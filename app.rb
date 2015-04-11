require 'sinatra'

require_relative "routes/images"

JASPER = [
  { title: 'background-image', url: '/images/0.jpg'},
  { title: 'boxes', url: '/images/1.jpg' },
  { title: 'mint', url: '/images/2.jpg' },
  { title: 'sun', url: '/images/3.jpg' }
]

module JasperOnSinatra
  class App < Sinatra::Application
    set :title, "Jasper on Sinatra"

    use Routes::Images

    before do
      @background_image = JASPER.map { |hash| hash[:url] if hash[:title] == 'background-image' }.compact.first
      @user = 'Chris'
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

    namespace '/images' do
      get do # matches '/images'
        @images = Image.all
        erb ":/images/index", layout: true
      end

      get "/:id" do |id|
        @image = Image.find(id)
        erb :"images/show"
      end

      post do
        @image = Image.create params[:image]
      end
    end

    get '/images' do
      @images = JASPER
      erb :images, layout: true
    end

    get '/images/:index/download' do |index|
      @image = JASPER[index.to_i]

      attachment @image[:title]
      send_file 'images/#{index}.jpg' 
    end

    get '/images/:index.?:format?' do |index, format|
      @index = index.to_i
      @image = JASPER[@index]
      if format == 'jpg'
        content_type :jpg
        send_file 'images/#{@index}.jpg'
      else
        erb :'/images/show', layout: true
      end
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