const headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
  'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
};

export const getAccountDetails = async (endpoint, address, validator) => {
  const accountResponse = await fetch(`${endpoint}/accounts/${address}?validator=${validator}`, {
    method: 'GET',
    headers: headers
  });
  const responseJson = await accountResponse.json();

  if (responseJson.error) throw new Error(responseJson.error);

  return responseJson;
};

export const broadcastTransaction = async (endpoint, transaction) => {
  const broadcastResponse = await fetch(`${endpoint}/broadcast`, {
    method: 'POST',
    credentials: 'same-origin',
    headers: headers,
    body: JSON.stringify({payload: transaction})
  });

  const responseJson = await broadcastResponse.json();

  if (!responseJson.ok) throw new Error(responseJson.raw_log);

  return responseJson.txhash;
};
