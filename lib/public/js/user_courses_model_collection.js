function UserCoursesModelCollection (userId, courseId) {
  const UserCourseModel = Backbone.Model.extend({
    parse: res => (res.data ? res.data.user_course : res)
  });

  const UserCourseCollection = Backbone.Collection.extend({
    url: `/api/v1/auth/users/${userId}/courses/${courseId}/usercourses`,
    model: UserCourseModel,
    parse(data) {
      swal.close();
      return data.data.user_courses
    }
  });

  return { UserCourseCollection, UserCourseModel };
}
