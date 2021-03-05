
// QUESTIONNAIRES //

var demo1 = {
  type: 'survey-text',
  questions: [
    {prompt: "What is your unique Prolific ID?", name:'prolID'},
    {prompt: "What is your age in years?", name:'age'},
    {prompt: "For statistical purposes, what is your weight (in lbs.; 1 lbs = 0.45kg = 0.07 stones)? Just type the number (e.g., if you weight 100 lbs just type 100).", name:'weight'},
    {prompt: "For statistical purposes, what is your height (in feet; 1 foot = 0.3 meters)? Just type the number: If you are 5 foot 5 inches tall, type 5.5.", name:'height'},
    {prompt: "Please enter your date of birth", placeholder: "DD/MM/YYYY", name:'dob'},
    {prompt: "Please indicate your marital status (Single (never married), Married, Separated, Widowed, Other (if other please specify))", placeholder: "e.g., Single", name:'marital'},
    {prompt: "Please enter your first (native) language", placeholder: "English, French, Arabic, German, etc.", name:'natlang'},
    {prompt: "Please enter any additional languages that you speak in order of proficiency. If you speak French as your second language and a little bit of Spanish, please enter French, Spanish", placeholder: "e.g., French, Spanish", name:'olang'}
  ],
  preamble: 'Welcome! Here are some questions about your background. Please answer the following demographic questions as honestly as possible. All of your responses are strictly confidential',
  on_finish: function(data){
    jsPsych.data.addProperties({
      prolID:  JSON.parse(data.responses)['prolID'],
      age: JSON.parse(data.responses)['age'],
      weight: JSON.parse(data.responses)['weight'],
      height: JSON.parse(data.responses)['height'],
      dob: JSON.parse(data.responses)['dob'],
      marital: JSON.parse(data.responses)['marital'],
      natlang: JSON.parse(data.responses)['natlang'],
      olang: JSON.parse(data.responses)['olang']
    });
  }
};

var health = {
  type: 'survey-text',
  questions: [
    {prompt: "If you have been diagnosed with a mental health condition over the past 6 months, please specify what kind of condition you have. If this does not apply to you, enter N/A.", placeholder: "e.g., Depressive Disorder, N/A", name:'mental'},
    {prompt: "Are you currently taking medication for a mental health treatment? If yes please specify the type", placeholder: "Antidepressants, N/A", name:'mentdrug'},
    {prompt: "If you are taking medication for a mental health treatment, please specify the drug name, frequency of use, and dosage", placeholder: "e.g., Sertraline, 15mg daily", name:'mentpos'}
  ],
  preamble: 'Thank you. Below are some questions about your physical and mental health along with any medication you have been or are currently taking. For any questions that do not apply to you, please enter "N/A". All of your responses are strictly confidential.',
  on_finish: function(data){
    jsPsych.data.addProperties({ // add random data to file
      mental: JSON.parse(data.responses)['mental'],
      mentdrug: JSON.parse(data.responses)['mentdrug'],
      mentpos: JSON.parse(data.responses)['mentpos']
    });
  }
};

