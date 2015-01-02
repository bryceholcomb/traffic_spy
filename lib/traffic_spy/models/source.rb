module TrafficSpy
  class Source
    attr_reader :id, :identifier, :rootUrl

    def initialize(data)
      @id = data[:id]
      @identifier = data[:identifier]
      @rootUrl = data[:rootUrl]
    end

    def self.all
      table.map {|row| Source.new(row)}
    end

    def self.find(params)
      params.find { |k,v| k == 'identifier' }
    end

    def self.find_or_create_by(attribute, value)
      row = find_by(attribute, to_root_url(value))
      if row.nil?
        create(to_root_url(value))
        row = find_by(attribute, to_root_url(value))
      end
      Source.new(row)
    end

    def self.new_identifier?(params)
      table.select(:id).where(:identifier => params['identifier']).to_a.empty?
    end

    private

    def self.table
      DB.from(:sources)
    end

    def self.create(params)
      table.insert(:identifier => params['identifier'],
                   :rootUrl => params['rootUrl'])
    end

    def self.find_by(attribute, value)
      table.select.where(attribute => value).first
    end

    def self.to_root_url(url)
      url.scan(/.*.com/).first
    end
  end
end
