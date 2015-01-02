module TrafficSpy
  class Resolution
    attr_reader :id, :width, :height

    def initialize(data)
      @id   = data[:id]
      @width = data[:width]
      @height = data[:height]
    end

    def self.all
      table.map { |row| Resolution.new(row) }
    end

    def self.find_or_create_by(value1, value2)
      row = find_by(value1, value2)
      if row.nil?
        create(value1, value2)
        row = find_by(value1, value2)
      end
      Resolution.new(row)
    end

    private

    def self.table
      DB.from(:resolutions)
    end

    def self.create(value1, value2)
      table.insert(:width => value1, :height => value2)
    end

    def self.find_by(value1, value2)
      table.select.where(:width => value1).where(:height => value2).first
    end
  end
end
