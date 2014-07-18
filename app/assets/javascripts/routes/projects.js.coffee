# App.ProjectsRoute = Ember.Route.extend
#   model: -> @store.find('project')
    

# App.ProjectRoute = Ember.Route.extend
#   model: (params) -> @store.findQuery('project', { slug: params.slug }).then (data) ->
#     data['content'][0]['_data']
