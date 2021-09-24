import React from 'react';
import {useWizard} from 'react-use-wizard';
import ButtonWithLoader from "../../components/button-with-loader";

const WalletStep = ({}) => {
  const {nextStep, isLoading} = useWizard();

  return (
    <>
      <div className='box__content'>
        Wallet Step
      </div>
      <div className='box__footer'>
        <ButtonWithLoader
          className='button--primary'
          onClick={() => nextStep()}
          text='Continue'
          isLoading={isLoading}
        />
      </div>
    </>
  );
};

export default WalletStep;
