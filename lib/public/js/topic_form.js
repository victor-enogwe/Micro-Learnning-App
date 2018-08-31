function topicForm({ urlParams, el, formId, data }) {
  const TopicModel = Backbone.Model.extend({
    urlRoot: () => `/api/v1/auth/courses/${urlParams}/topics`,
    parse: parseModelData
  });

  const topicFormView = Backbone.Form.extend({
    template: _.template($('#topic_form').html()).bind(this, { formId, user: currentUser() }),
    schema: { ...courseSchema, url: { type: 'Text', validators: ['required', 'url'] } },
    idPrefix: `${formId}_`,
    model: TopicModel,
    events: {
      [`click #form_${formId}`]: e => e.preventDefault(),
      [`click #form_delete_${formId}`]: deleteTopic,
      [`click #form_submit_${formId}`]: saveTopic
    }
  });

  function parseModelData(res) {
    const { created_at, updated_at, ...rest } = res.data.topic
    return rest;
  }

  function saveTopic(e) {
    e.preventDefault();
    const errors = this.commit({ validate: true });
    if (!errors) {
      this.model.save(null, { success });
    }
  }

  function deleteTopic(e) {
    e.preventDefault();
    return sDeleteConfirm({}).then((result) => {
      if (result) {
        swal.showLoading();
        return this.model.destroy({
          success: (...args) => {
            $(`#${formId}_panel`).remove();
            return success(...args);
          }
        });
      }
    })

  }

  function success(model, response) {
    return swal({
      title: 'Great!',
      text: `operation successful`,
      type: 'success',
      allowOutsideClick: false,
      allowEscapeKey: false,
      confirmButtonText: 'Continue',
      confirmButtonClass: 'btn btn-primary btn-block',
    }).then(() => {
      if($(`#form_submit_${formId}`)) $(`#form_submit_${formId}`).text('Update Topic');
    });
  }
  const topicModel = new TopicModel(data);
  const topic = new topicFormView({ model: topicModel });
  topic.on('title:change', function(form, titleEditor, extra) {
    $(`#form_${formId} span`).text(titleEditor.getValue());
  });

  topic.render();
  $(el).append(topic.el);
  if (data) {
    $(`#form_${formId} span`).text(data.title);
    $(`#form_submit_${formId}`).text('Update Topic');
  }
}
