# frozen_string_literal: true
# Calculate results from a Gender-Balance API data file
class GenderScore
  # a single result from the CSV file
  class Result
    MIN_SELECTIONS = 5   # accept gender if at least this many votes
    VOTE_THRESHOLD = 0.8 # and at least this ratio of votes were for it

    attr_reader :row

    def initialize(row)
      @row = row
    end

    def uuid
      row[:uuid]
    end

    def gender
      return if total < MIN_SELECTIONS
      %w(male female other).find { |g| percent(g) >= VOTE_THRESHOLD }
    end

    private

    def total
      row[:total].to_i - row[:skip].to_i
    end

    def percent(gender)
      row[gender.to_sym].to_f / total.to_f
    end
  end

  # Results for an entire CSV file (e.g. from the GenderBalance API)
  def initialize(rawcsv)
    @rawcsv = rawcsv
  end

  def results
    csv.map do |r|
      r.to_h.merge(gender: Result.new(r).gender)
    end
  end

  private

  attr_reader :rawcsv

  def csv
    @csv ||= CSV.parse(rawcsv, headers: true, converters: :numeric, header_converters: :symbol)
  end
end
