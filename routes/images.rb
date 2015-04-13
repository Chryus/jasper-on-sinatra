require_relative "base"
require "sinatra/contrib"

module JasperOnSinatra
  module Routes
    class Images < Base

      register Sinatra::Namespace

      namespace '/images' do
        get do # matches '/images'
          @images = Image.all
          erb :"/images/index", layout: true
        end

        get "/:id" do |id|
          @image = Image[id.to_i]
          erb :"images/show", layout: true
        end

        get "/:id/download" do |id|
          @image = Image[id.to_i]
          attachment @image[:title]
          send_file "assets/images/#{id.to_i}.jpg"
        end

        post do
          @image = Image.create params[:image]
        end
      end
    end
  end
end

    # get '/images/:index/download' do |index|
    #   @image = JASPER[index.to_i]

    #   attachment @image[:title]
    #   send_file 'images/#{index}.jpg' 
    # end

    # get '/images/:index.?:format?' do |index, format|
    #   @index = index.to_i
    #   @image = JASPER[@index]
    #   if format == 'jpg'
    #     content_type :jpg
    #     send_file 'images/#{@index}.jpg'
    #   else
    #     erb :'/images/show', layout: true
    #   end
    # end