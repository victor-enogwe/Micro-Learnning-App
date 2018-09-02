const authEvent = new _.extend({}, Backbone.Events);

const controlAttr = {
  type: 'Text',
  editorClass: 'form-control used',
};

const sAlert = swal.mixin({
  title: 'working!',
  text: 'please wait...',
  allowOutsideClick: false,
  allowEscapeKey: false,
  showConfirmButton: false,
  confirmButtonText: 'Close',
  background: 'transparent'
})

const sDeleteConfirm = swal.mixin({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  type: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, delete it!'
});

const nameValidator = {
  minLength: 2, maxLength: 20, type: 'first name', check: '\\w\\s'
}

const courseSchema = {
  title: {
    type: 'Text',
    validators: ['required', validateLength({
      minLength: 5, maxLength: 100, type: 'title', check: '\\w\\s'
    })]
  },
  description: {
    type: 'TextArea',
    validators: ['required', validateLength({
      minLength: 50,
      maxLength: 1000,
      type: 'description',
      check: '\\w\\s\\.'
    })],
    editorAttrs: {
      rows: 13,
      col: 13
    }
  }
};

const userSchema = {
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
};

function setToken(token) {
  $.ajaxSetup({ headers: { 'Authorization': `Bearer ${token}` } });
}

function disableForm(form, disable = true) {
  _.each(form.elements, (e) => (e.readOnly = disable));
  $("#submit").attr("disabled", disable);
}

function validateLength({ minLength, maxLength, type, check = '' }) {
  const lengthRegex = new RegExp(`[${check}]{${minLength},${maxLength}}`);
  const message = `${type} should have ${minLength} - ${maxLength} characters`;
  return value => !value ? null : (lengthRegex.test(value) ? null : { type, message });
}

function formatResponseMessage(message) {
  if (message && message.includes('token')){
    return 'login session expired or unauthorized access!';
  }
  return message;
}

function currentUser() {
  if (window.localStorage.getItem('token')) {
    const { user, scopes: permissions } = JSON.parse(atob(window.localStorage
      .getItem('token').split('.')[1]));
    return { ...user, permissions }
  }
  return {};
}

function authorizeVisitor(route, token) {
  const requireAuth = route.includes('dashboard') && !token;
  if (requireAuth) {
    return this.navigate('login', { trigger: true });
  }
}

function logout(link = '/login') {
  window.localStorage.clear();
  setToken(null);
  authEvent.trigger('auth:event');
  return (window.location = '/login');
}

function ajaxErrorHandler(e, response) {
  const self = this;
  const type = e.type.replace('ajax', '').toLowerCase();
  const unauthorized = response.status === 401;
  const route = Backbone.history.getFragment();
  const { message } = response.responseJSON || { message: null };
  const text = formatResponseMessage(message);
  return sAlert({
    type,
    title: type,
    text,
    onOpen: swal.disableLoading,
    showConfirmButton: true
  }).then(() => {
    if (unauthorized && route !== '/login') return logout.call(self);
    const link = window.location.pathname.split('/').slice(0,2).join('/');
    return this.navigate(link, { trigger: true })
  });
}

$(document).ready(function() {
  setToken(window.localStorage.getItem('token'));
  const user = currentUser();
  let publicRoutes = {
    '': homePage,
    'courses(/)': coursesPage.bind(null, {}),
    'courses/:id(/)': coursePage,
    'courses/categories/:id(/)': (categoryId) => coursesPage({ categoryId }),
    'courses/authors/:id(/)': (creatorId) => coursesPage({ creatorId }),
  };

  if (!user.id) {
    publicRoutes = {
      'login(/)': loginPage,
      'register(/)': registrationPage,
      ...publicRoutes
    }
  }

  const authRoutes = (user) => {
    if (user) {
      const { permissions = [] } = user;
      let routes = {
        'dashboard(/)': dashboardPage,
        'dashboard/my-courses(/)': coursesPage.bind(null, { userId: currentUser().id })
      }

      if(permissions.includes('create_course') || permissions.includes('manage_courses')) {
        routes = {
          ...routes,
          'dashboard/courses(/)': coursesPage.bind(null, { creatorId: currentUser().id }),
          'dashboard/courses/create(/)': courseSavePage
        };
      }
      if(permissions.includes('update_course') || permissions.includes('manage_courses')) {
        routes = { ...routes, 'dashboard/courses/:id(/)': courseSavePage }
      }
      return {
        ...routes,
        'dashboard/courses/:course_id/topics/:topic_id': topicPage,
      }
    }
    return {};
  }

  const AppRouter = Backbone.Router.extend({
    routes: {
      ...publicRoutes,
      ...authRoutes(user),
      '*notFound': pageNotFound
    },
    initialize: function () {
      const token = window.localStorage.getItem('token');

      Backbone.history.start({ pushState: true });

      $(document).ajaxStart(sAlert.bind(null, { onOpen: swal.showLoading }));
      $(document).ajaxError(ajaxErrorHandler.bind(this));

      authorizeVisitor.call(this, Backbone.history.getFragment(), token);

      Backbone.history.on('route', function(route) {
        authorizeVisitor.call(this, Backbone.history.getFragment(), token);
      });
    }
  });

  new AppRouter({});
});


