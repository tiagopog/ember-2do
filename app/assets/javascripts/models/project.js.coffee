App.Project = DS.Model.extend(Ember.Validations.Mixin,
  name: DS.attr('string')
  slug: DS.attr('string')
  created_at: DS.attr('date')
  tasks: DS.hasMany('task')
  validations:
    name:
      presence: { message: "Name can't be blank" }
)

# App.ProjectSerializer = DS.RESTSerializer.extend({
#   primaryKey: 'slug'
# })
