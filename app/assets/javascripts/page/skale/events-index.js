$(document).ready(function() {
  if (!_.includes(App.mode, 'events-index')) {
    return;
  }
  new App.Skale.EventsTable($('.events-table')).render();
});
