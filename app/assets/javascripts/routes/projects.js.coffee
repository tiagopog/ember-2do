App.ProjectsRoute = Ember.Route.extend
  model: -> 
    projects = @store.findAll('project')
    console.log projects
    @set('projects', projects)

App.ProjectRoute = Ember.Route.extend
  model: (params) -> 
    @store.find('project', params.id)
