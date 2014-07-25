App.Router.map ()->
  @resource('projects')
  @resource('project', { path: 'project/:id' })
  @resource('about')
