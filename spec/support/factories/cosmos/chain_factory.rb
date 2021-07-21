FactoryBot.define do
  factory :cosmos_chain, class: 'Cosmos::Chain' do
    name { 'CosmosChain' }
    sequence(:slug) { |n| "cosmos-#{n}" }
    ext_id { 'cosmoshub-4' }
    rpc_host { 'localhost' }
    lcd_host { 'localhost' }
    rpc_path { '' }
    lcd_path { '' }
    use_ssl_for_rpc { true }
    use_ssl_for_lcd { true }
    rpc_port { 443 }
    lcd_port { 443 }
    disabled { false }
    testnet { false }
    history_height { 2636453 }
    latest_local_height { 2636453 }
    sdk_version { '0.37.0' }
    token_map { { 'uatom' => { 'factor' => 6, 'display' => 'ATOM', 'primary' => true } } }
    staking_pool { { 'bonded_tokens': '182834628386568', 'not_bonded_tokens': '7416614688611' } }
    last_sync_time { Time.now.utc }
    governance do
      {
        'tally_params': { 'veto': '0.334000000000000000', 'quorum': '0.400000000000000000',
                          'threshold': '0.500000000000000000' }, 'voting_params': { 'voting_period': '1209600000000000' }, 'deposit_params': { 'min_deposit': [{ 'denom': 'uatom', 'amount': '512000000' }], 'max_deposit_period': '1209600000000000' }
      }
    end
    validator_event_defs do
      [{ 'kind' => 'voting_power_change', 'height' => 0 }, { 'kind' => 'n_of_m', 'height' => 0 },
       { 'kind': 'voting_power_change', 'height': 2448928 }, { 'kind': 'active_set_inclusion', 'height': 2448928 }]
    end
  end
end
