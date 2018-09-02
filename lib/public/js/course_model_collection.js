function courseModelCollection(userId) {
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

  return { CourseCollection, CourseModel };
}
