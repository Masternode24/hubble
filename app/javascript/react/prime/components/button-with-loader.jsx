import React from 'react';

const ButtonWithLoader = ({isLoading, text, loadingText, ...props}) => {
  const {className, ...otherProps} = props;
  const classNames = [isLoading && 'button--loading', 'button', className].join(' ');

  return (
    <button
      className={classNames}
      disabled={isLoading}
      {...otherProps}
    >
      {(isLoading ? (loadingText || 'Fetching...') : text)}
    </button>
  );
};

export default ButtonWithLoader;
