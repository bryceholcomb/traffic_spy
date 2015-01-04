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
        Source.create(params)
        identifier = Source.find(params)
        status 200; {identifier[0] => identifier[1]}.to_json
      elsif !Source.new_identifier?(params)
        status 403; "Duplicate"
      else
        status 400; "Missing params"
      end
    end

    post '/sources/:identifier/data' do |identifier|
      return status 400 if params['payload'].nil?
      payload = TrafficSpy::Data.clean_parameters(JSON.parse(params['payload']))
      if TrafficSpy::Source.find_by(identifier).nil?
        status 403; "Application not registered"
      elsif TrafficSpy::Data.duplicate?(payload, identifier)
        status 403; "Payload already submitted"
      elsif params['payload']
        TrafficSpy::Data.find_or_create_by(payload, identifier)
        status 200
      else
        status 400; "Missing payload"
      end
    end

    get '/sources/:identifier' do |identifier|
      if TrafficSpy::Source.find_by(identifier).nil?
        status 404
      else
        sorted_urls_by_frequency = TrafficSpy::Data.sort_urls_by_frequency(identifier)
        erb :identifier, locals: {identifier: identifier, sorted_urls_by_frequency: sorted_urls_by_frequency}
      end
    end

    ['/sources/:identifier/urls/:relative', '/sources/:identifier/urls/:relative/:path'].each do |path_name|
      get path_name do
        identifier = params[:identifier]
        root_url    = Source.find_by(identifier).root_url
        relative   = params[:relative]
        path       = params[:path]
        if Source.relative_path_exists?(identifier, relative, path)
          erb :url_stats, locals: {identifier: identifier,
                                   long_response_time: Data.longest_response_time(root_url, relative, path),
                                   short_response_time: Data.shortest_response_time(root_url, relative, path),
                                   average_response_time: Data.avg_response_time(root_url, relative, path),
                                   http_verbs: Data.http_verbs(root_url, relative, path),
                                   most_popular_referrers: Data.most_pop_refs(identifier),
                                   most_popular_agents: "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"}
        else
          erb :url_error
        end
      end
    end

    not_found do
      erb :error
    end
  end

end
