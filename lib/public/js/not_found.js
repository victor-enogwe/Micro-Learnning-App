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

  if (document.getElementById('child-with-box-svg')) {
    let svg = Snap("#child-with-box-svg");
    Snap.load("images/404-child-with-box.svg", function (f) {
      g = f.select("g");
      g.attr({ transform: 't0,0 s1' });
      svg.append(g);
    });
    console.clear();
  }
}