var ngs = ['1: Extremely uncharacteristic of me', '2: Somewhat uncharacteristic of me', '3: Uncertain', '4: Somewhat characteristic of me', '5: Extremely characteristic of me']
var NGS = {
  type: 'survey-likert',
  questions: [
    {prompt: "I prefer complex to simple problems.", name:'ngs_01', labels: ngs, required:true},
    {prompt: "I like to have the responsibility of handling a situation that requires a lot of thinking.", name:'ngs_02', labels: ngs, required:true},
    {prompt: "Thinking is not my idea of fun.", name:'ngs_03', labels: ngs, required:true},
    {prompt: "I would rather do something that requires little thought than something that is sure to challenge my thinking abilities.", name:'ngs_04', labels: ngs, required:true},
    {prompt: "I try to anticipate and avoid situations where there is a likely chance I will have to think in depth about something.", name:'ngs_05', labels: ngs, required:true},
    {prompt: "I find satisfaction in deliberating hard and for long hours.", name:'ngs_06', labels: ngs, required:true},
    {prompt: "I only think as hard as I have to.", name:'ngs_07', labels: ngs, required:true},
    {prompt: "I prefer to think about small daily projects to long term ones.", name:'ngs_08', labels: ngs, required:true},
    {prompt: "I like tasks that require little thought once I have learned them.", name:'ngs_09', labels: ngs, required:true},
    {prompt: "The idea of relying on thought to make my way to the top appeals to me.", name:'ngs_10', labels: ngs, required:true},
    {prompt: "I really enjoy a task that involves coming up with new solutions to problems.", name:'ngs_11', labels: ngs, required:true},
    {prompt: "Learning new ways to think does not excite me very much.", name:'ngs_12', labels: ngs, required:true},
    {prompt: "I prefer my life to be filled with puzzles I must solve.", name:'ngs_13', labels: ngs, required:true},
    {prompt: "The notion of thinking abstractly is appealing to me.", name:'ngs_14', labels: ngs, required:true},
    {prompt: "I would prefer a task that is intellectual, difficult, and important to one that is somewhat important but does not require much thought.", name:'ngs_15', labels: ngs, required:true},
    {prompt: "I feel relief rather than satisfaction after completing a task that requires a lot of mental effort.", name:'ngs_16', labels: ngs, required:true},
    {prompt: "It's enough for me that something gets the job done; I don’t care how or why it works.", name:'ngs_17', labels: ngs, required:true},
    {prompt: "I usually end up deliberating about issues even when they do not affect me personally.", name:'ngs_18', labels: ngs, required:true}
      ],
  preamble: 'For each of the statements below, please indicate whether or not the statement is characteristic of you or of what you believe. For example, if the statement is extremely uncharacteristic of you or of what you believe about yourself (not at all like you) please select "1". If the statement is extremely characteristic of you or of what you believe about yourself (very much like you) please select "5".',
  on_finish: function(data){
    jsPsych.data.addProperties({
      ngs_01: JSON.parse(data.responses)['ngs_01'],
      ngs_02: JSON.parse(data.responses)['ngs_02'],
      ngs_03: JSON.parse(data.responses)['ngs_03'],
      ngs_04: JSON.parse(data.responses)['ngs_04'],
      ngs_05: JSON.parse(data.responses)['ngs_05'],
      ngs_06: JSON.parse(data.responses)['ngs_06'],
      ngs_07: JSON.parse(data.responses)['ngs_07'],
      ngs_08: JSON.parse(data.responses)['ngs_08'],
      ngs_09: JSON.parse(data.responses)['ngs_09'],
      ngs_10: JSON.parse(data.responses)['ngs_10'],
      ngs_11: JSON.parse(data.responses)['ngs_11'],
      ngs_12: JSON.parse(data.responses)['ngs_12'],
      ngs_13: JSON.parse(data.responses)['ngs_13'],
      ngs_14: JSON.parse(data.responses)['ngs_14'],
      ngs_15: JSON.parse(data.responses)['ngs_15'],
      ngs_16: JSON.parse(data.responses)['ngs_16'],
      ngs_17: JSON.parse(data.responses)['ngs_17'],
      ngs_18: JSON.parse(data.responses)['ngs_18']
    });
  }
};

var edeq_scale = ['0 Days', '1-2 Days', '3-5 Days', '6-7 Days']
var EDEQ1 = {
  type:'survey-likert',
  questions:[
    {prompt: "Have you been deliberately trying to limit the amount of food you eat to influence your weight or shape (whether or not you have succeeded)?", name:'edeq_1', labels: edeq_scale, required:true},
    {prompt: "Have you gone for long periods of time (e.g., 8 or more waking hours) without eating anything at all in order to influence your weight or shape?", name:'edeq_2', labels: edeq_scale, required:true},
    {prompt: "Has thinking about food, eating or calories made it very difficult to concentrate on things you are interested in (such as working, following a conversation or reading)?", name:'edeq_3', labels: edeq_scale, required:true},
    {prompt: "Has thinking about your weight or shape made it very difficult to concentrate on things you are interested in (such as working, following a  conversation or reading)?", name:'edeq_4', labels: edeq_scale, required:true},
    {prompt: "Have you had a definite fear that you might gain weight?", name:'edeq_5', labels: edeq_scale, required:true},
    {prompt: "Have you had a strong desire to lose weight?", name:'edeq_6', labels: edeq_scale, required:true},
    {prompt: "Have you tried to control your weight or shape by making yourself sick (vomit) or taking laxatives?", name:'edeq_7', labels: edeq_scale, required:true},
    {prompt: "Have you exercised in a driven or compulsive way as a means of controlling your weight, shape or body fat, or to burn off calories?", name:'edeq_8', labels: edeq_scale, required:true},
    {prompt: "Have you had a sense of having lost control over your eating (at the time that you were eating)?", name:'edeq_9', labels: edeq_scale, required:true},
    {prompt: "On how many of these days ( i.e. days on which you had a sense of having lost control over your eating) did you eat what other people would regard as an unusually large amount of food in one go", name:'edeq_10', labels: edeq_scale, required:true}
  ],
  preamble: 'Thank you for completing the task so far! Please answer the following series of questions as honestly as possible. For this page of questions, on how many days OF THE PAST 7 DAYS...',
  on_finish: function(data){
    jsPsych.data.addProperties({
      EDEQ_1: JSON.parse(data.responses)['edeq_1'],
      EDEQ_2: JSON.parse(data.responses)['edeq_2'],
      EDEQ_3: JSON.parse(data.responses)['edeq_3'],
      EDEQ_4: JSON.parse(data.responses)['edeq_4'],
      EDEQ_5: JSON.parse(data.responses)['edeq_5'],
      EDEQ_6: JSON.parse(data.responses)['edeq_6'],
      EDEQ_7: JSON.parse(data.responses)['edeq_7'],
      EDEQ_8: JSON.parse(data.responses)['edeq_8'],
      EDEQ_9: JSON.parse(data.responses)['edeq_9'],
      EDEQ_10: JSON.parse(data.responses)['edeq_10']
    });
  }
};

