module TrafficSpy
  class Source
    attr_reader :id, :identifier, :root_url

    def initialize(data)
      @id = data[:id]
      @identifier = data[:identifier]
      @root_url = data[:rootUrl]
    end

    def self.all
      table.map {|row| Source.new(row)}
    end

    def self.new_identifier?(params)
      table.select(:id).where(:identifier => params['identifier']).to_a.empty?
    end

    def self.create(params)
      table.insert(:identifier => params['identifier'], :rootUrl => params['rootUrl'])
    end

    def self.find(params)
      params.find { |k,v| k == 'identifier' }
    end

    def self.find_by(identifier)
      row = table.select.where(:identifier => identifier).first
      row.nil? ? nil : Source.new(row)
    end

    def self.relative_path_exists?(identifier, relative, path=nil)
      true
    end

    private

    def self.table
      DB.from(:sources)
    end
  end
end
