App.ProjectsIndexController = Ember.ObjectController.extend({
  errors: Ember.makeArray()
  isAdding: false
  new: ->
    @set('isAdding', true)
  save: -> 
    self = @
    project = self.store.createRecord('project', { name: @get('name')})
    project.validate().then(->
      project.save().then(->
        self.set('isAdding', false)
        self.set('name', '')
      , (feedback) ->
        unless feedback.errors is null
          self.set('errors', Ember.makeArray(name: feedback.errors['0']))
      )
    , (feedback) ->
      self.set('errors', Ember.makeArray(feedback))
    )
})

App.ProjectIndexController = Ember.ObjectController.extend({
  errors: []
  priority: ['low', 'medium', 'high']
  newTask: Ember.Object.create(name: null, priority: 'medium')
  isEditing: false
  isAddingTask: false
  actions:
    edit: ->
      @set('isEditing', true)
    save: ->
      @get('model').save()
      @set('isEditing', false)
    addTask: ->
      @set('isAddingTask', true)
    doneAddingTask: ->
      @set('isAddingTask', false)
})