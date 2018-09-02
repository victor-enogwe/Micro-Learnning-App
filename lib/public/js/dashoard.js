function dashboardPage() {
  const user = currentUser();
  const { CourseCollection, CourseModel } = courseModelCollection(user.id);
  const DashboardView  = Backbone.View.extend({
    el: '#main',
    template: _.template($('#dashboard').html()),
    initialize() {
      this.render();
    },
    render() {
      this.collection.courseCollection.fetch({
        data: { user_id: user.id, offset: 0, limit: 5 },
        success: success.bind(this)
      });
    }
  });

  function success() {
    this.$el.html(this.template({
      ...user,
      courses: this.collection.courseCollection.toJSON(),
      formatName: name => name.split(' ').map(n => `${n[0].toUpperCase()}${n.slice(1)}`).join(' ')
    }));

    profileForm({ user, el: '#update_profile_form' });
  }

  const courseCollection = new CourseCollection();
  const dashboard = new DashboardView({ collection: { courseCollection } });
}
