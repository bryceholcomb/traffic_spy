module TrafficSpy
  class Referral
    attr_reader :id, :name

    def initialize(data)
      @id   = data[:id]
      @name = data[:name]
    end

    def self.all
      table.map { |row| Referral.new(row) }
    end

    def self.find_or_create_by(attribute, value)
      row = find_by(attribute, value)
      if row.nil?
        create(value)
        row = find_by(attribute, value)
      end
      Referral.new(row)
    end

    private

    def self.table
      DB.from(:referrals)
    end

    def self.create(data)
      table.insert(:name => data)
    end

    def self.find_by(attribute, value)
      table.select.where(attribute => value).first
    end
  end
end
