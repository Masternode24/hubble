import React from 'react';
import {useWizard} from 'react-use-wizard';

const Header = ({}) => {
  const {isFirstStep, isLastStep, isLoading, previousStep} = useWizard();

  return (
    <div className='box__header'>
      <button
        className='button button--secondary'
        onClick={() => previousStep()}
        disabled={isFirstStep || isLastStep || isLoading}
      >
        Back
      </button>
    </div>
  );
};

export default Header;
