// MAIN PICC TRIALS //

var blockCount = 0;
var trialCount = 0;

var block = {
  type: 'html-keyboard-response',
  stimulus: function(){
    return "<p>Block "+(blockCount+1)+"</p><p>Press SPACE to continue.</p>";
  },
  choices: ['space'],
  post_trial_gap: postblocktime,
  on_finish: function(){
    blockCount++;
    trialCount = 0 // reset trialCount for next block
  },
};

var stim = {
  type: "image-keyboard-response",
  stimulus_height: 891, //original stimulus HxW divided by 2 to fit on screen, but keep ratio
  stimulus_width: 481,
  stimulus: function(){
    return alltrials[blockCount-1][trialCount];
  },
  trial_duration: stimtime,
  choices: jsPsych.NO_KEYS
};

var fixation = {
  type: 'html-keyboard-response',
  stimulus: '<div style="font-size:60px;">?</div>',
  choices: choicekeys,
  post_trial_gap: poststimtime,
  on_finish: function(data){
    trialCount++;
    data.block = blockCount;
    data.trial = trialCount;
    data.freq = freqs[blockCount-1];
  }
};

var trials = {
  timeline: [stim, fixation],
  repetitions: numtrials,
};
