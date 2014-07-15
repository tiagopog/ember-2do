# For more information see: http://emberjs.com/guides/routing/
App.Router.map ()->
  @resource('projects', path: '/')
  @resource('project', { path: 'project/:slug' })
  @resource('about')