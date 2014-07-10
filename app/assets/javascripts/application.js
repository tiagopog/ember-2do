//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require agb_application

window.AgbApplication = Ember.Application.create();

Ember.Handlebars.helper('format-date', function(date) {
  return moment(date).fromNow();
});