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

    def self.urls(root_url, relative, path)
      path_name = if path.nil?
        "#{root_url}/#{relative}"
      else
        "#{root_url}/#{relative}/#{path}"
      end
      table.join(:urls, :name => path_name)
    end

    def self.referrals(identifier)
      table.join(:referrals)
    end

    def self.longest_response_time(root_url, relative, path)
      urls(root_url, relative, path).max(:responded_in)
    end

    def self.shortest_response_time(root_url, relative, path)
      urls(root_url, relative, path).min(:responded_in)
    end

    def self.avg_response_time(root_url, relative, path)
      if urls(root_url, relative, path).avg(:responded_in).nil?
        nil
      else
        urls(root_url, relative, path).avg(:responded_in).round(2)
      end
    end

    def self.http_verbs(root_url, relative, path)
      urls(root_url, relative, path).map do |url|
        url[:request_type]
      end.uniq.join(', ')
    end

    def self.most_pop_refs(identifier)
      referrals(identifier).group_and_count(:name, :name).max_by do |referral|
        referral[:count]
      end
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
