//temp fix for gmail issue
elements=document.getElementsByClassName("w-asK w-atd");
elements[0].setAttribute("style", "display: none !important;");

$('.w-asK.w-atd').addClass('removeImportant');

$('#rapportive-bf .pipedrive_person').mouseenter(function() {
  $('#rapportive-bf .pipedrive_person_details').slideDown(200);
});

$('#rapportive-bf .pipedrive_person').mouseleave(function() {
  $('#rapportive-bf .pipedrive_person_details').slideUp(200);
});

$('#rapportive-bf .last_activity').mouseenter(function() {
  $('#rapportive-bf .last_activity_note').slideDown(200);
});

$('#rapportive-bf .last_activity').mouseleave(function() {
  $('#rapportive-bf .last_activity_note').slideUp(200);
});

$('#rapportive-bf .next_activity').mouseenter(function() {
  $('#rapportive-bf .next_activity_note').slideDown(200);
});

$('#rapportive-bf .next_activity').mouseleave(function() {
  $('#rapportive-bf .next_activity_note').slideUp(200);
});

// Attach a submit handler to the form
$( "#rapportive-bf #addUser" ).submit(function( event ) {
 
  event.preventDefault();
 
  var $form = $( this ),
    email = [$form.find( "input[name='email']" ).val()],
    name = $form.find( "input[name='email']" ).val(),
    url = $form.attr( "action" );

  $("#addUser").fadeOut('fast');
  var content = '<center><img src="https://pipedrive.herokuapp.com/spinner.gif" height="20" width="20" style="margin-top:5px;"></center>';
  $( "#result" ).empty().append( content );

  $.ajax({
        url: url,
        type: "POST",
        data: {email: email, name: name, visible_to: 0},
        success: function(data) {
          if (typeof data.data === 'undefined') {
            content = '<ul id="rapportive-bf" class="memberships"><li class="membership expanded"><div class="object"><a class="membership-link" href="https://app.pipedrive.com/person/details/" site_name="Pipedrive" target="_blank" title="Error while adding user"><div class="icon"><img alt="Favicon" src="https://pipedrive.herokuapp.com/pipedrive_favicon.ico"></div>Error while adding user</a></div></li></ul>';
          } else {
            var user_id = data.data.id;
            var name = data.data.name;
            content = '<ul id="rapportive-bf" class="memberships"><li class="membership expanded"><div class="object"><a class="membership-link" href="https://app.pipedrive.com/person/details/'+user_id+'" site_name="Pipedrive" target="_blank" title="View '+name+' on Pipedrive"><div class="icon"><img alt="Favicon" src="https://pipedrive.herokuapp.com/pipedrive_favicon.ico"></div>'+name+'</a></div></li></ul>';
          }
          $( "#result" ).empty().append( content );
        },
        error: function(xhr) {
          content = '<ul id="rapportive-bf" class="memberships"><li class="membership expanded"><div class="object"><a class="membership-link" href="https://app.pipedrive.com/person/details/" site_name="Pipedrive" target="_blank" title="Error while adding user"><div class="icon"><img alt="Favicon" src="https://pipedrive.herokuapp.com/pipedrive_favicon.ico"></div>Error while adding user</a></div></li></ul>';
          $( "#result" ).empty().append( content );
        }
  });

}); 