var EDEQ2 = {
  type:'survey-likert',
  questions:[
    {prompt: "Has your weight or shape influenced how you think about (judge) yourself as a person?", name:'edeq_11', labels: ['Not at All', 'Slightly', 'Moderately','Markedly'], required:true},
    {prompt: "If you're paying attention please select 'Moderately' for this question.", name:'catch1', labels: ['Not at All', 'Slightly', 'Moderately','Markedly'], required:true},
    {prompt: "How dissatisfied have you been with your weight or shape?", name:'edeq_12', labels: ['Not at All', 'Slightly', 'Moderately','Markedly'], required:true}
  ],
  preamble: 'OVER THE PAST 7 DAYS...',
  on_finish: function(data){
    jsPsych.data.addProperties({
      EDEQ_11: JSON.parse(data.responses)['edeq_11'],
      catch1: JSON.parse(data.responses)['catch1'],
      EDEQ_12: JSON.parse(data.responses)['edeq_12']
    });
  }
};

var SESincome = {
  type:'survey-likert',
  questions:[
    {prompt: "Please indicate your parents' weekly income", name:'sesparent', labels: ['< 100$', '101-200$', '201-300$', '301-400$', '401-500$', '501-600$', '601-700$', '701-800$', '801-900$', '901$ +'], required:true},
    {prompt: "Please indicate your weekly income", name:'sesstudent', labels: ['< 100$', '101-200$', '201-300$', '301-400$', '401-500$', '501-600$', '601-700$', '701-800$', '801-900$', '901$ +'], required:true},
    {prompt: "What is your native currency?", name:'sescurrency', labels: ['CAD', 'USD', 'GBP', 'AUS', 'EUR', 'Other'], required:true},
    {prompt: "We are interested in how you perceive your life. Think of a ladder representing where people stand in Canada. At the top of the ladder are the people who are the best off -- those who have the most money, the most education, and the most respected jobs. At the bottom are the people who are the worst off -- who have the least money, least education, and the least respected jobs or no job. The higher up you are on this ladder, the closer you are to the people at the very top; the lower you are, the closer you are to the people at the very bottom. Imagine this rating scale represents the ladder. Where would you place yourself, relative to other people in Canada?", name:'sesladder', labels: ['1, very low on the social ladder', '2', '3', '4', '5', '6', '7', '8', '9', '10, very high on the social ladder'], required:true}
  ],
  preamble: 'For statistical purposes, we are interested in average incomes in Canadian Dollars. Please make your best guess, converting your own native currency to CAD. Some exchange rates are: 1 USD = 1.33 CAD, 1 AUS = 0.95 CAD, 1 EUR = 1.56 CAD, 1 GBP = 1.70 CAD',
  on_finish: function(data){
    jsPsych.data.addProperties({
      sesparent: JSON.parse(data.responses)['sesparent'],
      sesstudent: JSON.parse(data.responses)['sesstudent'],
      sesladder: JSON.parse(data.responses)['sesladder'],
      sescurrency: JSON.parse(data.responses)['sescurrency']
    });
  }
};

var EDUC = {
  type:'survey-likert',
  questions:[
    {prompt: "If you completed High School (Secondary School), what was your average grade approximately?", name:'educ_hs', labels: ['90-100 (A+)', '85-89 (A)', '80-84 (A-)', '77-79 (B+)', '73-76 (B)', '70-72 (B-)', '67-70 (C+)', '63-66 (C)', '60-62 (C-)', '57-59 (D+)', '53-56 (D)', '50-52 (D-)', '< 50 (F)', 'I did not complete High School'], required:true},
    {prompt: "If you completed studies at a non-university college (or post-secondary institution), or CEGEP what was your average grade approximately?", name:'educ_ce', labels: ['90-100 (A+)', '85-89 (A)', '80-84 (A-)', '77-79 (B+)', '73-76 (B)', '70-72 (B-)', '67-70 (C+)', '63-66 (C)', '60-62 (C-)', '57-59 (D+)', '53-56 (D)', '50-52 (D-)', '< 50 (F)', 'N/A'], required:false}
  ],
  preamble: 'Here are some additional questions about your education background',
  on_finish: function(data){
    jsPsych.data.addProperties({
      educ_hs: JSON.parse(data.responses)['educ_hs'],
      educ_ce: JSON.parse(data.responses)['educ_ce']
    });
  }
};

