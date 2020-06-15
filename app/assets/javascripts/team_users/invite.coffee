$(document).on 'turbolinks:load', ->
  $.ajax "/team_users",
    type: 'GET',
    dataType: 'json',
    success: (data, text, jqXHT) ->
      $('#invite_modal').modal('open')
      invite = data["invites"][0]
      $('#team-name').text invite.team.slug
      $('#decline-invite').attr "data-value", "#{invite.user.id}?team_id=#{invite.team.id}"

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
