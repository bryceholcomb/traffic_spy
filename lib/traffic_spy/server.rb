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
        "Source not registered"
      else
        urls_by_frequency = TrafficSpy::Data.sort_by_frequency(:urls, identifier, :name, :name)
        browsers_by_frequency = TrafficSpy::Data.sort_by_frequency(:user_agents, identifier, :browser, :browser)
        os_by_frequency = TrafficSpy::Data.sort_by_frequency(:user_agents, identifier, :os, :os)

        #this resolutions needs to be updated. should group and count by both width and height.
        resolution_by_frequency = TrafficSpy::Data.sort_by_frequency(:resolutions, identifier, :width, :height)

        #this needs to be updated to sort
        response_time_by_frequency_per_url = TrafficSpy::Data.sort_response_time_by_frequency_per_url(identifier)
        erb :identifier, locals: {
          identifier: identifier,
          urls_by_frequency: urls_by_frequency,
          browsers_by_frequency: browsers_by_frequency,
          os_by_frequency: os_by_frequency,
          resolution_by_frequency: resolution_by_frequency,
          response_time_by_frequency_per_url: response_time_by_frequency_per_url
          }
      end
    end

    ['/sources/:identifier/urls/:relative', '/sources/:identifier/urls/:relative/:path'].each do |path_name|
      get path_name do
        identifier          = params[:identifier]
        url                 = Source.find_by(identifier).root_url
        rel                 = params[:relative]
        path                = params[:path]
        long_resp_time      = Data.long_resp_time(identifier, url, rel, path)
        short_resp_time     = Data.short_resp_time(identifier, url, rel, path)
        http_verbs          = Data.http_verbs(identifier, url, rel, path)
        most_pop_refferers  = Data.most_pop_refs(identifier)
        most_pop_agents     = Data.most_pop_agents(identifier)
        if Data.relative_path_exists?(identifier, url, rel, path)
          erb :url_stats, locals: {identifier: identifier,
                                   long_response_time:      long_resp_time,
                                   short_response_time:     short_resp_time,
                                   avg_response_time:       Data.avg_resp_time(identifier, url, rel, path),
                                   http_verbs:              http_verbs,
                                   most_popular_referrers:  most_pop_refferers,
                                   most_popular_agents:     most_pop_agents}
        else
          erb :url_error
        end
      end
    end

    get '/sources/:identifier/events' do |identifier|
      if TrafficSpy::Source.find_by(identifier).nil?
        erb :identifier_error, locals: {identifier: identifier}
      elsif TrafficSpy::Data.all_events(identifier).empty?
        erb :events_error, locals: {identifier: identifier}
      else
        sorted_events_by_frequency = TrafficSpy::Data.sort_events_by_frequency(identifier)
        erb :events, locals: {identifier: identifier, sorted_events_by_frequency: sorted_events_by_frequency}
      end
    end

    get '/sources/:identifier/events/:event' do |identifier, event|
      if TrafficSpy::Source.find_by(identifier).nil?
        erb :identifier_error, locals: {identifier: identifier}
      elsif TrafficSpy::Data.all_events(identifier).include?(event)
        event_count = TrafficSpy::Data.event_count(identifier, event)
        sorted_request_times =TrafficSpy::Data.sorted_requested_times(identifier, event)
        # require 'pry'
        # binding.pry
        erb :specific_event, locals: {identifier: identifier, specific_event: event, event_count: event_count, sorted_request_times: sorted_request_times}
      else
        erb :specific_event_error, locals: {identifier: identifier, event: event}
      end
    end

    not_found do
      erb :error
    end
  end
end
