function topicPage(...urlParams) {
  const userId = currentUser().id
  const [course_id, topic_id] = urlParams;

  const TopicModel = Backbone.Model.extend({
    urlRoot: () => `/api/v1/auth/users/${userId}/courses/${course_id}/topics/${topic_id}`,
    parse: res => res.data.user_course_topic
  });

  const TopicView  = Backbone.View.extend({
    el: '#main',
    template: _.template($('#topic').html()),
    initialize() {
      this.model.fetch({ success: () => [swal.close(), this.render()] })
    },
    render() {
      return this.$el.html(this.template({ user_course_topic: this.model.toJSON() }));
    }
  });

  const model = new TopicModel();
  const topic = new TopicView({ model });
}
