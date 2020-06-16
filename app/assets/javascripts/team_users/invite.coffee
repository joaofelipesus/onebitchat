$(document).on 'turbolinks:load', ->
  $.ajax "/team_users",
    type: 'GET',
    dataType: 'json',
    success: (data, text, jqXHT) ->
      $('#invite_modal').modal('open')
      invite = data["invites"][0]
      $('#team-name').text invite.team.slug
      $('#decline-invite').attr "data-value", "#{invite.user.id}?team_id=#{invite.team.id}"
      $('#accept-invite').attr "data-value", invite.id

  $('#decline-invite').on 'click', (e) ->
    url = $(e.target).attr "data-value"
    $.ajax "/team_users/#{url}",
        type: 'DELETE'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          $('#invite_modal').modal('close')
          Materialize.toast('Invite declined &nbsp;<b>:(</b>', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problem to decline invite &nbsp;<b>:(</b>', 4000, 'red')

  $('#accept-invite').on 'click', (e) ->
    invite_id = $(e.target).attr "data-value"
    $.ajax "/team_users/#{invite_id}",
      type: 'PATCH',
      dataType: 'json',
      data: { team_user: { confirmation_status: "confirmed" }},
      success: (data, text, jqXHR) ->
        location.reload()
        Materialize.toast('Invite accepted &nbsp;<b>:(</b>', 4000, 'green')
      error: (jqXHR, textStatus, errorThrown) ->
        Materialize.toast('Problem to decline invite &nbsp;<b>:(</b>', 4000, 'red')
