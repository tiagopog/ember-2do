# http://emberjs.com/guides/models/#toc_store
# http://emberjs.com/guides/models/pushing-records-into-the-store/
App.ApplicationStore = DS.Store.extend()


# Override the default adapter with the `DS.ActiveModelAdapter` which
# is built to work nicely with the ActiveModel::Serializers gem.
App.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  #host: 'http://localhost:3000'
  namespace: 'api/v1'
})


App.TaskAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'api/v1'
  createRecord: (store, type, record) ->
    data = {}
    # TODO: try do build paths overriding the this.buidURL method
    path = "#{@namespace}/projects/#{record.get('project_id')}/tasks"
    
    serializer = store.serializerFor(type.typeKey)
    serializer.serializeIntoHash(data, type, record)
    
    @ajax(path, 'POST', { data: data })
})