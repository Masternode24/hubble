module Common
  class IndexerEvent < Common::Resource
    field :height
    field :time, type: :timestamp
    field :alertable_address
    field :kind
    field :data
    field :from
    field :to
    field :n
    field :m
    field :icon_name
    field :chain_slug
    field :delegators
    field :chain
    field :created_at
    field :action
    field :validator_name
    field :type

    alias timestamp time
    alias action kind

    def initialize(attrs, chain)
      super(attrs)
      @data || @data = {}
      @chain_slug = chain.slug
      @alertable_address = data['actor'] || attrs['actor'] || validator_name
      @chain = chain
    end

    def alertable
      @alertable ||= AlertableAddress.find_by(address: alertable_address)
    end

    def percentage_change(round = true)
      return 100 if from.zero?

      num = to - from
      denom = from.to_f
      change = (num / denom) * 100.0
      round ? change.round(1) : change
    end

    def delta
      (to - from).to_f
    end

    def added?
      data['status'] == 'added'
    end

    def kind_class
      self.class.name.split('::').last.underscore
    end
  end
end
