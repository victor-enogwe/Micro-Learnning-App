function homePage () {
  const HomeView = Backbone.View.extend({
    el: '#main',
    template: _.template($('#home').html()),
    initialize() {
      this.render();
    },
    render() {
      return this.$el.html(this.template());
    },
  });

  new HomeView();
}
