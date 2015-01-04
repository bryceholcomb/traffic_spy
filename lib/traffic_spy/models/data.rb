module TrafficSpy
  class Data
    attr_reader :id,
                :url_id,
                :requested_at,
                :responded_in,
                :referral_id,
                :request_type,
                :params,
                :event_id,
                :user_agent_id,
                :resolution_id,
                :ip,
                :source_id

    def initialize(data)
      @id = data[:id]
      @url_id = data[:url_id]
      @requested_at = data[:requested_at]
      @responded_in = data[:responded_in]
      @referral_id = data[:referral_id]
      @request_type = data[:request_type]
      @params = data[:params]
      @event_id = data[:event_id]
      @user_agent_id = data[:user_agent_id]
      @resolution_id = data[:resolution_id]
      @ip = data[:ip]
      @source_id = data[:source_id]
    end

    def self.all
      table.map {|row| Data.new(row)}
    end

    def self.find_or_create_by(payload, identifier)
      row = find_by_payload(payload, identifier)
      if row.nil?
        create(payload, identifier)
        row = find_by_payload(payload, identifier)
      end
      Data.new(row)
    end

    def self.clean_parameters(payload)
      if payload['parameters'].empty?
        payload['parameters'] = ''
      else
        payload['parameters'] = payload['parameters'].join(',')
      end
      payload
    end

    def self.duplicate?(payload, identifier)
      !find_by_payload(payload, identifier).nil?
    end

    def self.find_by_payload(payload, identifier)
      source_id = DB.from(:sources).where(:identifier => identifier).first[:id]
      table.select.where(
        :requested_at => payload['requestedAt'],
        :responded_in => payload['respondedIn'],
        :ip => payload['ip'],
        :source_id => source_id
        ).first
    end

    def self.sort_urls_by_frequency(identifier)
      urls = DB.from(:sources).join(:data, :source_id => :id).join(:urls, :id => :url_id).where(:identifier => identifier).to_a.map { |x| x[:name]}
      count_per_url = urls.reduce(Hash.new(0)) do |hash, url|
        hash[url] += 1
        hash
      end
      sorted_urls = count_per_url.sort_by do |url, count|
        -count
      end.map { |count_array| count_array[0] }
    end

    def self.sort_events_by_frequency(identifier)
      count_per_event(all_events(identifier)).sort_by do |event, count|
        -count
      end.map {|count_array| count_array[0]}
    end

    def self.all_events(identifier)
      joined_events_table(identifier).map {|row| row[:name]}
    end

    def self.count_per_event(events)
      events.reduce(Hash.new(0)) do |hash, event|
        hash[event] += 1
        hash
      end
    end

    def self.event_exisit?(identifier, event)
      all_events(identifier).include?(event)
    end

    def self.joined_events_table(identifier)
     DB.from(:sources).join(:data, :source_id => :id).join(:events, :id => :event_id).where(:identifier => identifier).to_a
    end

    private

    def self.table
      DB.from(:data)
    end

    def self.create(payload, identifier)
      # fields below need to be updated:
      # source_id

      table.insert(
      :url_id           => TrafficSpy::Url.find_or_create_by(:name, payload['url']).id,
      :requested_at     => payload['requestedAt'],
      :responded_in     => payload['respondedIn'],
      :referral_id      => TrafficSpy::Referral.find_or_create_by(:name, payload['referredBy']).id,
      :request_type     => payload['requestType'],
      :params           => payload['parameters'],
      :event_id         => TrafficSpy::Event.find_or_create_by(:name, payload['eventName']).id,
      :user_agent_id    => TrafficSpy::UserAgent.find_or_create_by(:data, payload['userAgent']).id,
      :resolution_id    => TrafficSpy::Resolution.find_or_create_by(payload['resolutionWidth'], payload['resolutionHeight']).id,
      :ip               => payload['ip'],
      :source_id        => TrafficSpy::Source.find_by(identifier).id
      )
    end
  end
end
