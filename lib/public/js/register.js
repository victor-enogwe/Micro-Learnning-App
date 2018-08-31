function registrationPage() {
  const nameValidator = {
    minLength: 2, maxLength: 20, type: 'first name', check: '\\w\\s'
  }
  const RegisterFormModel = Backbone.Model.extend({
    url: '/api/v1/users',
    schema: {
      fname: {
        ...controlAttr,
        title: 'first name',
        validators: ['required', validateLength(nameValidator)]
      },
      lname: {
        ...controlAttr,
        title: 'last name',
        validators: ['required', validateLength({...nameValidator, type: 'last name'})]
      },
      email: { ...controlAttr, validators: ['required', 'email'] },
      password: {
        ...controlAttr,
        type: 'Password',
        validators: ['required', validateLength({
          minLength: 7, maxLength: 20, title: 'description', check: '\\w\\s\\.'
        })]
      },
      password_confirmation: {
        ...controlAttr,
        title: 'password confirmation',
        type: 'Password',
        validators: [
          'required', { type: 'match', field: 'password', message: 'Passwords must match!' }
        ]
      }
    }
  });

  const registerModel = new RegisterFormModel();
  const registerForm = new Backbone.Form({
    model: registerModel,
    validate: true,
    template: _.template($('#register').html())
  }).render().on('submit', function(e) {
    e.preventDefault();
    const errors = this.commit({ validate: true });
    if (!errors) {
      const data = this.getValue();
      this.model.save(data, { success });
    }
  });

  const success = () => swal({
    title: 'Good job!',
    text: 'Your account has been created.!',
    icon: 'success',
    className: 'register-swal',
    allowEscapeKey: false,
    allowOutsideClick: false,
    confirmButtonText: 'Proceed To Login!',
    confirmButtonClass: 'btn btn-primary btn-block'
  }).then(() => this.navigate('login', { trigger: true }));

  $('#main').html(registerForm.el);
}
