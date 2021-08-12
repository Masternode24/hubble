$(document).ready(function() {
  if (!_.includes(App.mode, 'events-index')) {
    return;
  }
  new App.Common.EventsTable($('.events-table')).render();
});
