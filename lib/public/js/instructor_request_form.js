function instructorRequestForm({ user, el }) {
  const InstructorRequestModel = Backbone.Model.extend({
    urlRoot: () => `/api/v1/auth/users/${user.id}/instructor`,
    parse: res => res.data.request,
    defaults: { approved: false, id: null }
  });

  const InstructorRequestFormView = Backbone.View.extend({
    el,
    template: _.template($('#instructor_request_form').html()),
    model: InstructorRequestModel,
    initialize() {
      this.model.fetch({ success: success.bind(this) })
    },
    render() {
      const data = this.model.toJSON();
      return this.$el.html(this.template({ ...data, isNew: data.id === null }));
    },
    events: {
      'click #become_instructor': 'becomeInstuctor'
    },
    becomeInstuctor(e) {
      e.preventDefault();
      this.model.save(null, { success: success.bind(this) });
    }
  });


  function success(model, response) {
    swal.close();
    this.render();
  }

  const instructorRequestModel = new InstructorRequestModel();
  const instructorRequestForm = new InstructorRequestFormView({ model: instructorRequestModel });
}
