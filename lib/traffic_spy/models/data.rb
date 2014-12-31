module TrafficSpy
  class Data
    def initialize

    end

    def self.table
      DB.from(:data)
    end

    def self.create_rel_objs(data)
      Url.create(data['url'])
      url = Url.find_id_by_name(data['url'])

    end

    # def self.create(data)
    #   create_rel_objs(data)
    #   table.insert(
    #     :url_id           => url.id
    #     :requested_at     =>
    #     :responded_in     =>
    #     :referral_id      =>
    #     :request_type     =>
    #     :params           =>
    #     :event_id         =>
    #     :user_agent_id    =>
    #     :resolution_id    =>
    #     :ip               =>
    #     :source_id        =>
    #   )
    # end

    def self.duplicate?(payload)
      false
    end
    #
    # def self.url_id(data)
    #   DB.from(:urls).select(:id).where(name: data['url'])
    # end
  end
end
