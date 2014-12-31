module TrafficSpy
  class Url
    attr_reader :id, :name

    def initialize(data)
      @id   = data[:id]
      @name = data[:name]
    end

    def self.table
      DB.from(:urls)
    end

    def self.create(data)
      table.insert(
        :name => data
      )
    end

    def self.all
      table.map { |row| Url.new(row) }
    end

    def self.find_id_by_name(name)
      row = table.select.where(name: name).first
      x = Url.new(row)
    end
  end
end
