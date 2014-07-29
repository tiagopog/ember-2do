App.ProjectsIndexController = Ember.ObjectController.extend({
  errors: Ember.makeArray()
  isAdding: false
  new: -> @set('isAdding', true)
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
  destroy: (project) ->
    if confirm(are_you_sure(project.get('name')))
      project.destroyRecord()
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
      @set('currentName', @get('model').get('name'))
    save: ->
      @get('model').save()
      @set('isEditing', false)
    doneEditing: ->
      @set('isEditing', false)
      @set('name', @get('currentName'))
    destroy: ->
      if confirm(are_you_sure(@get('model').get('name')))
        @get('model').destroyRecord()
        @transitionTo('projects')
    addTask: -> @set('isAddingTask', true)
    doneAddingTask: ->
      self = @
      task = fix_task(@get('newTask'), self)
      task.validate().then ->
        task.save().then ->
          self.get('model').get('tasks').pushObjects([task])
      @set('newTask.name', null)
      @set('newTask.priority', 'medium')
      @set('isAddingTask', false)
})

# TODO: add the i18n lib
are_you_sure = (name) -> 
  "Are you sure to delete \"#{name}\"?"

fix_task = (task, self) ->
  task.project_id = self.get('content').get('slug')
  task = self.store.createRecord('task', {
    name: task.name
    priority: task.priority
    project_id: task.project_id
  })