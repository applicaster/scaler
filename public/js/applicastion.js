$(function() {

  $('a.delete').on('click', function(){
    el = $(this);
    if (confirm('Are you sure?')) {
      el.parents('tr').hide();
      $.post( el.attr('href'), { _method: "delete"} );
    }
    return false; 
  });

  //Use datetime picker for time selection
  $('.time').appendDtpicker({"minuteInterval": 10,"futureOnly": true,"closeOnSelected": true});

});

