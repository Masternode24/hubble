## Authentication

The Staking management API uses API keys to authenticate requests. You can view and manage your API keys in the [Staking Dashboard](<%= prime_eth2_staking_url %>)

Authentication to the API is performed via token bearer auth. Provide your API key as the `Authorization: Bearer <TOKEN>` HTTP header value.

All API requests must be made over HTTPS. Calls made over plain HTTP will fail. Any requests without authentication will also fail.

Using bearer auth:

```shell
curl <%= api_v1_prime_eth2_staking_validators_url %> \
  -H 'Authorization: Bearer <%= @api_key %>'
```

You can also authenticate using a URL param `api_key`:

```shell
curl <%= api_v1_prime_eth2_staking_validators_url(api_key: @api_key) %>
```

When an invalid API key is provided for the request, you'll get an error message:

```json
{
  "status": 401,
  "message": "Invalid API key"
}
```