var kirby = {
  type: 'survey-multi-choice',
  questions: [
    {prompt: "Would you rather have $30 tonight or $85 in 14 days?", options: ['$30 tonight', '$85 in 14 days'],  name:'kirby01', required: true, horizontal: true,},
    {prompt: "Would you rather have $40 tonight or $55 in 25 days?", options: ['$40 tonight', '$55 in 25 days'],  name:'kirby02', required: true, horizontal: true,},
    {prompt: "Would you rather have $67 tonight or $85 in 35 days?", options: ['$67 tonight', '$85 in 35 days'],  name:'kirby03', required: true, horizontal: true,},
    {prompt: "Would you rather have $34 tonight or $35 in 43 days?", options: ['$34 tonight', '$35 in 43 days'],  name:'kirby04', required: true, horizontal: true,},
    {prompt: "Would you rather have $15 tonight or $35 in 10 days?", options: ['$15 tonight', '$35 in 10 days'],  name:'kirby05', required: true, horizontal: true,},
    {prompt: "Would you rather have $32 tonight or $55 in 20 days?", options: ['$32 tonight', '$55 in 20 days'],  name:'kirby06', required: true, horizontal: true,},
    {prompt: "Would you rather have $83 tonight or $85 in 35 days?", options: ['$83 tonight', '$85 in 35 days'],  name:'kirby07', required: true, horizontal: true,},
    {prompt: "Would you rather have $21 tonight or $30 in 75 days?", options: ['$21 tonight', '$30 in 75 days'],  name:'kirby08', required: true, horizontal: true,},
    {prompt: "Would you rather have $48 tonight or $55 in 45 days?", options: ['$48 tonight', '$55 in 45 days'],  name:'kirby09', required: true, horizontal: true,},
    {prompt: "Would you rather have $40 tonight or $65 in 70 days?", options: ['$40 tonight', '$65 in 70 days'],  name:'kirby10', required: true, horizontal: true,},
    {prompt: "Would you rather have $25 tonight or $35 in 25 days?", options: ['$25 tonight', '$35 in 25 days'],  name:'kirby11', required: true, horizontal: true,},
    {prompt: "Would you rather have $65 tonight or $75 in 50 days?", options: ['$65 tonight', '$75 in 50 days'],  name:'kirby12', required: true, horizontal: true,},
    {prompt: "Would you rather have $24 tonight or $55 in 10 days?", options: ['$24 tonight', '$55 in 10 days'],  name:'kirby13', required: true, horizontal: true,},
    {prompt: "Would you rather have $30 tonight or $35 in 20 days?", options: ['$30 tonight', '$35 in 20 days'],  name:'kirby14', required: true, horizontal: true,},
    {prompt: "Would you rather have $53 tonight or $55 in 55 days?", options: ['$53 tonight', '$55 in 55 days'],  name:'kirby15', required: true, horizontal: true,},
    {prompt: "Would you rather have $47 tonight or $60 in 50 days?", options: ['$47 tonight', '$60 in 50 days'],  name:'kirby16', required: true, horizontal: true,},
    {prompt: "Would you rather have $40 tonight or $70 in 20 days?", options: ['$40 tonight', '$70 in 20 days'],  name:'kirby17', required: true, horizontal: true,},
    {prompt: "Would you rather have $50 tonight or $80 in 70 days?", options: ['$50 tonight', '$80 in 70 days'],  name:'kirby18', required: true, horizontal: true,},
    {prompt: "Would you rather have $45 tonight or $70 in 35 days?", options: ['$45 tonight', '$70 in 35 days'],  name:'kirby19', required: true, horizontal: true,},
    {prompt: "Would you rather have $27 tonight or $30 in 35 days?", options: ['$27 tonight', '$30 in 35 days'],  name:'kirby20', required: true, horizontal: true,},
    {prompt: "Would you rather have $16 tonight or $30 in 35 days?", options: ['$16 tonight', '$30 in 35 days'],  name:'kirby21', required: true, horizontal: true,}
  ],
    preamble: 'Here are some scenarios where you can imagine picking between having one monetary reward now, or a greater reward later. Please select which option you would prefer for each choice.',
    on_finish: function(data){
        jsPsych.data.addProperties({
        kirby01: JSON.parse(data.responses)['kirby01'],
        kirby02: JSON.parse(data.responses)['kirby02'],
        kirby03: JSON.parse(data.responses)['kirby03'],
        kirby04: JSON.parse(data.responses)['kirby04'],
        kirby05: JSON.parse(data.responses)['kirby05'],
        kirby06: JSON.parse(data.responses)['kirby06'],
        kirby07: JSON.parse(data.responses)['kirby07'],
        kirby08: JSON.parse(data.responses)['kirby08'],
        kirby09: JSON.parse(data.responses)['kirby09'],
        kirby10: JSON.parse(data.responses)['kirby10'],
        kirby11: JSON.parse(data.responses)['kirby11'],
        kirby12: JSON.parse(data.responses)['kirby12'],
        kirby13: JSON.parse(data.responses)['kirby13'],
        kirby14: JSON.parse(data.responses)['kirby14'],
        kirby15: JSON.parse(data.responses)['kirby15'],
        kirby16: JSON.parse(data.responses)['kirby16'],
        kirby17: JSON.parse(data.responses)['kirby17'],
        kirby18: JSON.parse(data.responses)['kirby18'],
        kirby19: JSON.parse(data.responses)['kirby19'],
        kirby20: JSON.parse(data.responses)['kirby20'],
        kirby21: JSON.parse(data.responses)['kirby21']
    });
  }
};

