function pageNotFound() {
  const FourZeroFourView  = Backbone.View.extend({
    el: '#main',
    template: _.template($('#not_found').html()),
    initialize() {
      this.render();
    },
    render() {
      return this.$el.html(this.template({
        ...currentUser(),
        formatName: name => name.split(' ').map(n => `${n[0].toUpperCase()}${n.slice(1)}`).join(' ')
      }));
    }
  });

  const notFound = new FourZeroFourView();
}
