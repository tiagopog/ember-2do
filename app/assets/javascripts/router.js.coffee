# 
# routes
# 

# For more information see: http://emberjs.com/guides/routing/
App.Router.map ()->
  @resource('projects')
  @resource('project', { path: 'project/:id' })
  @resource('about')


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

App.ProjectsRoute = Ember.Route.extend
  model: -> 
    projects = @store.findAll('project')
    @set('projects', projects)

App.ProjectRoute = Ember.Route.extend
  model: (params) -> 
    @store.find('project', params.id)

# 
# models
# 

App.Task = DS.Model.extend
  name: DS.attr('string')
  priority: DS.attr('string')
  created_at: DS.attr('date')
  project: DS.belongsTo('project')

App.Project = DS.Model.extend
  name: DS.attr('string')
  slug: DS.attr('string')
  created_at: DS.attr('date')
  tasks: DS.hasMany('task')

# 
# views
# 

App.ProjectFormView = Ember.View.extend
  templateName: 'project_form'
  tagName: 'form'
  classNames: ['form-inline']
  submit: ->
    @get('controller').send('doneEditing')


# 
# controllers
# 

App.ProjectsIndexController = Ember.ObjectController.extend
  isAdding: false
  new: ->
    @set('isAdding', true)
  create: -> 
    self = @
    project = self.store.createRecord('project', { name: @get('newProjectName')})
    project.save().then(->
      self.set('isAdding', false)
      self.set('newProjectName', '')
      self.transitionToRoute('project', project)
    , ->
      alert('Saving project failed!')
    )

App.ProjectIndexController = Ember.ObjectController.extend({
  priority: ['low', 'medium', 'high']
  newTask: Ember.Object.create(name: null, priority: 'medium')
  isEditing: false
  isAddingTask: false
  actions:
    edit: ->
      @set('isEditing', true)
    doneEditing: ->
      @get('model').save()
      @set('isEditing', false)
    addTask: ->
      @set('isAddingTask', true)
    doneAddingTask: ->
      @set('isAddingTask', false)
})