App.IndexRoute = Ember.Route.extend
  beforeModel: -> @transitionTo('projects')

App.ApplicationRoute = Ember.Route.extend({
  model: ->
    @store.push 'user', {
      id: 16
      name: 'Tiago Guedes'
      email: 'tiago@adtangerine.com'
    }
})
