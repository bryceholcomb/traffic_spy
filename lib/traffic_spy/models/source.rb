module TrafficSpy
  class Source
    attr_reader :id, :identifer, :root_url

    def initialize(data)
      @id = data[:id]
      @identifier = data[:identifier]
      @root_url = data[:rootUrl]
    end

    def self.new_identifier?(params)
      DB.from(:sources).select(:id).where(:identifier => params['identifier']).to_a.empty?
    end

    def self.insert(params)
      DB.from(:sources).insert(:identifier => params['identifier'], :rootUrl => params['rootUrl'])
    end

    def self.find(params)
      params.find { |k,v| k == 'identifier' }
    end

    def self.find_by(identifier)
      row = table.select.where(:identifier => identifier).first
      
      Source.new(row)
    end

    private

    def self.table
      DB.from(:sources)
    end
  end
end
