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

    def self.table
      DB.from(:data)
    end

    def self.all
      table.map {|row| Data.new(row)}
    end

    def self.find_or_create_by(payload)
      # payload['parameters'] = clean_payload_parameters(payload)
      create(payload) unless duplicate?(payload)
      row = find_by_payload(payload)
      Data.new(row)
    end

    def self.clean_payload_parameters(payload)
      if payload['parameters'].empty?
        payload['parameters'] = ''
      else
        payload['parameters'] = payload['parameters'].join(',')
      end
    end

    def self.create(payload)
      # fields below need to be updated:
      # referral_id
      # request_type
      # event_id
      # user_agent_id
      # resolution_id
      # source_id

      table.insert(
      :url_id           => TrafficSpy::Url.find_or_create_by(:name, payload['url']).id,
      :requested_at     => payload['requestedAt'],
      :responded_in     => payload['respondedIn'],
      :referral_id      => TrafficSpy::Referral.find_or_create_by(:name, payload['referredBy']).id,
      :request_type     => 'GET',
      :params           => payload['parameters'],
      :event_id         => TrafficSpy::Event.find_or_create_by(:name, payload['eventName']).id,
      :user_agent_id    => TrafficSpy::UserAgent.find_or_create_by(:data, payload['userAgent']).id,
      :resolution_id    => TrafficSpy::Resolution.find_or_create_by(payload['resolutionWidth'], payload['resolutionHeight']).id,
      :ip               => payload['ip'],
      :source_id        => TrafficSpy::Source.find_or_create_by(:rootUrl, payload['url'])
      )
    end

    def self.duplicate?(payload)
      !find_by_payload(payload).nil?
    end

    def self.find_by_payload(payload)
      table.select.where(
        :requested_at => payload['requestedAt'],
        :responded_in => payload['respondedIn'],
        :ip => payload['ip']
        ).first
    end
  end
end
