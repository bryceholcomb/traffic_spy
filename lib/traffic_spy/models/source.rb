module TrafficSpy
  class Source
    def self.new_identifier?(params)
      DB.from(:sources).select(:id).where(:identifier => params['identifier']).to_a.empty?
    end

    def self.insert(params)
      DB.from(:sources).insert(:identifier => params['identifier'], :rootUrl => params['rootUrl'])
    end

    def self.find(params)
      params.find { |k,v| k == 'identifier' }
    end
  end
end
