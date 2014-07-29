App.Router.map ()->
  @resource('tasks', { path: '/foobar' })
  @resource('projects')
  @resource('project', { path: 'project/:id' })
  @resource('about')
