$('.last_activity').mouseenter(function() {
  $('.last_activity_note').slideDown(200);
});

$('.last_activity').mouseleave(function() {
  $('.last_activity_note').slideUp(200);
});

$('.next_activity').mouseenter(function() {
  $('.next_activity_note').slideDown(200);
});

$('.next_activity').mouseleave(function() {
  $('.next_activity_note').slideUp(200);
});

// Attach a submit handler to the form
$( "#addUser" ).submit(function( event ) {
 
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
          console.log(data);
          console.log(data.data);
          console.log(typeof data.data === 'undefined');
          if (typeof data.data === 'undefined') {
            content = '<ul class="memberships"><li class="membership expanded"><div class="object"><a class="membership-link" href="https://app.pipedrive.com/person/details/" site_name="Pipedrive" target="_blank" title="Error while adding user"><div class="icon"><img alt="Favicon" src="https://pipedrive.herokuapp.com/pipedrive_favicon.ico"></div>Error while adding user</a></div></li></ul>';
          } else {
            var user_id = data.data.id;
            var name = data.data.name;
            content = '<ul class="memberships"><li class="membership expanded"><div class="object"><a class="membership-link" href="https://app.pipedrive.com/person/details/'+user_id+'" site_name="Pipedrive" target="_blank" title="View '+name+' on Pipedrive"><div class="icon"><img alt="Favicon" src="https://pipedrive.herokuapp.com/pipedrive_favicon.ico"></div>'+name+'</a></div></li></ul>';
          }
          $( "#result" ).empty().append( content );
        },
        error: function(xhr) {
          content = '<ul class="memberships"><li class="membership expanded"><div class="object"><a class="membership-link" href="https://app.pipedrive.com/person/details/" site_name="Pipedrive" target="_blank" title="Error while adding user"><div class="icon"><img alt="Favicon" src="https://pipedrive.herokuapp.com/pipedrive_favicon.ico"></div>Error while adding user</a></div></li></ul>';
          $( "#result" ).empty().append( content );
        }
  });

}); 