# For more information see: http://emberjs.com/guides/routing/

AgbApplication.Router.map ()->
  @resource('about')
  @resource('projects')
  @resource('project', { path: 'project/:slug' })

AgbApplication.ApplicationRoute = Ember.Route.extend({
  model: -> 
    {
      id: 16
      name: 'Tiago Guedes'
      email: 'tiago@adtangerine.com'
    }
})

AgbApplication.ProjectsRoute = Ember.Route.extend({
  model: ->
    $.getJSON('http://localhost:3000/api/v1/projects').then (data) ->
      data.projects
})

AgbApplication.ProjectRoute = Ember.Route.extend({
  model: (params) -> $.getJSON("http://localhost:3000/api/v1/projects/#{params.slug}").then (data) ->
    project = data.project
    {
      name: project.name
      slug: project.slug
      tasks: data.tasks
    }
})

AgbApplication.ProjectController = Ember.ObjectController.extend({
  isEditing: false
  edit: ->
    @.set('isEditing', true)
  doneEditing: ->
    @.set('isEditing', false)
})