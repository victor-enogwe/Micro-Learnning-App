function courseSavePage(urlParams) {
  const CategoryCollection = categoryModelCollection().CategoryCollection

  const CourseModel = Backbone.Model.extend({
    urlRoot: () => '/api/v1/auth/courses',
    parse: parseModelData
  });

  function parseModelData(res) {
    const {
      created_at,
      updated_at,
      topics,
      creator,
      category,
      ...rest
    } = res.data.course;
    return rest;
  }

  function submit(e) {
    if (e.preventDefault) e.preventDefault();
    const errors = this.commit({ validate: true });
    if (!errors) {
      this.model.save(null, { success: successSave });
    }
  }

  const success = (model, response) => swal({
    title: 'Great!',
    text: `course was successfully ${urlParams ? 'updated!' : 'created!'}`,
    type: 'success',
    allowOutsideClick: false,
    allowEscapeKey: false,
    confirmButtonText: urlParams ? 'Continue' : 'Proceed To Edit Course!',
    confirmButtonClass: 'btn btn-primary btn-block',
  });

  const successSave = (model, response) => success(model, response).then(() => {
    const { data: { course: { id } } } = response;
    if (!urlParams) return Backbone.history.navigate(`/dashboard/courses/${id}`, { trigger: true });
    return $('.nav-tabs > .active').next('li').find('a').trigger('click');
  });

  const successDelete = (model, response) => success(model, response).then(() => {
    return Backbone.history.navigate(`/dashboard/courses`, { trigger: true });
  })

  function nextTab (e) {
    if (e) e.preventDefault();
    $('.prev_tab').prop('disabled', false);
    $('#new_topic').show();
    $('.next_tab').hide();
  }

  function prevCourse(e) {
    if (e) e.preventDefault();
    $('.prev_tab').prop('disabled', true);
    $('#new_topic').hide();
    $('.next_tab').show();
  }

  prevTab = (e) => {
    e.preventDefault();
    $('.next_tab').show();
    $('.nav-tabs > .active').prev('li').find('a').trigger('click');
  }

  function addNewTopic(e) {
    if (e.preventDefault) e.preventDefault();
    return topicForm({
      urlParams,
      el: '#topics .panel-group',
      data: e.target ? undefined : e,
      formId: `topic_${Date.now()}`
    });
  }

  function deleteCourse(e) {
    if (e.preventDefault) e.preventDefault();
    return sDeleteConfirm({}).then((result) => {
      if (result.value) {
        swal.showLoading();
        return course.model.destroy({ success: successDelete })
      }
    })
  }

  const template = _.template($('#course_page').html())
    .bind(null, { display: urlParams, user: currentUser() });

  const CourseView = Backbone.Form.extend({
    template,
    model: CourseModel,
    schema: {
      ...courseSchema,
      category_id: {
        type: 'Select',
        title: 'Category',
        options: new CategoryCollection(),
        validators: ['required']
      }
    },
    events : {
      'click .next_tab': submit,
      'click .prev_course': prevCourse,
      'click .next_topic': nextTab,
      'click .prev_tab': prevTab,
      'click #new_topic': addNewTopic,
      'click #delete_course': deleteCourse
    },
    initialize(...args) {
      const self = this;
      const fetchConfig = urlParams ? { url: `/api/v1/courses/${urlParams}` } : {}
      if (urlParams) {
        return courseModel.fetch({
          ...fetchConfig,
          success(model, res) {
            const { created_at, updated_at, topics, ...rest } = res.data.course;
            swal.close();
            Backbone.Form.prototype.initialize.call(self, ...args);
            self.render()
            $('#main').html(self.el);
            _.each(topics, addNewTopic);
          }
        });
      }
      Backbone.Form.prototype.initialize.call(self, ...args);
      self.render()
      $('#main').html(self.el);
    }
  });
  const courseModel = new CourseModel();
  const course = new CourseView({ model: courseModel });
}
