function dashboardPage() {
  const DashboardView  = Backbone.View.extend({
    el: '#main',
    template: _.template($('#dashboard').html()),
    initialize() {
      this.render();
    },
    render() {
      return this.$el.html(this.template());
    }
  });

  const dashboard = new DashboardView();
}
