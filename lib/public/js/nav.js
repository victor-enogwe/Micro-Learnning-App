const NavView  = Backbone.View.extend({
  el: '.navbar',
  template: _.template($('#navbar').html()),
  authEvent,
  initialize() {
    this.render();
    this.authEvent.bind('auth:event', this.render, this);
  },
  render() {
    const authed = window.localStorage.getItem('token') !== null;
    return this.$el.html(this.template({ authed }));
  },
  events: {
    'click #logout': () => logout(router, '/')
  }
});

const navbar = new NavView();
