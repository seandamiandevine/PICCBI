// CONSENT AND DEBRIEF FORM TRIALS FOR PICC BODY IMAGE //

// consent
var consent = {
  type:'external-html',
  url: "sub/html/consent.html",
  cont_btn: 'agree',
};

// debrief 
var debriefchoice = '';
var checkdebrief = function(elem) {
  if (document.getElementById('agree').checked) {
    debriefchoice = 'agree';
    return true;
  }
  else {
    alert("Your data will not be included in the analyses.");
    debriefchoice = 'decline';
    return true;
  }
  return false;
};

var debrief = {
  type:'external-html',
  url: "sub/html/debriefing.html",
  cont_btn: 'continue',
  check_fn: checkdebrief,
  on_finish: function(){
    jsPsych.data.addProperties({debrief: debriefchoice});
  }
};
