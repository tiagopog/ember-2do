App.Task = DS.Model.extend(Ember.Validations.Mixin,
  name: DS.attr('string')
  priority: DS.attr('string')
  created_at: DS.attr('date')
  project: DS.belongsTo('project')
  validations:
    name:
      presence: true
)