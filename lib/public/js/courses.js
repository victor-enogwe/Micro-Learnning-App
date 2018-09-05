function coursesPage ({ categoryId, creatorId, userId }) {
  const CategoryCollection = categoryModelCollection().CategoryCollection
  const categoryCollection = new CategoryCollection();
  const { CourseCollection, CourseModel } = courseModelCollection(userId)

  function fetchCourses({ page = 0, categoryId, creatorId, userId }) {
    const data = { offset: 5 * page, limit: 5 };
    if (categoryId) data.category_id = categoryId
    if (creatorId) data.creator_id = creatorId
    if (userId) data.user_id = userId
    return this.collection.courseCollection.fetch({ data, success: success.bind(this) })
  }

  function success() {
    this.render();
  }

  function getCategoryById(categories, id) {
    const cat = { name: 'Courses', description: 'Browse through thousands of courses.' }
    return categories.filter(category => category.id === +id)[0] || cat
  }

  function generatePageName() {
    const description = 'Browse through thousands of courses.'
    const categories = this.collection.categoryCollection.toJSON();
    const courses = this.collection.courseCollection.toJSON()[0].courses;

    if (userId) return { title: 'My Courses', description: 'courses you\'ve enroled in' };
    if (creatorId) return { title: 'Author', description: courses[0] ? courses[0].creator.name : description };
    if (categoryId) {
      const category = getCategoryById(categories, categoryId)
      return { title: category.name, description: category.description }
    }

    return  { title: 'Courses', description }
  }

  const CoursesView = Backbone.View.extend({
    el: '#main',
    template: _.template($('#courses').html()),
    page: 0,
    category_id: 3,
    initialize() {
      this.collection.categoryCollection.fetch({
        success: fetchCourses.bind(this, { categoryId, creatorId, userId })
      });
    },
    render() {
      const { count = 0, courses = [] } = this.collection.courseCollection.toJSON()[0];
      return this.$el.html(this.template({
        courses,
        count,
        page: this.page,
        categories: [{ name: 'ALL', id: '' }, ...this.collection.categoryCollection.toJSON()],
        categoryId,
        userId,
        creatorId: currentUser().id,
        equality: (a, b) => a === b,
        meta: generatePageName.call(this)
      }));
    },
    events: {
      'click #load_more_prev': 'loadMore',
      'click #load_more_next': 'loadMore',
      'change #categories': (e) => {
        const value = e.target.value;
        const link =  value ? `/courses/categories/${value}` : '/courses'
        Backbone.history.navigate(link, { trigger: true })
      }
    },
    loadMore(more) {
      courses.page += /more_next/.test(more.currentTarget.id) ? 1 : -1;
      $("html, body").animate({ scrollTop: 0 }, "slow");
      return fetchCourses.call(this, { page: courses.page, categoryId, creatorId, userId });
    }
  });

  const courseCollection = new CourseCollection();
  const courses = new CoursesView({ collection: { courseCollection,  categoryCollection } });
}
