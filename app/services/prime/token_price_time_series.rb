module Prime
  class TokenPriceTimeSeries < Common::Resource
    field :tohlcv_values
    field :success, default: true

    alias success? success

    def initialize(attr)
      super(attr)
      @tohlcv_values = attr['data']['values'] if attr['success'].nil?
      # attr['success'].nil? ? @tohlcv_values = attr['data']['values'] : @tohlcv_values = []
    end

    def self.failed
      new({ 'success' => false })
    end
  end
end
