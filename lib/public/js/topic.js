function topicPage(...urlParams) {
  const [course_id, topic_id] = urlParams;

  const TopicModel = Backbone.Model.extend({
    urlRoot: () => `/api/v1/auth/courses/${course_id}/topics/${topic_id}`
  });

  const TopicView  = Backbone.View.extend({
    el: '#main',
    template: _.template($('#topic').html()),
    initialize() {
      this.model.fetch({ success: this.render })
    },
    render() {
      return this.$el.html(this.template({ topic: this.model.toJSON() }));
    }
  });

  const model = new TopicModel();
  const topic = new TopicView({ model });
}
