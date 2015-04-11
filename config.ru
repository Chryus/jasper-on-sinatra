require "./app"

app = Rack::Builder.new do
  
  map "/" do
    run JasperOnSinatra::App
  end
end

run app