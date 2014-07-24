App.ProjectItemView = Ember.View.extend
  templateName: 'project_item'
  tagName: 'li'
  classNames: ['col-md-2', 'project']
  classNameBindings: ['hovered']
  hovered: false
  mouseEnter: -> @set('hovered', true)
  mouseLeave: -> @set('hovered', false)

App.ProjectFormView = Ember.View.extend
  templateName: 'project_form'
  tagName: 'form'
  classNames: ['form-inline']
  submit: ->
    @get('controller').send('save')
  keyDown: (key) ->
    if key.keyCode == 27
      @get('controller').send('doneEditing')