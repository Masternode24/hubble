class AddValidatorEventDefsToNearChains < ActiveRecord::Migration[5.2]
  def change
    change_table :near_chains do |t|
      t.jsonb "validator_event_defs", default: [{"kind"=>"active_set_inclusion", "height"=>0}, {"kind"=>"kicked","height"=>0}]
    end
  end
end