var bsqr_scale = ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often', 'Always']
var BSQR = {
  type:'survey-likert',
  questions:[
    {prompt: "Have you been so worried about your shape that you have been feeling that you ought to diet?", name:'bsqr_1', labels: bsqr_scale, required:true},
    {prompt: "Has being with thin people made you feel self-conscious about	your shape?", name:'bsqr_2', labels: bsqr_scale, required:true},
    {prompt: "Have you ever noticed the shape of other people and felt that your own shape compared unfavourably?", name:'bsqr_3', labels: bsqr_scale, required:true},
    {prompt: "Has being undressed, such as when taking a bath, made you feel fat?", name:'bsqr_4', labels: bsqr_scale, required:true},
    {prompt: "Has eating sweets, cakes, or other high calorie food made you feel fat?", name:'bsqr_5', labels: bsqr_scale, required:true},
    {prompt: "Have you felt excessively large and rounded?", name:'bsqr_6', labels: bsqr_scale, required:true},
    {prompt: "Have you felt ashamed of your body?", name:'bsqr_7', labels: bsqr_scale, required:true},
    {prompt: "Has worry about your shape made you diet?", name:'bsqr_8', labels: bsqr_scale, required:true},
    {prompt: "Have you thought that you are the shape you are because you lack self-control?", name:'bsqr_9', labels: bsqr_scale, required:true},
    {prompt: "Have you worried about other people seeing rolls of fat around your waist and stomach?", name:'bsqr_10', labels: bsqr_scale, required:true},
    {prompt: "Have you felt that it is not fair that other people are thinner than you?", name:'bsqr_11', labels: bsqr_scale, required:true},
    {prompt: "If you're paying attention to this question, please select 'Rarely'. ", name:'catch2', labels: bsqr_scale, required:true},
    {prompt: "Has seeing your reflection (e.g., in a mirror or shop window) made you feel bad about your shape?", name:'bsqr_12', labels: bsqr_scale, required:true},
    {prompt: "Have you been particularly self-conscious about your shape when in the company of other people?", name:'bsqr_13', labels: bsqr_scale, required:true},
    {prompt: "Has worry about your shape made you feel you ought to exercise?", name:'bsqr_14', labels: bsqr_scale, required:true}
  ],
  preamble: 'We would like to know how you have been feeling about your appearance over THE PAST TWO WEEKS. Please read each question and select the appropriate option. Please answer all the questions.',
  on_finish: function(data){
    jsPsych.data.addProperties({
      BSQR_1: JSON.parse(data.responses)['bsqr_1'],
      BSQR_2: JSON.parse(data.responses)['bsqr_2'],
      BSQR_3: JSON.parse(data.responses)['bsqr_3'],
      BSQR_4: JSON.parse(data.responses)['bsqr_4'],
      BSQR_5: JSON.parse(data.responses)['bsqr_5'],
      BSQR_6: JSON.parse(data.responses)['bsqr_6'],
      BSQR_7: JSON.parse(data.responses)['bsqr_7'],
      BSQR_8: JSON.parse(data.responses)['bsqr_8'],
      BSQR_9: JSON.parse(data.responses)['bsqr_9'],
      BSQR_10: JSON.parse(data.responses)['bsqr_10'],
      BSQR_11: JSON.parse(data.responses)['bsqr_11'],
      catch2: JSON.parse(data.responses)['catch2'],
      BSQR_12: JSON.parse(data.responses)['bsqr_12'],
      BSQR_13: JSON.parse(data.responses)['bsqr_13'],
      BSQR_14: JSON.parse(data.responses)['bsqr_14']
    });
  }
};

