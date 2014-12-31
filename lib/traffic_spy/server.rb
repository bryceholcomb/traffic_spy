module TrafficSpy

  # Sinatra::Base - Middleware, Libraries, and Modular Apps
  #
  # Defining your app at the top-level works well for micro-apps but has
  # considerable drawbacks when building reusable components such as Rack
  # middleware, Rails metal, simple libraries with a server component, or even
  # Sinatra extensions. The top-level DSL pollutes the Object namespace and
  # assumes a micro-app style configuration (e.g., a single application file,
  # ./public and ./views directories, logging, exception detail page, etc.).
  # That's where Sinatra::Base comes into play:
  #
  class Server < Sinatra::Base
    set :views, 'lib/views'

    get '/' do
      erb :index
    end

    post '/sources' do
      if params['identifier'] && params['rootUrl'] && Source.new_identifier?(params)
        Source.insert(params)
        identifier = Source.find(params)
        status 200; {identifier[0] => identifier[1]}.to_json
      elsif !Source.new_identifier?(params)
        status 403; "Duplicate"
      else
        status 400; "Missing params"
      end
    end

    post '/sources/:identifier/data' do |identifier|
      if Data.duplicate?(params['payload'])
        status 403, "Payload already submitted"
      elsif params['payload']
        status 200
        Data.create(params['payload'])
      else
        status 400; "Missing payload"
      end
    end

    not_found do
      erb :error
    end
  end

end
