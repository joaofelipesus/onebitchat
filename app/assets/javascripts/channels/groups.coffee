App.groups = App.cable.subscriptions.create "GroupsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log data

  alert: ->
    @perform 'alert'
