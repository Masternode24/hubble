import CosmosApp from 'ledger-cosmos-js';
import TransportWebUSB from '@ledgerhq/hw-transport-webusb';
import {signatureImport} from 'secp256k1';

class Ledger {
  constructor(transport = TransportWebUSB) {
    this.transport = transport;
    this.LEDGER_INTERVAL_MS = 1500;
    this.DELEGATION_MEMO = 'Delegate to your favourite validator with Hubble - https://hubble.figment.io';
    this.PATH = [44, 118, 0, 0, 0];
    this.ERROR_CODE = 0x9000;
  }

  // That's very similar to Mina's Ledger, extract in future
  async setup() {
    if (!await this.transport.isSupported()) {
      throw new Error('Your browser does not support WebUSB, please use a ' +
        'Chromium-based browser like Chrome, Brave or Edge to stake ' +
        'Cosmos with Ledger');
    }
    while (!await this.setupLedgerLoop()) {
      await new Promise((resolve) => setTimeout(resolve, this.LEDGER_INTERVAL_MS));
    }
  }

  async setupLedgerLoop() {
    this.instance = new CosmosApp(await this.transport.create());
    const getVersionResponse = await this.instance.getVersion();
    return getVersionResponse.return_code == this.ERROR_CODE;
  }

  async accountAddress() {
    const response = await this.instance.getAddressAndPubKey(this.PATH, 'cosmos');
    if (response.return_code != this.ERROR_CODE) {
      throw new Error(response.error_message);
    }
    return response.bech32_address;
  }

  async signDelegation(accountNumber, accountAddress, validator, denom, amount,
      fee, gas, sequence, chainId, publicKey) {
    const messages = [
      {
        type: 'cosmos-sdk/MsgDelegate',
        value: {
          amount: {amount: amount.toString(), denom: denom},
          delegator_address: accountAddress,
          validator_address: validator
        }
      }
    ];

    const transaction = this.buildTransaction(messages, fee, denom, gas);

    return await this.signTransaction(transaction, accountNumber, sequence, chainId, publicKey);
  }

  async signRedelegation(accountNumber, accountAddress, validator, denom, amount,
      fee, gas, sequence, chainId, publicKey) {
    const messages = [
      {
        type: 'cosmos-sdk/MsgWithdrawDelegationReward',
        value: {
          delegator_address: accountAddress,
          validator_address: validator
        }
      },
      {
        type: 'cosmos-sdk/MsgDelegate',
        value: {
          amount: {amount: amount.toString(), denom: denom},
          delegator_address: accountAddress,
          validator_address: validator
        }
      }
    ];

    const transaction = this.buildTransaction(messages, fee, denom, gas);

    return await this.signTransaction(transaction, accountNumber, sequence, chainId, publicKey);
  }

  buildTransaction(messages, fee, denom, gas) {
    return {
      msg: messages,
      fee: {
        amount: [
          {
            amount: fee.toString(),
            denom: denom
          }
        ],
        gas: gas.toString()
      },
      memo: this.DELEGATION_MEMO,
      signatures: null
    };
  }

  async signTransaction(transaction, accountNumber, sequence, chainId, publicKey) {
    const txFieldsToSign = {
      account_number: accountNumber.toString(),
      chain_id: chainId,
      fee: transaction.fee,
      memo: transaction.memo,
      msgs: transaction.msg,
      sequence: sequence.toString()
    };

    const response = await this.instance.sign(this.PATH, JSON.stringify(txFieldsToSign));

    if (response.return_code != this.ERROR_CODE) {
      throw new Error(response.error_message);
    }

    const signature = Buffer.from(signatureImport(response.signature), 'hex').toString('base64');

    transaction.signatures = [{
      signature: signature,
      pub_key: {
        type: 'tendermint/PubKeySecp256k1',
        value: publicKey
      }
    }];

    return transaction;
  }
}

export default Ledger;
