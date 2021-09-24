class Common::PaginatedResponse
  attr_reader :page, :pages, :limit, :count, :records

  def initialize(data:, resource_class: nil, records: nil)
    @page = data['page']
    @count = data['count']
    @pages = data['pages']
    @records = records || data['records'].map { |record| resource_class.new(record) }
  end
end
