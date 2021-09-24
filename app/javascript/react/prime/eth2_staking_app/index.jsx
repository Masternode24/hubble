import React, {useState} from 'react';
import {Wizard} from 'react-use-wizard';

import ValidatorsStep from './steps/validators-step';
import WithdrawalAddressStep from './steps/withdrawal-address-step';
import WalletStep from './steps/wallet-step';
import SubmitStep from './steps/submit-step';
import ResultStep from './steps/result-step';
import Header from './components/header';

const Eth2StakingApp = ({availableValidatorsCount, withdrawalAddress}) => {
  const [validatorsCount, setValidatorsCount] = useState(1);
  const [withdrawalAddressConfirmation, setWithdrawalAddressConfirmation] = useState('');

  return (
    <Wizard header={<Header />}>
      <ValidatorsStep
        validatorsCount={validatorsCount}
        setValidatorsCount={setValidatorsCount}
        availableValidatorsCount={availableValidatorsCount}
      />
      <WithdrawalAddressStep
        positionWithdrawalAddress={withdrawalAddress}
        withdrawalAddressConfirmation={withdrawalAddressConfirmation}
        setWithdrawalAddressConfirmation={setWithdrawalAddressConfirmation}
      />
      <WalletStep />
      <SubmitStep />
      <ResultStep />
    </Wizard>
  );
};

export default Eth2StakingApp;
