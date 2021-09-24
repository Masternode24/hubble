module Prime
  module Anjin
    class Client < ::Common::Client
      def customers
        get('/customers')['data'].map { |record| Customer.new(record) }
      end

      def customer(id)
        Customer.new(get("/customers/#{id}")['data'])
      end

      def staking_positions(opts = {})
        params = {
          include: 'eth2_validators'
        }

        if opts[:customer_id]
          params[:filter] = {
            customer_id_eq: opts[:customer_id]
          }
        end

        resp = get('/staking/eth2/staking_positions', params)

        validators = resp.fetch('included', []).map do |item|
          [item['id'], item['attributes'].merge(id: item['id'])]
        end.to_h

        resp['data'].map do |record|
          record['validators'] = record['relationships']['eth2_validators']['data'].map do |item|
            { id: item['id'], attributes: validators[item['id']] }
          end

          StakingPosition.new(record)
        end
      end

      def staking_position(id)
        resp = get("/staking/eth2/staking_positions/#{id}", include: 'eth2_validators')
        resp['data']['validators'] = resp['included']

        StakingPosition.new(resp['data'])
      end

      def validators
        get('/staking/eth2/validators')['data'].map { |record| Validator.new(record) }
      end

      def validator(id)
        Validator.new(get("/staking/eth2/validators/#{id}")['data'])
      end

      def self.current
        @_current ||= Prime::Anjin::Client.new(
          Rails.application.secrets.figment_anjin[:endpoint],
          authorization: Rails.application.secrets.figment_anjin[:token]
        )
      end
    end
  end
end
