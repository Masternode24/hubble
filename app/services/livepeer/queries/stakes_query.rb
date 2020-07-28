class Livepeer::Queries::StakesQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(pending_stake) AS pending_stake',
    'SUM(unclaimed_stake) AS unclaimed_stake'
  ].freeze

  def call
    group_by_delegator(filter_by_range(filter_by_delegators(chain.stakes)))
  end

  def filter_by_date(relation)
    relation.where(<<~SQL)
      livepeer_rounds.number = (
          SELECT number
            FROM livepeer_rounds
           WHERE initialized_at <= '#{date_range.end}'
                 AND chain_id = #{chain.id}
        ORDER BY number DESC
           LIMIT 1
      )
    SQL
  end
end