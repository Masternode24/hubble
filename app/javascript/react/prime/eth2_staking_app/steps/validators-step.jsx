import React, {useEffect, useRef} from 'react';
import {useWizard} from 'react-use-wizard';
import Slider from 'rc-slider';

import ButtonWithLoader from '../../components/button-with-loader';

const ValidatorsStep = ({validatorsCount, setValidatorsCount, availableValidatorsCount}) => {
  const MIN_VALIDATORS_COUNT = 1;
  const MAX_VALIDATORS_COUNT = Math.min(availableValidatorsCount, 100);

  const ETH_AMOUNT_STEP = 32;
  const MIN_ETH_AMOUNT = ETH_AMOUNT_STEP;
  const MAX_ETH_AMOUNT = ETH_AMOUNT_STEP * MAX_VALIDATORS_COUNT;

  const createSliderWithTooltip = Slider.createSliderWithTooltip;
  const SliderWithTooltip = createSliderWithTooltip(Slider);

  const {nextStep, isLoading} = useWizard();
  const ethAmountInput = useRef(null);

  const calculateValidatorsCount = (initialValue) => {
    let amount = initialValue;
    amount = Math.max(amount, MIN_ETH_AMOUNT);
    amount = Math.min(amount, MAX_ETH_AMOUNT);

    return Math.floor(amount / ETH_AMOUNT_STEP);
  };

  const handleEthAmountChange = (event) => {
    setValidatorsCount(calculateValidatorsCount(event.target.value));
  };

  const adjustEthAmountInputValue = (event) => {
    ethAmountInput.current.value = calculateValidatorsCount(event.target.value) * ETH_AMOUNT_STEP;
  };

  return (
    <>
      <div className='box__content'>
        <div className='step__title'>
          <h3>How many validators do you wish to fund?</h3>
        </div>
        <div className='eth2-staking-app__slider-wrapper'>
          <SliderWithTooltip
            min={MIN_VALIDATORS_COUNT}
            max={MAX_VALIDATORS_COUNT}
            onAfterChange={(number) => setValidatorsCount(number)}
            onChange={(number) => (ethAmountInput.current.value = number * ETH_AMOUNT_STEP)}
            defaultValue={validatorsCount}
            marks={{
              [MIN_VALIDATORS_COUNT]: MIN_VALIDATORS_COUNT,
              [MAX_VALIDATORS_COUNT]: MAX_VALIDATORS_COUNT
            }}
            tipProps={{visible: true}}
          />
        </div>
        <div className='eth2-staking-app__eth-amount-wrapper'>
          <span>or</span>
          <input
            type="number"
            className='input form__input'
            min={MIN_ETH_AMOUNT}
            max={MAX_ETH_AMOUNT}
            step={ETH_AMOUNT_STEP}
            defaultValue={validatorsCount * ETH_AMOUNT_STEP}
            ref={ethAmountInput}
            onChange={handleEthAmountChange}
            onBlur={adjustEthAmountInputValue}
          />
          <span>ETH</span>
        </div>
      </div>
      <div className='box__footer'>
        <ButtonWithLoader
          className='button--primary'
          onClick={() => nextStep()}
          text='Continue'
          isLoading={isLoading}
          disabled={validatorsCount < MIN_VALIDATORS_COUNT || validatorsCount > MAX_VALIDATORS_COUNT}
        />
      </div>
    </>
  );
};

export default ValidatorsStep;
