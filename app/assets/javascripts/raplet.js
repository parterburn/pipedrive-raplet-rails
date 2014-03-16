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
 
  var posting = $.post( url, { email: email, name: name, visible_to: 0,  } );
  $("#addUser").fadeOut('fast');
  spinner.gif
  var content = '<center><img src="https://pipedrive.herokuapp.com/spinner.gif" height="20" width="20"></center>';
  $( "#result" ).empty().append( content );

  // Put the results in a div
  posting.done(function( data ) {
    console.log(data);
    if (typeof data["data"] === 'undefined') {
      content = "Error while adding user";
    } else {
      var user_id = data["data"]["id"];
      var name = data["data"]["name"];
      content = '<ul class="memberships"><li class="membership expanded"><div class="object"><a class="membership-link" href="https://app.pipedrive.com/person/details/'+user_id+'" site_name="Pipedrive" target="_blank" title="View '+name+' on Pipedrive"><div class="icon"><img alt="Favicon" src="https://pipedrive.herokuapp.com/favicon.ico"></div>'+name+'</a></div></li></ul>';
    }
    $( "#result" ).empty().append( content );
  });
});