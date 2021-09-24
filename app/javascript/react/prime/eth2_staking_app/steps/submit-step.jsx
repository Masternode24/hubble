import React from 'react';
import {useWizard} from 'react-use-wizard';
import ButtonWithLoader from "../../components/button-with-loader";

const SubmitStep = ({}) => {
  const {nextStep} = useWizard();

  return (
    <>
      <div className='box__content'>
        Submit Step
      </div>
      <div className='box__footer'>
        <ButtonWithLoader
          className='button--primary'
          onClick={() => nextStep()}
          text='Submit Transaction'
          loadingText='Submitting...'
          isLoading={true}
        />
      </div>
    </>
  );
};

export default SubmitStep;
