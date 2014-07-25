App.ProjectsRoute = Ember.Route.extend
  model: -> 
    projects = @store.findAll('project')
  afterModel: (model) ->
    # Fix slug and dirty objects.
    projects = model.get('content').filter (project) ->
      project.id = project.get('slug')
      project.id isnt undefined
    model.set('content', projects)

App.ProjectRoute = Ember.Route.extend
  model: (params) -> @store.find('project', params.id)
