module Mina
  class TransactionSearch
    include ActiveModel::Model

    DEFAULT_LIMIT = 25

    attr_accessor :type,
                  :account,
                  :sender,
                  :receiver,
                  :show,
                  :memo,
                  :start_time,
                  :end_time,
                  :after_id,
                  :before_id,
                  :canonical,
                  :limit

    def initialize(attrs = {})
      super(attrs.compact)

      @limit ||= DEFAULT_LIMIT
    end

    def to_hash
      types = (type || []).select(&:present?).join(',')

      {
        type: types,
        account: show.blank? ? account : '',
        sender: show == 'sent' ? account : '',
        receiver: show == 'received' ? account : '',
        memo: memo,
        start_time: start_time,
        end_time: end_time,
        after_id: after_id,
        before_id: before_id,
        limit: limit,
        canonical: canonical == '1' ? canonical : ''
      }.select { |_, v| v.present? }
    end
  end
end
