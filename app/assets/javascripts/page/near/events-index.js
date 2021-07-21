$(document).ready(function() {
  if (!_.includes(App.mode, 'events-index')) {
    return;
  }
  new App.Near.EventsTable($('.events-table')).render();
});
