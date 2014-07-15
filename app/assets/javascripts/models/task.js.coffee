App.Task = DS.Model.extend
  name: DS.attr('string')
  priority: DS.attr('string')
  created_at: DS.attr('date')
  project: DS.belongsTo('project')