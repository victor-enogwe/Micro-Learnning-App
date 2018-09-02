function profileForm({ user, el }) {
  const [fname, lname] = user.fullname.split(' ');
  const UserModel = Backbone.Model.extend({
    urlRoot: () => `/api/v1/auth/users`,
    parse: res => res.data.user,
    defaults: { fname, lname, email: user.email, id: user.id }
  });

  const UserFormView = Backbone.Form.extend({
    template: _.template($('#profile_form').html()),
    schema: {
      ...userSchema,
      password: {
        ...controlAttr,
        type: 'Password',
        validators: [validateLength({
          minLength: 7, maxLength: 20, type: 'Password', title: 'description', check: '\\w\\s\\.'
        }), {
          type: 'match',
          field: 'password_confirmation',
          message: 'Password confirmation must match!'
        }]
      },
      password_confirmation: {
        ...controlAttr,
        title: 'password confirmation',
        type: 'Password',
        validators: [{
          type: 'match',
          field: 'password',
          message: 'Password must match!'
        }]
      }
    },
    model: UserModel,
    events: {
      'click #form_save_user': saveUser
    }
  });

  function saveUser(e) {
    e.preventDefault();
    const errors = this.commit({ validate: true });
    if (!errors) {
      if(!this.model.toJSON().password) {
        this.model.unset('password');
        this.model.unset('password_confirmation')
      }
      this.model.save(null, { success });
    }
  }

  function success(model, response) {
    return swal({
      title: 'Great!',
      text: `update successful`,
      type: 'success',
      allowOutsideClick: false,
      allowEscapeKey: false,
      confirmButtonText: 'please login again to continue',
      confirmButtonClass: 'btn btn-primary btn-block',
    }).then(() => logout());
  }
  const userModel = new UserModel();
  const userForm = new UserFormView({ model: userModel });

  userForm.render();
  $(el).append(userForm.el);
}
