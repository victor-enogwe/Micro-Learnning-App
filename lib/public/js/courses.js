function coursesPage ({ categoryId, creatorId, userId }) {
  const CategoryCollection = categoryModelCollection().CategoryCollection
  const categoryCollection = new CategoryCollection();
  const CourseModel = Backbone.Model.extend();
  const CourseCollection = Backbone.Collection.extend({
    url: userId ? `/api/v1/auth/users/${userId}/courses` : '/api/v1/courses',
    model: CourseModel,
    parse(data) {
      swal.close();
      courses.count = data.data.count;
      return data.data.courses
    }
  });

  function success(response, model) {
    courses.render()
  }

  function fetchCourses(col, page, category_id = categoryId, creator_id = creatorId, user_id = userId) {
    const data = { offset: 5 * page, limit: 5 };
    if (category_id) data.category_id = category_id
    if (creator_id) data.creator_id = creator_id
    if (user_id) data.user_id = user_id
    return col.fetch({ success, data })
  }

  function loadMore(more) {
    courses.page += more ? 1 : -1;
    return fetchCourses(collection, courses.page);
  }

  function generatePageName(courses) {
    if (courses.length) {
      if (userId) return { title: 'My Courses', description: 'courses you\'ve enroled in' };
      if (creatorId) return { title: 'Author', description: courses[0].creator.name };
      if (categoryId) return { title: 'Category', description:  courses[0].category.name };
    }
    return  { title: 'Library', description: 'Browse through thousands of courses.'}
  }

  const CoursesView = Backbone.View.extend({
    el: '#main',
    template: _.template($('#courses').html()),
    page: 0,
    count: 0,
    category_id: 3,
    categories: [],
    initialize() {
      fetchCourses(this.collection, 0);
      this.render();
    },
    events: {
      'click #load_more_prev': loadMore.bind(null, false),
      'click #load_more_next': loadMore.bind(null, true),
      'change #categories': (e) => {
        const value = e.target.value;
        const link =  value ? `/courses/categories/${value}` : '/courses'
        router.navigate(link, { trigger: true })
      }
    },
    render() {
      return this.$el.html(this.template({
        courses: this.collection.toJSON(),
        count: this.count,
        page: this.page,
        categories: [...this.categories, { name: 'ALL', id: '' }],
        categoryId,
        creatorId: currentUser().id,
        equality: (a, b) => a === b,
        name: generatePageName(this.collection.toJSON())
      }));
    }
  });

  categoryCollection.fetch({
    success(model, response) {
      courses.categories = response.data.categories
      courses.render();
    }
  });

  const collection = new CourseCollection();
  const courses = new CoursesView({ collection });
}
