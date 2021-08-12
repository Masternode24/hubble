module Avalanche
  class TransactionSearch
    include ActiveModel::Model

    DEFAULT_LIMIT = 25
    PAGE_START = 1

    attr_accessor :type,
                  :account,
                  :sender,
                  :receiver,
                  :show,
                  :memo,
                  :start_time,
                  :end_time,
                  :limit,
                  :page

    def initialize(attrs = {})
      super(attrs.compact)

      @limit ||= DEFAULT_LIMIT
      @page ||= PAGE_START
    end

    def to_hash
      types = (type || []).select(&:present?).join(',')

      {
        type: types,
        address: account,
        memo: memo,
        start_time: start_time,
        end_time: end_time,
        limit: limit
      }.select { |_, v| v.present? }
    end
  end
end
