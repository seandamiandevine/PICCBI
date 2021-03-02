var facet = 0;
var faceb = 0;

var faceimg =['stim/faces/Caucasian_004_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_012_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_017_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_018_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_021_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_022_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_026_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_029_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_033_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_041_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_063_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_068_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_069_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_101_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_103_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_104_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_105_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_108_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_117_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_121_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_123_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_125_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_130_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_131_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_132_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_138_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_140_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_141_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_172_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_173_03_Face Research Lab London Set.png',
  'stim/faces/Caucasian_Rafd090_03.png',
  'stim/faces/Caucasian_Rafd090_05_.png',
  'stim/faces/Caucasian_Rafd090_07.png',
  'stim/faces/Caucasian_Rafd090_09.png',
  'stim/faces/Caucasian_Rafd090_10.png',
  'stim/faces/Caucasian_Rafd090_15.png',
  'stim/faces/Caucasian_Rafd090_20.png',
  'stim/faces/Caucasian_Rafd090_21.png',
  'stim/faces/Caucasian_Rafd090_23.png',
  'stim/faces/Caucasian_Rafd090_24.png',
  'stim/faces/Caucasian_Rafd090_25.png',
  'stim/faces/Caucasian_Rafd090_28.png',
  'stim/faces/Caucasian_Rafd090_30.png',
  'stim/faces/Caucasian_Rafd090_33.png',
  'stim/faces/Caucasian_Rafd090_36.png',
  'stim/faces/Caucasian_Rafd090_38.png',
  'stim/faces/Caucasian_Rafd090_46.png',
  'stim/faces/Caucasian_Rafd090_47.png',
  'stim/faces/Caucasian_Rafd090_49.png',
  'stim/faces/Caucasian_Rafd090_71_.png',
  'stim/faces/Middle_Eastern_Iranian_0030-17f2_IFD.png',
  'stim/faces/Middle_Eastern_Iranian_0035-17f1_IFD.png',
  'stim/faces/Middle_Eastern_Iranian_0057-17f2_IFD.png',
  'stim/faces/Middle_Eastern_Iranian_0060-17f2_IFD.png',
  'stim/faces/Middle_Eastern_Iranian_0115-37f1_IFD.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_29.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_35.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_45.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_48.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_50.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_51.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_52.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_53.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_54.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_55.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_59.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_60.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_67.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_68.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_69.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_70.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_72.png',
  'stim/faces/Middle_Eastern_Moroccan_Rafd090_73.png',
  'stim/faces/Middle_Eastern_Turkish_2_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_4_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_9_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_10_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_36_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_57_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_140_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_161_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_210_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_223_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_230_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_251_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_289_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_322_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_337_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_410_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_417_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_422-Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_448_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_483_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_499_Bogazici face database.png',
  'stim/faces/Middle_Eastern_Turkish_516_Bogazici face database.png',
  'stim/faces/Middle_Eastern_West Asian_008_03_Face Research Lab London Set.png',
  'stim/faces/Middle_Eastern_West Asian_037_03_Face Research Lab London Set.png',
  'stim/faces/Middle_Eastern_West Asian_070_03_Face Research Lab London Set.png',
  'stim/faces/Middle_Eastern_West Asian_115_03_Face Research Lab London Set.png',
  'stim/faces/Middle_Eastern_West Asian_142_03_Face Research Lab London Set.png'
];

faceimg = _.sample(faceimg, faceimg.length);
var nfacesperblock = faceimg.length/2;

// facesb1=[];
// facesb2=[];
// for(i in _.range(faceimg.length)){
//   if(i < faceimg.length/2){
//     facesb1.push(faceimg[i])}
//   else{
//     facesb2.push(faceimg[i])
//   }
// };

var facestrial = {
    type: 'image-slider-response',
    stimulus: function() {
      return faceimg[facet]  } ,
    labels: ['Central European', 'Middle-Eastern'],
    prompt: "<p>Please rate this face based on its geographic location</p>",
    max: 9,
    min: 1,
    step: 0.1,
    start: 5,
    stimulus_height: 675, // 1350 px/2 -- keep ratio the same
    stimulus_width: 675,
    response_ends_trial: true,
    require_movement: true,
    on_finish: function(data) {

      data.facestim = faceimg[facet]

      facet++
  }
};

var facesblock = {
  type: 'html-keyboard-response',
  stimulus: function(){
    return "<p>Block of Faces: "+(faceb+1)+"</p><p>Press SPACE to continue.</p>";
  },
  choices: ['space'],
  post_trial_gap: postblocktime,
  on_finish: function(){
    faceb++;
  },
};


faces = {
  timeline: [facestrial],
  repetitions: nfacesperblock,
};

var facesinst = {
	type: 'instructions',
	pages: [
'Thank you for answering all our questions so far! There is only one more thing to do and you will be all done for the day!',

"<p>In this study we assess how individuals judge faces that differ with respect to their geographic origin. Your task will be to repeatedly judge whether a given face is more likely to be from a Central European geographic origin (e.g. Germany, the Netherlands) as opposed to a Middle-Eastern geographic origin (e.g. Iran, Turkey).</p>" +
"<p>To do so, you will use a slider at the bottom of the screen. Slide it fully to the left if you are certain that the person depicted comes from a Central European background. Slide it fully to the right if you are certain that the face comes from a Middle-Eastern geographic origin. </p>" +
"<p>You can also slide the pointer to anywhere in the middle of these two to indicate your uncertainty about their geographic origin.</p>",

"<p>After sliding the pointer to where you want, you can submit your response and move on to the next by clicking 'Continue'. If you prefer not to answer for any given face, please press 'Skip This Face'.</p>",

"<p>These faces will be presented one after the other over 2 blocks. You will be given a short break between the blocks. </p>"+
"<p>When you are ready to begin, click Next below.</p>",
	],
	show_clickable_nav: true
};
