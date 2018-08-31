authorizeVisitor(window.location.pathname, window.localStorage.getItem('token'));

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
  return value => lengthRegex.test(value) ? null : { type, message };
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

function authorizeVisitor(route, token, router) {
  const requireAuth = route.includes('dashboard') && !token;
  if (requireAuth){
    if(router) return router.navigate('login', { trigger: true });
    return window.location = '/login';
  }
}

function logout(router, link = '/login') {
  window.localStorage.clear();
  setToken(null);
  authEvent.trigger('auth:event');
  return router
    ? router.navigate(link, { trigger: true }) : (window.location = link);
}

function ajaxErrorHandler(e, response) {
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
    if (unauthorized && route !== '/login') return logout();
    const link = window.location.pathname.split('/').slice(0,-1).join('/');
    return router.navigate(link, { trigger: true })
  });
}

let router;

$(document).ready(function() {
  setToken(window.localStorage.getItem('token'));
  const publicRoutes = {
    '': homePage,
    'login(/)': loginPage,
    'register(/)': registrationPage,
    'courses(/)': coursesPage.bind(null, {}),
    'courses/:id(/)': coursePage,
    'courses/categories/:id(/)': (categoryId) => coursesPage({ categoryId }),
    'courses/authors/:id(/)': (creatorId) => coursesPage({ creatorId }),
  };

  const instructorRoutes = (user) => {
    if (user) {
      const { permissions = [] } = user;
      let routes = {
        'dashboard(/)': dashboardPage,
        'dashboard/my-courses': coursesPage.bind(null, { userId: currentUser().id })
      }

      if(permissions.includes('create_course')) {
        routes = {
          ...routes,
          'dashboard/courses(/)': coursesPage.bind(null, { creatorId: currentUser().id }),
          'dashboard/courses/create(/)': courseSavePage
        };
      }
      if(permissions.includes('update_course')) {
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
      ...instructorRoutes(currentUser()),
    }
  });
  router = new AppRouter({ });
  Backbone.history.start({ pushState: true, root: '/' });

  router.on('route', function(route) {
    const token = window.localStorage.getItem('token');
    authorizeVisitor(Backbone.history.getFragment(), token, router);
  });
});

$(document).on('click', 'a.link', function(e) {
  e.preventDefault();
  const re = /^[a-z]{4,5}\:\/{2}[a-z]{1,}\:[0-9]{1,4}.(.*)/;
  return router.navigate(`/${e.target.href.replace(re, '$1')}`, { trigger: true });
});

$(document).ajaxStart(sAlert.bind(null, { onOpen: swal.showLoading }));
$(document).ajaxError(ajaxErrorHandler)

