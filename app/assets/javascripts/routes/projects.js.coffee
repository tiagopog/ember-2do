App.ProjectsRoute = Ember.Route.extend
  model: -> 
    @store.findAll('project')

App.ProjectRoute = Ember.Route.extend
  model: (params) -> 
    @store.find('project', params.id)
