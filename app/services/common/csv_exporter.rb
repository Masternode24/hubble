require 'csv'

class Common::CsvExporter
  OPTIONS = {
    headers: true,
    force_quotes: true,
    row_sep: "\r\n"
  }.freeze

  def initialize(records, attributes)
    @records = records
    @attributes = attributes
  end

  def call
    CSV.generate(OPTIONS) do |csv|
      csv << headers

      records.each do |record|
        csv << record_fields(record)
      end
    end
  end

  private

  attr_reader :records
  attr_reader :attributes

  def headers
    attributes.map do |a|
      header = a.to_s.titlecase
      header.present? && header.include?('Usd') ? header = header.sub!('Usd', 'USD') : header
    end
  end

  def record_fields(record)
    attributes.map { |a| record[a] }
  end
end