var bsi_scale = ['Not at All', 'A Little Bit', 'Moderately', 'Quite a Bit', 'Extremely']
var BSI = {
  type:'survey-likert',
  questions:[
    {prompt: "Faintness or dizzinnes", name:'bsi_1', labels: bsi_scale, required:true},
    {prompt: "Feeling no interest in things", name:'bsi_2', labels: bsi_scale, required:true},
    {prompt: "Nervousness or shakiness inside", name:'bsi_3', labels: bsi_scale, required:true},
    {prompt: "Pains in heart or chest", name:'bsi_4', labels: bsi_scale, required:true},
    {prompt: "Feeling lonely", name:'bsi_5', labels: bsi_scale, required:true},
    {prompt: "Feeling tense or keyed up", name:'bsi_6', labels: bsi_scale, required:true},
    {prompt: "Nausea or upset stomach", name:'bsi_7', labels: bsi_scale, required:true},
    {prompt: "Feeling blue", name:'bsi_8', labels: bsi_scale, required:true},
    {prompt: "If you're paying attention, please select 'Not at All' for this question.", name:'catch3', labels: bsi_scale, required:true},
    {prompt: "Suddenly scared for no reason", name:'bsi_9', labels: bsi_scale, required:true},
    {prompt: "Trouble catching your breath", name:'bsi_10', labels: bsi_scale, required:true},
    {prompt: "Feelings of worthlessness", name:'bsi_11', labels: bsi_scale, required:true},
    {prompt: "Spells of terror or panic", name:'bsi_12', labels: bsi_scale, required:true},
    {prompt: "Numbness or tingling in parts of your body", name:'bsi_13', labels: bsi_scale, required:true},
    {prompt: "Feeling hopeless about the future", name:'bsi_14', labels: bsi_scale, required:true},
    {prompt: "Feeling so restless you couldn't sit still", name:'bsi_15', labels: bsi_scale, required:true},
    {prompt: "Feeling weak in parts of your body", name:'bsi_16', labels: bsi_scale, required:true},
    {prompt: "Thoughts of ending your life", name:'bsi_17', labels: bsi_scale, required:true},
    {prompt: "Feeling fearful", name:'bsi_18', labels: bsi_scale, required:true}
  ],
  preamble: 'Please read each sentence carefully, and choose the option that best describes how much that problem has distressed or bothered you during the PAST 7 DAYS INCLUDING TODAY.',
  on_finish: function(data){
    jsPsych.data.addProperties({
      BSI_1: JSON.parse(data.responses)['bsi_1'],
      BSI_2: JSON.parse(data.responses)['bsi_2'],
      BSI_3: JSON.parse(data.responses)['bsi_3'],
      BSI_4: JSON.parse(data.responses)['bsi_4'],
      BSI_5: JSON.parse(data.responses)['bsi_5'],
      BSI_6: JSON.parse(data.responses)['bsi_6'],
      BSI_7: JSON.parse(data.responses)['bsi_7'],
      BSI_8: JSON.parse(data.responses)['bsi_8'],
      catch3: JSON.parse(data.responses)['catch3'],
      BSI_9: JSON.parse(data.responses)['bsi_9'],
      BSI_10: JSON.parse(data.responses)['bsi_10'],
      BSI_11: JSON.parse(data.responses)['bsi_11'],
      BSI_12: JSON.parse(data.responses)['bsi_12'],
      BSI_13: JSON.parse(data.responses)['bsi_13'],
      BSI_14: JSON.parse(data.responses)['bsi_14'],
      BSI_15: JSON.parse(data.responses)['bsi_15'],
      BSI_16: JSON.parse(data.responses)['bsi_16'],
      BSI_17: JSON.parse(data.responses)['bsi_17'],
      BSI_18: JSON.parse(data.responses)['bsi_18']
    });
  }
};

var gender_options = ["Female &nbsp &nbsp", "Male &nbsp &nbsp", "Transgender &nbsp &nbsp", "Non-Binary &nbsp &nbsp"];
var ethnicity_options = ["American Indian or Alaskan Native  &nbsp &nbsp", "Native Hawaiian or Other Pacific Islander  &nbsp &nbsp", "Asian  &nbsp &nbsp", "Hispanic or Latino or Spanish Origin of any race  &nbsp &nbsp", "Black or African American  &nbsp &nbsp", "Middle Eastern or North African  &nbsp &nbsp", "White or Caucasian  &nbsp &nbsp", "I would rather not answer &nbsp &nbsp"];
var education_options = ["Elementary School  &nbsp &nbsp", "Junior High School  &nbsp &nbsp", "High School  &nbsp &nbsp", "CEGEP, non-university college, trade school or equivalent  &nbsp &nbsp", "Undergraduate degree  &nbsp &nbsp", "Graduate degree  &nbsp &nbsp", "Professional degree (i.e., Law School, Medical School, Dentistry) &nbsp &nbsp"];
var school_options = ["Yes, but not at a university  &nbsp &nbsp", "Yes, Undergraduate studies  &nbsp &nbsp", "Yes, Graduate studies  &nbsp &nbsp", "No, currently not in school  &nbsp &nbsp"];
var demo2 = {
  type: 'survey-multi-choice',
  questions: [
    {prompt: "What is your gender? ", options: gender_options, name:'gender', required: true, horizontal: false,},
    {prompt: "What is your ethnicity? ", options: ethnicity_options, name:'ethnicity', required: true, horizontal: false,}, // Adapted from https://ir.aa.ufl.edu/surveys/race-and-ethnicity-survey/
    {prompt: "Have you been diagnosed with a mental health condition over the past 6 months? ", options: ['Yes' + '&nbsp &nbsp &nbsp', 'No' + '&nbsp &nbsp'], name:'mental_check', required: true, horizontal: false,},
    {prompt: "What is your highest level of education? ", name:'educ_l', options: education_options, required: true, horizontal: false,},
    {prompt: "Are you currently attending school? ", name:'educ_c', options: school_options, required: false}
  ],
    preamble: 'Here are some more demographic questions that we will use for statistical purposes',
    on_finish: function(data){
        jsPsych.data.addProperties({
        gender: JSON.parse(data.responses)['gender'],
        ethnicity: JSON.parse(data.responses)['ethnicity'],
        mental_check: JSON.parse(data.responses)['mental_check'],
        educ_l: JSON.parse(data.responses)['educ_l'],
        educ_c: JSON.parse(data.responses)['educ_c']
    });
  }
};

