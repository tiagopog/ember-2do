App.ProjectController = Ember.ObjectController.extend({
  isEditing: false
  edit: ->
    @.set('isEditing', true)
  doneEditing: ->
    @.set('isEditing', false)
})