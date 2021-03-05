// SETUP CONSTANTS FOR BODY IMAGE TASK //

var subject_id = jsPsych.randomization.randomID(15); //random 15 digit id
var cond = _.sample([0, 1]) // random condition; 0 = stable; 1 = decreasing
//var cond = 1; 

jsPsych.data.addProperties({ // add random data to file
  subject: subject_id,
  condition: cond
});

/* set constants */
const numtrials = 50; // number of trials per block
const numpractrials = 10; // number of trials to practice
const numblocks = 16; // total number of blocks
const blocks = _.range(numblocks); // list of blocks
const pracfreq = .5; // prevalence of overweight bodies in the practice phase
const postblocktime = 1000; // iti after a block (in ms.)
const stimtime = 500; // duration of stimulus (in ms.)
const poststimtime = 500; // isi after stimulus presentation (in ms. )
const choicekeys = ['l', 'a'] // keys to make judgements ([0] = overweight; [1] not overweight)

/* put images in list in order*/
var images = []; // images to preload
x = _.range(10, 310, 10).reverse();
for (i in x) {
if (x[i] >= 100) {
   images.push('stim/T'+x[i]+'.jpg')//thin
  } else {
   images.push('stim/T0'+x[i]+'.jpg')
  }
};
images.push('stim/N000.jpg') ;// neutral

for (i in _.range(10, 310, 10)) {
  if (_.range(10, 310, 10)[i] < 100) {
   images.push('stim/H0'+_.range(10, 310, 10)[i]+'.jpg')//fat
  } else {
   images.push('stim/H'+_.range(10, 310, 10)[i]+'.jpg')
  }
};


// prevalence assignment based on random condition
if (cond == 0) {
  var freqs = [.5,.5,.5,.5,.5,.5,.5,.5,.5,.5,.5,.5,.5,.5,.5,.5]
} else if (cond == 1) {
  var freqs = [.5,.5,.5,.5,.4,.28,.14,.06,.06,.06,.06,.06,.06,.06,.06,.06]
}

//function to randomize stimuli
function stimRandomizer(block,freq,numtrials) {
  thin = [];
  fat = [];
  for (i in _.range(10, 310, 10)) {
    if (_.range(10, 310, 10)[i] < 100) {
      thin.push('stim/T0'+_.range(10, 310, 10)[i]+'.jpg')
      fat.push('stim/H0'+_.range(10, 310, 10)[i]+'.jpg')
    } else {
      thin.push('stim/T'+_.range(10, 310, 10)[i]+'.jpg')
      fat.push('stim/H'+_.range(10, 310, 10)[i]+'.jpg')
    }
  };
  signals = []; // fat
  noise = []; // thin

  for(i in _.range(Math.round(numtrials*freq))){
    signals.push(_.sample(fat, 1))
  };

  for(i in _.range(Math.round(numtrials*(1-freq)))){
    noise.push(_.sample(thin, 1))
  };
  stim = _.sample(signals.concat(noise), numtrials);

  // these don't work because they sample without replacement -- maxed list at 30
  // signals = _.sample(fat, Math.round(numtrials*freq));
  // noise = _.sample(thin, Math.round(numtrials*(1-freq)));

  return stim
};

//produce trial lists and save them in array for pre-loading
var practicestim = stimRandomizer(1,pracfreq,numpractrials)
var alltrials = []; // all trials to be used in the task
for(i in _.range(numblocks)){
  alltrials.push(stimRandomizer(blocks[i], freqs[i], numtrials))
};


/* setup fullscreen mode */
var fullscreen = {
  type: 'fullscreen',
    fullscreen_mode: true
  }
