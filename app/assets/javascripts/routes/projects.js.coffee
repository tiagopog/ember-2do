App.ProjectsRoute = Ember.Route.extend({
  model: ->
    $.getJSON('http://localhost:3000/api/v1/projects').then (data) ->
      data.projects
})

App.ProjectRoute = Ember.Route.extend({
  model: (params) -> $.getJSON("http://localhost:3000/api/v1/projects/#{params.slug}").then (data) ->
    project = data.project
    {
      name: project.name
      slug: project.slug
      tasks: data.tasks
    }
})