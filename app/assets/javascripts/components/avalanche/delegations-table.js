class DelegationsTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: true,
      autoWidth: false,
      className: 'delegations-table',
      order: [
        [2, 'desc'],
        [3, 'desc']
      ]
    });
  }
}

window.App.Avalanche.DelegationsTable = DelegationsTable;
