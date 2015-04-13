require_relative "base"
require "sinatra/contrib"

module JasperOnSinatra
  module Routes
    class Images < Base

      register Sinatra::Namespace

      namespace '/images' do
        get do # matches '/images'
          binding.pry
          @images = Image.all
          erb :"/images/index", layout: true
        end

        get "/:id" do |id|
          @image = Image.find(id)
          erb :"images/show"
        end

        post do
          @image = Image.create params[:image]
        end
      end
    end
  end
end