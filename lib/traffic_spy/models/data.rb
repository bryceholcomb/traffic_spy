module TrafficSpy
  class Data
    attr_reader :url_id

    def initialize(data)
     @url_id = data[:url_id]
    end

    def self.table
      DB.from(:data)
    end

    def self.create_rel_objs(data)
      TrafficSpy::Url.create(data['url'])
    end

    def self.create(payload)
      create_rel_objs(payload)
      require 'pry'
      binding.pry
      table.insert(
        :url_id           => TrafficSpy::Url.find_by_name(payload['url']).id
        # :requested_at     =>
        # :responded_in     =>
        # :referral_id      =>
        # :request_type     =>
        # :params           =>
        # :event_id         =>
        # :user_agent_id    =>
        # :resolution_id    =>
        # :ip               =>
        # :source_id        =>
      )
    end

    def self.duplicate?(payload)
      false
    end

    def self.all
      table.map {|row| Data.new(row)}
    end
    #
    # def self.url_id(data)
    #   DB.from(:urls).select(:id).where(name: data['url'])
    # end
  end
end
