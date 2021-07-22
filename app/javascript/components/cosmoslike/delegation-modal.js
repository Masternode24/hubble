import CommonDelegationModal from '../common/common-delegation-modal';
import Ledger from './ledger';
import {getAccountDetails, broadcastTransaction} from './requests';

export default class DelegationModal extends CommonDelegationModal {
  constructor(target) {
    super(target, new Ledger());

    this.GAS_PRICE = 0.025;
    this.DELEGATION_GAS_WANTED = 150000;
    this.REDELEGATION_GAS_WANTED = 200000;

    this.remoteDenom = this.delegateButton.data('remote-denom');
    this.chainId = this.delegateButton.data('chain-id');
    this.delegateButton.on('click', () => this.startDelegation());
    this.modal.find('.choice-new-delegation').on('click', () => this.showNewDelegation());
    this.modal.find('.choice-redelegate').on('click', (e) => this.submitRedelegation(e));
  }

  async startDelegation() {
    this.showStep('.step-setup');
    this.modal.modal('show');

    try {
      await this.provider.setup();
      this.accountAddress = await this.provider.accountAddress();
      const accountDetails = await getAccountDetails(this.endpoint, this.accountAddress, this.validator);
      this.rewardsBalance = this.remoteDenomAmount(accountDetails.rewards_for_validator);
      this.accountBalance = this.remoteDenomAmount(accountDetails.balances);
      this.accountNumber = parseInt(accountDetails.value.account_number).toString();
      this.sequence = parseInt(accountDetails.value.sequence).toString();
      this.publicKey = accountDetails.value.public_key.value;

      if (this.rewardsBalance > 0) {
        this.showChoice();
      } else {
        this.showNewDelegation();
      }
    } catch (err) {
      this.showError(err);
    }
  }

  showChoice() {
    this.modal.find('.reward-balance').text(this.formatAmount(this.rewardsBalance));
    this.showStep('.step-choice');
  }

  fillNewDelegationForm(delegationStep) {
    super.fillNewDelegationForm(delegationStep);

    const amountField = delegationStep.find('.delegation-amount');
    amountField.on('change input', (e) => {
      this.amount = parseInt(parseFloat(e.target.value) * 10 ** this.tokenFactor);
      delegationStep.find('.transaction-total').text(this.formatAmount(this.amount + this.fee()));

      const toggleValue = this.factoredAmount(this.amount) == this.factoredAmount(this.maxDelegationAmount());
      delegationStep.find('.amount-warning').toggle(toggleValue);
    });

    amountField.val(this.factoredAmount(this.maxDelegationAmount())).change();
    amountField.attr('min', 10 ** (-this.tokenFactor));
    amountField.attr('max', this.factoredAmount(this.maxDelegationAmount()));

    delegationStep.find('.set-max').on('click', (e) => {
      e.preventDefault();
      amountField.val(this.factoredAmount(this.maxDelegationAmount())).change();
    });
  }

  async submitDelegation(e) {
    e.preventDefault();
    this.showStep('.step-confirm');

    try {
      const transaction = await this.provider.signDelegation(
          this.accountNumber, this.accountAddress, this.validator, this.remoteDenom, this.amount,
          this.fee(), this.DELEGATION_GAS_WANTED, this.sequence, this.chainId, this.publicKey
      );
      this.transactionHash = await broadcastTransaction(this.endpoint, transaction);
      this.showComplete();
    } catch (err) {
      this.showError(err);
    }
  }

  async submitRedelegation(e) {
    e.preventDefault();
    this.showStep('.step-confirm');

    try {
      const transaction = await this.provider.signRedelegation(
          this.accountNumber, this.accountAddress, this.validator, this.remoteDenom, parseInt(this.rewardsBalance),
          this.redelegationFee(), this.REDELEGATION_GAS_WANTED, this.sequence, this.chainId, this.publicKey
      );
      this.transactionHash = await broadcastTransaction(this.endpoint, transaction);
      this.showComplete();
    } catch (err) {
      this.showError(err);
    }
  }

  remoteDenomAmount(amounts) {
    return amounts.find((reward) => reward.denom == this.remoteDenom)?.amount ?? 0;
  }

  fee() {
    return this.DELEGATION_GAS_WANTED * this.GAS_PRICE;
  }

  redelegationFee() {
    return this.REDELEGATION_GAS_WANTED * this.GAS_PRICE;
  }

  maxDelegationAmount() {
    return this.accountBalance - this.fee();
  }

  delegationPath() {
    return `${this.endpoint}/transactions/${this.transactionHash}`;
  }
}
