import React, {useState, useEffect} from 'react';
import {useWizard} from 'react-use-wizard';
import ButtonWithLoader from '../../components/button-with-loader';

const WithdrawalAddressStep = ({positionWithdrawalAddress, withdrawalAddressConfirmation, setWithdrawalAddressConfirmation}) => {
  const {nextStep, isLoading} = useWizard();

  const [addressValid, setAddressValid] = useState(false);

  useEffect(() => {
    setAddressValid(positionWithdrawalAddress.toLowerCase() === withdrawalAddressConfirmation.trim().toLowerCase());
  }, [withdrawalAddressConfirmation]);

  return (
    <>
      <div className='box__content'>
        <div className='step__title'>
          <h3>Please confirm the withdrawal address for this position</h3>
        </div>
        <div className='eth2-staking-app__withdrawal-address-wrapper'>
          <input
            type="text"
            className={`input form__input ${(addressValid && 'input--valid')}`}
            value={withdrawalAddressConfirmation}
            onChange={(e) => setWithdrawalAddressConfirmation(e.target.value)}
          />
        </div>
        <p className='eth-staking-app__withdrawal-address-note'>
          <strong>Important:</strong> It is absolutely vital that this address is correct! If you do not have
          sole custody of this Ethereum address, or if at any point in the future you lose sole
          custody of it, you risk losing 100% of your deposited ETH!
        </p>
      </div>
      <div className='box__footer'>
        <ButtonWithLoader
          className='button--primary button--danger'
          onClick={() => nextStep()}
          text='Confirm Address'
          isLoading={isLoading}
          disabled={!addressValid}
        />
      </div>
    </>
  );
};

export default WithdrawalAddressStep;
