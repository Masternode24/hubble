## Staking Management

List of endpoints to retrieve information about Staking positions, Validators and other
staking management resources.

### Summary

Returns summary information for staking positions and validators.

Request:

```
GET <%= api_v1_prime_eth2_staking_root_path %>
```

Example:

```shell
curl <%= api_v1_prime_eth2_staking_root_url %> \
  -H 'Authorization: Bearer <%= @api_key %>'
```

Response:

```json
{
  "staked_amount": 204,
  "positions": 4,
  "validators": 6
}
```

### Retrieve Validators

Returns validators associated with your staking account.

Request:

```
GET <%= api_v1_prime_eth2_staking_validators_path %>
```

Example:

```shell
curl <%= api_v1_prime_eth2_staking_validators_url %> \
  -H 'Authorization: Bearer <%= @api_key %>'
```

Response:

```json
[
  {
    "id": "d686e457-b8f5-4eb3-aa88-7a1aadac1135",
    "pubkey": "84be53bbe80e67a91db3570abb6b49e0314e4fa4814af690c35bc89d23d5f66b00d19fb25efed37c72abc22e0994ea8c",
    "withdrawal_credentials": "010000000000000000000000e40f80618324c814cd444434670a44ba4583ae38",
    "amount": "32000000000",
    "signature": "ad845359b04d75897186884eadb8ab7cd36d602dff65eb82e5b79505a2e489914ccef795196627c80da22a4e316958851469ac63fcfba3e6093593da24dd678e175df82ad4e1284664fb3f34be7073ccff3476324614bcfdb87920ad6288e536",
    "deposit_message_root": "2d4e1d75dc9409a74c5e5d1e9aa21aa29ad491d6e0e8dc5ca12375a653195e1a",
    "deposit_data_root": "e706391d219118ce5a7a17fa3aa2a5cb91d31da5c60d9a3e66e0ea9c4dbb2086",
    "fork_version": "00002009",
    "eth2_network_name": "pyrmont",
    "deposit_cli_version": "1.2.0",
    "eth1_withdrawal_address": "0xE40F80618324C814cD444434670a44ba4583aE38"
  }
]
```

### Retrieve Validator

Returns validator details.

Request:

```
GET <%= api_v1_prime_eth2_staking_validator_path(id: "VALIDATOR_ID") %>
```

Example:

```shell
curl <%= api_v1_prime_eth2_staking_validator_url("VALIDATOR_ID") %> \
  -H 'Authorization: Bearer <%= @api_key %>'
```

Response:

```json
{
  "id": "d686e457-b8f5-4eb3-aa88-7a1aadac1135",
  "pubkey": "84be53bbe80e67a91db3570abb6b49e0314e4fa4814af690c35bc89d23d5f66b00d19fb25efed37c72abc22e0994ea8c",
  "withdrawal_credentials": "010000000000000000000000e40f80618324c814cd444434670a44ba4583ae38",
  "amount": "32000000000",
  "signature": "ad845359b04d75897186884eadb8ab7cd36d602dff65eb82e5b79505a2e489914ccef795196627c80da22a4e316958851469ac63fcfba3e6093593da24dd678e175df82ad4e1284664fb3f34be7073ccff3476324614bcfdb87920ad6288e536",
  "deposit_message_root": "2d4e1d75dc9409a74c5e5d1e9aa21aa29ad491d6e0e8dc5ca12375a653195e1a",
  "deposit_data_root": "e706391d219118ce5a7a17fa3aa2a5cb91d31da5c60d9a3e66e0ea9c4dbb2086",
  "fork_version": "00002009",
  "eth2_network_name": "pyrmont",
  "deposit_cli_version": "1.2.0",
  "eth1_withdrawal_address": "0xE40F80618324C814cD444434670a44ba4583aE38"
}
```

### Retrieve Staking Positions

Returns a list of all staking positions associated with your staking account.

Request:

```
GET <%= api_v1_prime_eth2_staking_positions_path %>
```

Example:

```shell
curl <%= api_v1_prime_eth2_staking_positions_url %> \
  -H 'Authorization: Bearer <%= @api_key %>'
```

Response:

```json
[
  {
    "id": "7d5cf55f-ab61-4a8e-8935-451d4f308701",
    "display_name": "Unnamed Position",
    "staked_eth_amount": 44,
    "eth1_withdrawal_address": "0xE40F80618324C814cD444434670a44ba4583aE38",
    "validators": [
      {
        "id": "d686e457-b8f5-4eb3-aa88-7a1aadac1135",
        "pubkey": "84be53bbe80e67a91db3570abb6b49e0314e4fa4814af690c35bc89d23d5f66b00d19fb25efed37c72abc22e0994ea8c",
        "withdrawal_credentials": "010000000000000000000000e40f80618324c814cd444434670a44ba4583ae38",
        "amount": "32000000000",
        "signature": "ad845359b04d75897186884eadb8ab7cd36d602dff65eb82e5b79505a2e489914ccef795196627c80da22a4e316958851469ac63fcfba3e6093593da24dd678e175df82ad4e1284664fb3f34be7073ccff3476324614bcfdb87920ad6288e536",
        "deposit_message_root": "2d4e1d75dc9409a74c5e5d1e9aa21aa29ad491d6e0e8dc5ca12375a653195e1a",
        "deposit_data_root": "e706391d219118ce5a7a17fa3aa2a5cb91d31da5c60d9a3e66e0ea9c4dbb2086",
        "fork_version": "00002009",
        "eth2_network_name": "pyrmont",
        "deposit_cli_version": "1.2.0",
        "eth1_withdrawal_address": "0xE40F80618324C814cD444434670a44ba4583aE38"
      }
    ]
  }
]
```

### Retrieve Staking Position

Returns staking position details for a given ID.

Request:

```
GET <%= api_v1_prime_eth2_staking_position_path('POSITION_ID') %>
```

Example:

```shell
curl <%= api_v1_prime_eth2_staking_position_url('POSITION_ID') %> \
  -H 'Authorization: Bearer <%= @api_key %>'
```

Response:

```json
{
  "id": "7d5cf55f-ab61-4a8e-8935-451d4f308701",
  "display_name": "Unnamed Position",
  "staked_eth_amount": 44,
  "eth1_withdrawal_address": "0xE40F80618324C814cD444434670a44ba4583aE38",
  "validators": [
    {
      "id": "d686e457-b8f5-4eb3-aa88-7a1aadac1135",
      "pubkey": "84be53bbe80e67a91db3570abb6b49e0314e4fa4814af690c35bc89d23d5f66b00d19fb25efed37c72abc22e0994ea8c",
      "withdrawal_credentials": "010000000000000000000000e40f80618324c814cd444434670a44ba4583ae38",
      "amount": "32000000000",
      "signature": "ad845359b04d75897186884eadb8ab7cd36d602dff65eb82e5b79505a2e489914ccef795196627c80da22a4e316958851469ac63fcfba3e6093593da24dd678e175df82ad4e1284664fb3f34be7073ccff3476324614bcfdb87920ad6288e536",
      "deposit_message_root": "2d4e1d75dc9409a74c5e5d1e9aa21aa29ad491d6e0e8dc5ca12375a653195e1a",
      "deposit_data_root": "e706391d219118ce5a7a17fa3aa2a5cb91d31da5c60d9a3e66e0ea9c4dbb2086",
      "fork_version": "00002009",
      "eth2_network_name": "pyrmont",
      "deposit_cli_version": "1.2.0",
      "eth1_withdrawal_address": "0xE40F80618324C814cD444434670a44ba4583aE38"
    }
  ]
}
```