var SOC = {
  type:'survey-likert',
  questions:[
    {prompt: "How many times have you used social media in the past month?", name:'soc_1', labels: ['Less than once a week', 'Less than once a day', 'Two to three times a day','Four to five times a day', 'At least six times a day'], required:true},
    {prompt: "How much time are you online on social media every day?", name:'soc_2', labels: ['Less than 30 minutes', 'Between 31 minutes and 2 hours', 'Between 2 and 6 hours', 'Between 6 and 12 hours', '12 hours or more'], required:true},
    {prompt: "How much time are you actually spending on social media every day?", name:'soc_3', labels: ['Less than 30 minutes', 'Between 31 minutes to 60 minutes', 'Between 1 and 2 hours', 'Between 2 and 4 hours', '5 hours or more'], required:true},
    {prompt: "How many years have passed since you became active on social media?", name:'soc_4', labels: ['Less than 3 years', 'Between 4 and 5 years', 'Between 6 and 7 years', 'Between 8 and 9 years', '10 or more years'], required:true},
    {prompt: "How many friends do you have on social media?", name:'soc_5', labels: ['Less than 50 friends', '51 to 100 friends', '101 to 150 friends', '151 to 200 friends', 'More than 200 friends'], required:true}
  ],
  preamble: 'Below are some questions concerning the your social media habits. For these questions, consider all your activity on social media platforms as a whole over THE PAST 6 MONTHS.',
  on_finish: function(data){
    jsPsych.data.addProperties({
      soc_1: JSON.parse(data.responses)['soc_1'],
      soc_2: JSON.parse(data.responses)['soc_2'],
      soc_3: JSON.parse(data.responses)['soc_3'],
      soc_4: JSON.parse(data.responses)['soc_4'],
      soc_5: JSON.parse(data.responses)['soc_5']
    });
  }
};

var screenweek = {
  type: 'survey-text',
  questions: [
    {prompt: "On the average weekday, how much time do you use television as the primary activity?", placeholder: "HH:MM, ex: 1:15", name: 'tv_01'},
    {prompt: "On the average weekday, how much time do you use TV-connected devices (e.g. streaming devices, video game consoles) as the primary activity?", placeholder: "HH:MM", name: 'dev_01'},
    {prompt: "On the average weekday, how much time do you use your laptop or computer as the primary activity?", placeholder: "HH:MM", name: 'lap_01'},
    {prompt: "On the average weekday, how much time do you use your smartphone as the primary activity?", placeholder: "HH:MM", name: 'pho_01'},
    {prompt: "On the average weekday, how much time do you use your tablet as the primary activity?", placeholder: "HH:MM", name: 'tab_01'}
  ],
  preamble: 'The next few sets of questions are about your time looking at screens. Please enter your data as "HH:MM". Thinking of an average WEEKDAY (from when you wake up until you go to sleep) OVER THE PAST 6 MONTHS, how much time do you spend using each of the following types of screen as the primary activity? Please answer using both HOURS and MINUTES like so: 02:45 for Two hours and Forty-Five minutes. If you spend no time on an activity, you may enter 00:00. For the following set of questions, primary activity is defined as the main activity you are engaged in rather than using a television/other screen in the background while performing another activity such as cooking or exercising.',
  on_finish: function(data){
    jsPsych.data.addProperties({
      TV01: JSON.parse(data.responses)['tv_01'],
      DEV01: JSON.parse(data.responses)['dev_01'],
      LAP01: JSON.parse(data.responses)['lap_01'],
      PHO01: JSON.parse(data.responses)['pho_01'],
      TAB01: JSON.parse(data.responses)['tab_01']
    });
  }
};

