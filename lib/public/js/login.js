function loginPage() {
  const LoginFormModel = Backbone.Model.extend({
    url: '/api/v1/login',
    schema: {
      email: {
        ...controlAttr,
        editorAttrs: { type: 'email' },
        validators: ['required', 'email']
      },
      password: { ...controlAttr, type: 'Password', validators: ['required'] }
    }
  });

  const loginModel = new LoginFormModel();
  const loginForm = new Backbone.Form({
    model: loginModel,
    validate: true,
    template: _.template($('#login').html())
  })

  function submit(e) {
    e.preventDefault();
    const errors = this.commit({ validate: true });
    if (!errors) {
      const data = this.getValue();
      this.model.save(data, { success });
    }
  }

  success = (model, response) => {
    const { data: { token } } = response;
    window.localStorage.setItem('token', token);
    setToken(token);
    authEvent.trigger('auth:event');
    window.location = '/dashboard';
  }

  loginForm.on('submit', submit);
  loginForm.render();
  $('#main').html(loginForm.el);
}
