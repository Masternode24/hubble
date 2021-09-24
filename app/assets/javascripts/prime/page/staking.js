$(document).ready(function() {
  if (!App.mode.includes('prime-staking')) {
    return;
  }

  // Highlight code examples in the API docs
  if (hljs) {
    hljs.highlightAll();
  }

  $('a.reveal').click(function(e) {
    e.preventDefault();

    $(this).parent().find('.blurred').removeClass('blurred');
    $(this).remove();
  });
});
