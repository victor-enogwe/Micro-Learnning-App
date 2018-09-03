function instructorRequests({ user, el }) {
  const InstructorRequestModel = Backbone.Model.extend();
  let count = 0;
  const InstructorRequestCollection = Backbone.Collection.extend({
    url: '/api/v1/auth/instructor-requests',
    model: InstructorRequestModel,
    parse: (res) => {
      count = res.data.count;
      return res.data.requests
    }
  });

  const InstructorRequestsView = Backbone.View.extend({
    el,
    page: 0,
    template: _.template($('#instructor_requests').html()),
    initialize() {
      this.listenTo(this.collection, 'change reset add remove', this.render);
      fetchRequests.call(this, { page: this.page })
      this.render()
    },
    render() {
      swal.close();
      return this.$el.html(this.template({
        count,
        page: this.page,
        requests: this.collection.toJSON()
      }));
    },
    events: {
      'click #load_requests_more_prev': 'loadMore',
      'click #load_requests_more_next': 'loadMore',
      'click .action': 'approveInstuctor'
    },
    approveInstuctor(e) {
      e.preventDefault();
      const approve = e.currentTarget.text.toLowerCase().trim() === 'approve';
      const id = e.currentTarget.dataset.id;
      const user_id = e.currentTarget.dataset.userId;
      const model = this.collection.get(id);
      if (approve) model.save({ user_id }, { success: success.bind(this), patch: true });
      if (approve) return this.collection.remove(id, { silent: true });
      return model.destroy({ success: success.bind(this) })
    },
    loadMore(more) {
      this.page += /more_next/.test(more.currentTarget.id) ? 1 : -1;
      return fetchRequests.call(this, { page: this.page });
    }
  });

  function fetchRequests({ page = 0 }) {
    const data = { offset: 5 * page, limit: 5 };
    return this.collection.fetch({ data });
  }

  function success() {
    swal.close();
    this.render();
  }

  const collection = new InstructorRequestCollection();
  const instructorRequestsView = new InstructorRequestsView({ collection });
}
