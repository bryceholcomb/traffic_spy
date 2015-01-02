module TrafficSpy
  class UserAgent
    attr_reader :id, :data, :os, :browser

    def initialize(data)
      @id   = data[:id]
      @data = data[:data]
      @os = data[:os]
      @browser = data[:browser]
    end

    def self.all
      table.map { |row| UserAgent.new(row) }
    end

    def self.find_or_create_by(attribute, value)
      row = find_by(attribute, value)
      if row.nil?
        create(value)
        row = find_by(attribute, value)
      end
      UserAgent.new(row)
    end

    private

    def self.table
      DB.from(:user_agents)
    end

    def self.create(data)
      parsed_data = parse_data(data)
      table.insert(:data => parsed_data['data'],
                   :os => parsed_data['os'],
                   :browser => parsed_data['browser'])
    end

    def self.find_by(attribute, value)
      table.select.where(attribute => value).first
    end

    def self.parse_data(data)
      os = data.split(/(\(|\))/)[2]
      browser = data.split(' ')[0]
      {'data' => data, 'os' => os, 'browser' => browser}
    end
  end
end