var screennight = {
  type: 'survey-text',
  questions: [
    {prompt: "On the average weeknight, how much time do you use television as the primary activity?", placeholder: "HH:MM, ex: 1:15", name: 'tv_02'},
    {prompt: "On the average weeknight, how much time do you use TV-connected devices (e.g. streaming devices, video game consoles) as the primary activity?", placeholder: "HH:MM", name: 'dev_02'},
    {prompt: "On the average weeknight, how much time do you use your laptop or computer as the primary activity?", placeholder: "HH:MM", name: 'lap_02'},
    {prompt: "On the average weeknight, how much time do you use your smartphone as the primary activity?", placeholder: "HH:MM", name: 'pho_02'},
    {prompt: "On the average weeknight, how much time do you use your tablet as the primary activity?", placeholder: "HH:MM", name: 'tab_02'}
  ],
  preamble: 'Thinking of an average WEEKNIGHT (from when you return from work until you go to sleep) OVER THE PAST 6 MONTHS, how much time do you spend using each of the following types of screen as the primary activity? Please answer using both HOURS and MINUTES like so: 02:45 for Two hours and Forty-Five minutes. If you spend no time on an activity, you may enter 00:00. For the following set of questions, primary activity is defined as the main activity you are engaged in rather than using a television/other screen in the background while performing another activity such as cooking or exercising.',
  on_finish: function(data){
    jsPsych.data.addProperties({
      TV02: JSON.parse(data.responses)['tv_02'],
      DEV02: JSON.parse(data.responses)['dev_02'],
      LAP02: JSON.parse(data.responses)['lap_02'],
      PHO02: JSON.parse(data.responses)['pho_02'],
      TAB02: JSON.parse(data.responses)['tab_02']
    });
  }
};

var screenwknd = {
  type: 'survey-text',
  questions: [
    {prompt: "On the average weekend day, how much time do you use television as the primary activity?", placeholder: "HH:MM, ex: 1:15", name: 'tv_03'},
    {prompt: "On the average weekend day, how much time do you use TV-connected devices (e.g. streaming devices, video game consoles) as the primary activity?", placeholder: "HH:MM", name: 'dev_03'},
    {prompt: "On the average weekend day, how much time do you use your laptop or computer as the primary activity?", placeholder: "HH:MM", name: 'lap_03'},
    {prompt: "On the average weekend day, how much time do you use your smartphone as the primary activity?", placeholder: "HH:MM", name: 'pho_03'},
    {prompt: "On the average weekend day, how much time do you use your tablet as the primary activity?", placeholder: "HH:MM", name: 'tab_03'}
  ],
  preamble: 'Thinking of an average WEEKEND DAY (Saturday or Sunday, from when you wake up until you go to sleep) OVER THE PAST 6 MONTHS, how much time do you spend using each of the following types of screen as the primary activity? Please answer using both HOURS and MINUTES like so: 02:45 for Two hours and Forty-Five minutes. If you spend no time on an activity, you may enter 00:00. For the following set of questions, primary activity is defined as the main activity you are engaged in rather than using a television/other screen in the background while performing another activity such as cooking or exercising.',
  on_finish: function(data){
    jsPsych.data.addProperties({
      TV03: JSON.parse(data.responses)['tv_03'],
      DEV03: JSON.parse(data.responses)['dev_03'],
      LAP03: JSON.parse(data.responses)['lap_03'],
      PHO03: JSON.parse(data.responses)['pho_03'],
      TAB03: JSON.parse(data.responses)['tab_03']
    });
  }
};

var screensec = {
  type: 'survey-text',
  questions: [
    {prompt: "Thinking about a regular weekday (24 hours), on average, OVER THE PAST 6 MONTHS, how many hours over the course of the whole day are you exposed to background screen use? For example, if you exercise in the morning for one hour while watching the TV news, you use your smartphone for one hour while eating lunch and an additional 30 minutes while eating dinner, you would estimate that you are exposed to 2 hours and 30 minutes of background screen use per day.", placeholder: "HH:MM", name: 'Wedsec'},
    {prompt: "Now we want to ask about background screen use during the evening specifically. On average, how many hours per evening (24 hours) (Monday through Friday) OVER THE PAST 6 MONTHS, are you exposed to background screen use from when you return from work until you go to sleep?", placeholder: "HH:MM", name: 'Wnisec'},
    {prompt: "Now we want to ask about background screen use during the weekend. Thinking about a regular weekend day (24 hours) (Saturday or Sunday), OVER THE PAST 6 MONTHS, on average, how many hours over the course of the whole day (from when you wake up until you go to sleep) are you exposed to background screen use?", placeholder: "HH:MM", name: 'Wknsec'}
  ],
  preamble: 'Thank you! Only three last questions about screen time. For the following set of questions, background screen use is defined as the use of a television or another screen near you while performing other activities such as exercising, cooking, and interacting with family/friends. Please answer each question using both HOURS and MINUTES like so: 02:45 for Two hours and Forty-Five minutes. If you spend no time on an activity, you may enter 00:00.',
  on_finish: function(data){
    jsPsych.data.addProperties({
      WEDSEC: JSON.parse(data.responses)['Wedsec'],
      WNISEC: JSON.parse(data.responses)['Wnisec'],
      WKNSEC: JSON.parse(data.responses)['Wknsec']
    });
  }
};
