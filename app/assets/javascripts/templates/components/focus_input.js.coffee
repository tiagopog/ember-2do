App.FocusInputComponent = Ember.TextField.extend
  becomeFocused: (-> @$().focus()).on('didInsertElement')
  keyDown: -> @get('controller').send('doneEditing')