// INSTRUCTIONS FOR PICC BODY IMAGE TASK //

var welcome = {
	    type: 'instructions',
	    pages: [
		'Welcome to this study! We are interested in studying how people perceive and identify different kinds of bodies and faces. Click next to begin.',
		"<p>On the next screen, you will be asked to answer some questions about yourself. </p>" +
		"<p>Please do so as honestly as possible. </p>" +
		"<p>After you answer these questions, you will be directed to the main tasks. More instructions will follow then. Click next to continue.</p>"
	    ],
	    show_clickable_nav: true
};

var i1 = {
	type: 'instructions',
	pages: [
'Thank you for answering our questions! You are now ready to proceed to the main task. Click next to begin.',

"<p>In this experiment, you will see a series of body images. </p>" +
"<p>The images will be presented on the screen one at a time. </p>" +
"<p>Your job in this study will be to identify bodies you think are <strong>overweight</strong>.</p>",

"<p>When you see a body on the screen that you think is overweight, press the <b>"+choicekeys[0].toUpperCase()+" key.</b></p>"+
"<p>For all other bodies, press the <b>"+choicekeys[1].toUpperCase()+" key. </b></p>",

"<p>The bodies will be presented in series with breaks in between. </p>"+
"<p>This means that you will see a series of bodies, have a short break, and then another series of bodies, until you have seen	<strong>16 series.</strong></p>",

"<p>Some of the series you see may have a lot of overweight bodies, and others may have only a few.</p>" +
"<p>There is nothing for you to keep track of. Just make each choice as honestly as you can</p>",

"<p>Please respond <strong>after</strong> you see each body. A <strong>?</strong> will appear when it is time to answer. </p>" +
"<p>You should do your best to answer quickly and accurately during the study. However, if you make a mistake and hit the wrong button at any point, don't worry -- just keep going.</p>",

"<p>Now you will complete a brief practice series to learn how the task works.</p>"+
"<p>Go back through the instructions if you do not yet understand the task.</p>" +
"<p>Click next when you're ready to start!</p>"
	],
	show_clickable_nav: true
};

var i2 = { // after practice trials
	type: "html-keyboard-response",
	stimulus: "<p>You have now completed the practice series.</p>"+
"<p>If you have any questions, please reload this page and read the instructions again.</p>"+
"<p>Otherwise, you're ready to begin the study.</p>"+
"<p><strong>REMEMBER</strong>: Press <b>"+choicekeys[0].toUpperCase()+" </b>when you think the model is overweight, and <b>"+choicekeys[1].toUpperCase()+" </b>if not. </p>"+
"<p>Press SPACE when you're ready to start!</p>",
	choices: ['space'],
	post_trial_gap: poststimtime
};

var end = {
	type: "html-keyboard-response",
	stimulus: "<p>You have finished the main task!</p>"+
						"<p>You are almost done the entire experiment. There are only a few short things left to do.</p>"+
						"<p>On the next screen, there will be just one more body to judge.</p>"+
						"<p>When you are ready, press SPACE to proceed to this last judgement.</p>",
	choices: ['space']
};

var finish = {
  type: "html-keyboard-response",
  stimulus: "<p>You have finished the entire experiment!</p>"+
            "<p>You may now exit the window and you will be redirected back to Prolific</p>",
  choices: ['e']
};
