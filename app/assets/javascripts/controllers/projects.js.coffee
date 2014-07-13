App.ProjectController = Ember.ObjectController.extend({
  priority: ['low', 'medium', 'high']
  newTask: Ember.Object.create(name: null, priority: 'medium')
  isEditing: false
  isAddingTask: false
  edit: ->
    @set('isEditing', true)
  doneEditing: ->
    @set('isEditing', false)
  addTask: ->
    @set('isAddingTask', true)
  doneAddingTask: ->
    @set('isAddingTask', false)
})