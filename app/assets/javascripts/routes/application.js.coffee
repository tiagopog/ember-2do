App.IndexRoute = Ember.Route.extend
  beforeModel: ->
    @transitionTo('projects')

App.ApplicationRoute = Ember.Route.extend({
  model: ->
    {
      id: 16
      name: 'Tiago Guedes'
      email: 'tiago@adtangerine.com'
    }
})
