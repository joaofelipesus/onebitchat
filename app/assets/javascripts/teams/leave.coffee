$(document).on 'turbolinks:load', ->
  $(".leave_team").on 'click', (e) =>
    current_user_id = $(e.target).attr 'data-value'
    team_id = $("#team-id").attr 'data-value'
    $('#leave_team_modal').modal('open')
    $('.leave_team_form').attr('action', "team_users/#{current_user_id}?team_id=#{team_id}")
    return false

  $('.leave_team_form').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'DELETE'
        contentType:'application/json',
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          $(location).attr('href','/');
        error: (jqXHR, textStatus, errorThrown) ->
          $('#remove_team_modal').modal('close')
          Materialize.toast('Problem to delete Team &nbsp;<b>:(</b>', 4000, 'red')
    return false
