$(document).ready(function() {
  function check_job_status(jid) {
    $.ajax({
      type: "GET",
      url: "/status/" + jid,
    }).done(function(response){
      if (response === "true") {
        $("#status").html("Tweet has been successfully posted.");
      }
      else {
        setTimeout(function(){check_job_status(jid)},1000);
      }
    });
  }


  $(".tweet_form").submit(function(event){
    event.preventDefault();
    $('#loading_img').show();
    $(this).children("input").disabled;
    $.ajax({
      type: "POST",
      url: "/tweet",
      data: $(".tweet_form").serialize(),
      cache: false,
      success: function(response){
        $("#status").html("Tweeting...");
        setTimeout(function(){check_job_status(response)}, 1000);
        $('#loading_img').hide();
        $(this).children("input").removeAttr("disabled");

      },
      error: function(){
        $("#status").html("Tweet did not get sent successfully. Please retry.");
        $('#loading_img').hide();
      }
    });
  });
});
