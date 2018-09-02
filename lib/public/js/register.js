function registrationPage() {
  const RegisterFormModel = Backbone.Model.extend({
    url: '/api/v1/users',
    schema: userSchema
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
    className: 'register-swal',
    allowEscapeKey: false,
    allowOutsideClick: false,
    confirmButtonText: 'Proceed To Login!',
    confirmButtonClass: 'btn btn-primary btn-block'
  }).then(() => this.navigate('login', { trigger: true }));

  $('#main').html(registerForm.el);
}
