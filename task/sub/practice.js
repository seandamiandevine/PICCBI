// PRACTICE TRIALS //

var pCount = 0;
var pstim = {
  type: "image-keyboard-response",
  stimulus_height: 891, //original stimulus HxW divided by 2 to fit on screen, but keep ratio
  stimulus_width: 481,
  stimulus: function(){return practicestim[pCount];},
  trial_duration: stimtime,
  choices: jsPsych.NO_KEYS
};

var pfix = {
  type: 'html-keyboard-response',
  stimulus: '<div style="font-size:60px;">?</div>',
  choices: choicekeys,
  post_trial_gap: poststimtime,
  on_finish: function(data){
    pCount++;
    data.trial = pCount;
    data.block = 'Practice';
    data.freq = pracfreq;

    console.log(data);
  }
};

var ptrials = {
  timeline: [pstim, pfix],
  repetitions: numpractrials,
};
