App.groups = App.cable.subscriptions.create "GroupsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    current_channel = $('.chat_name').text()
    channel = $(".channel-#{data.id}")
    if channel and current_channel != data.slug
      channel.addClass 'blue-text'

  alert: ->
    @perform 'alert'
