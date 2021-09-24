import React from 'react';
import {render} from 'react-dom';
import Eth2StakingApp from '../../../react/prime/eth2_staking_app';

$(document).ready(function() {
  if (!App.mode.includes('prime-eth2-staking-app')) {
    return;
  }

  const node = document.getElementById('eth2_staking_app');
  const data = JSON.parse(node.getAttribute('data'));

  render(<Eth2StakingApp {...data} />, node);
});
