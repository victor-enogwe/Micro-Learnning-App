function coursePage(urlParams) {
  const {
    UserCourseCollection, UserCourseModel
  } = UserCoursesModelCollection(currentUser().id, urlParams);
  const CourseModel = Backbone.Model.extend({
    urlRoot: () => `/api/v1/courses/${urlParams}`,
    parse: res => res.data.course
  });

  function success(model, res) {
    const id = model.previousAttributes().id;
    const self = this;
    return swal({
      title: 'Great!',
      text: `enrolment ${id ? 'updated!' : 'successful!'}`,
      type: 'success',
      allowOutsideClick: false,
      allowEscapeKey: false,
      confirmButtonText: 'Continue',
      confirmButtonClass: 'btn btn-success btn-block',
    }).then(() => self.render());
  }

  function enrolCourse() {
    const self = this;
    const {
      learning_interval_days = 1, daily_delivery_time = 1
    } = this.collection.userCourseCollection.toJSON()[0] || {};
    return swal.mixin({
      confirmButtonText: 'Next &rarr;',
      showCancelButton: true,
      allowOutsideClick: false,
      allowEscapeKey: false,
      progressSteps: ['1', '2', '3']
    }).queue([
      {
        title: 'Learning Interval In Days?',
        text: 'how many days should elapse before we send you a new topic on this course?',
        input: 'range',
        inputAttributes: {
          min: 1,
          max: 10,
          step: 1
        },
        inputValue: learning_interval_days
      },
      {
        title: 'Time Of Day To Learn',
        text: 'what time of the day would you like to receive topics on this course?',
        input: 'select',
        inputOptions: Array.from(Array(24).keys()).reduce((a, b) => ({ ...a, [b]: b })),
        inputPlaceholder: 'Select time(24 hr time)',
        inputValidator: value => new Promise(resolve => (
          value ? resolve() : resolve('You need to select a time!')
        )),
        inputValue: daily_delivery_time
      }
    ]).then(function(result) {
      if (result.value) {
        const [learning_interval_days, daily_delivery_time] = result.value.map(v => +v);
        const data = {
          registration_date: new Date(),
          learning_interval_days,
          daily_delivery_time,
          course_id: +urlParams
        };
        swal.showLoading();
        let oldData = self.collection.userCourseCollection
          .findWhere({ user_id: +currentUser().id, course_id: +urlParams });
        oldData = oldData ? oldData.toJSON() : {};
        self.collection.userCourseCollection.set({ ...oldData, ...data })
          .save({}, { success: success.bind(self) });
      }
    });
  }

  function deleteEnrolment() {
    const self = this;
    const model = self.collection.userCourseCollection
      .findWhere({ user_id: +currentUser().id, course_id: +urlParams });
    return sDeleteConfirm({}).then(function(result) {
      if (result.value) {
        swal.showLoading();
        return model.destroy({ success: successDestroy.bind(self) });
      }
    });
  }

  function successDestroy() {
    const self = this;
    return swal({
      type: 'info',
      title: 'Done!',
      text: 'You have are no longer enroled for this course',
      confirmButtonText: 'Close',
      showCancelButton: false,
      allowOutsideClick: false,
      allowEscapeKey: false,
    }).then(() => self.render());
  }

  const CourseView = Backbone.View.extend({
    el: '#main',
    template: _.template($('#course').html()),
    initialize() {
      Promise.all([
        this.model.get('courseModel').fetch(),
        this.collection.userCourseCollection.fetch()
      ]).then(() => this.render()).then(swal.close);
    },
    render() {
      return this.$el.html(this.template({
        course: this.model.get('courseModel').toJSON(),
        user_course: this.collection.userCourseCollection.toJSON()[0],
        capitalize: (names) => _.each(names
          .split(' '), name => `${name[0].toUpperCase()}${name.slice(1)}`)
          .join(' '),
        equality: (a, b) => a === b,
        user: currentUser()
      }));
    },
    events: {
      'click #enrol': enrolCourse,
      'click #stop_course': deleteEnrolment
    }
  });
  const model = new Backbone.Model();
  const courseModel = new CourseModel();
  const userCourseCollection = new UserCourseCollection();
  model.set({ courseModel });
  const course = new CourseView({ model, collection: { userCourseCollection } });
}
