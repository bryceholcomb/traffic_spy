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

    get '/sources/:identifier/events' do |identifier|
      if TrafficSpy::Source.find_by(identifier).nil?
        status 404
        erb :identifier_error, locals: {identifier: identifier}
      elsif TrafficSpy::Data.all_events(identifier).empty?
        status 405
        erb :events_error, locals: {identifier: identifier}
      else
        sorted_events_by_frequency = TrafficSpy::Data.sort_events_by_frequency(identifier)
        erb :events, locals: {identifier: identifier, sorted_events_by_frequency: sorted_events_by_frequency}
      end
    end

    get '/sources/:identifier/events/:event' do |identifier, event|
      if TrafficSpy::Source.find_by(identifier).nil?
        status 404
        erb :identifier_error, locals: {identifier: identifier}
      elsif TrafficSpy::Data.all_events(identifier).include?(event)
        event_count = TrafficSpy::Data.event_count
        sorted_request_times =TrafficSpy::Data.sorted_requsted_times
        erb :specific_event, locals: {identifier: identifier, specific_event: event, event_count: event_count, sorted_request_times: sorted_request_times}
      else
        status 405
        erb :specific_event_error, locals: {identifier: identifier, event: event}
      end
    end

    not_found do
      erb :error
    end
  end

end
