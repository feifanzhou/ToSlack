class _Domain
  constructor: (attrs) ->
    @domain = attrs.domain
    @id = attrs.id
    
  domain: ->
    @domain

Domain = {
  new: (domain) ->
    new _Domain({ domain: domain })
  find: (id) ->  # TODO: Stub
    new _Domain({ domain: '', id: id })
}

module.exports = Domain