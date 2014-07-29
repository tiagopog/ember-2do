Ember.Handlebars.helper 'format-date', (date) -> moment(date).fromNow()

Ember.Handlebars.helper 'priority-helper', (val) ->
  new Handlebars.SafeString("<td class=\"#{val}-task priority\"><span>#{val}</span></td>")