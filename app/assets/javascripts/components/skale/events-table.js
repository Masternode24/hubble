class EventsTable {
  constructor(container) {
    this.container = container;
    this.searchBox = $('.events-search');
  }
  search() {
    const term = `${this.searchBox.val()}`;
    this.table.search(term).draw();
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: false,
      info: false,
      autoWidth: false,
      order: [
        [1, 'desc']
      ],
      className: 'events-table'
    });

    this.searchBox.keyup(() => this.search(this.table));
    this.search(this.table);
  }
}

window.App.Skale.EventsTable = EventsTable;
