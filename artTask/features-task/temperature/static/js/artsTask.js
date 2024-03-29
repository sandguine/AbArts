/*
 * Requires:
 *     psiturk.js
 *     utils.js
 */

// Initalize psiturk object
var psiTurk = new PsiTurk(uniqueId, adServerLoc, mode);

var mycondition = condition;  // these two variables are passed by the psiturk server process
var mycounterbalance = counterbalance;  // they tell you which condition you have been assigned to
// they are not used in the stroop code but may be useful to you

// All pages to be loaded
var pages = [
	"instructions/instruct-ready.html"
];

psiTurk.preloadPages(pages);

var instructionPages = [ // add as a list as many pages as you like
	//instructions/instruct-1.html",
	"instructions/instruct-ready.html"
];

/********************
* HTML manipulation
*
* All HTML files in the templates directory are requested
* from the server when the PsiTurk object is created above. We
* need code to get those pages from the PsiTurk object and
* insert them into the document.
*
********************/

var ArtExperiment = function() {
	/* create timeline */
	var timeline = [];

	timeline.push({
		type: 'fullscreen',
		fullscreen_mode: true
	});

	/* declare necessary variables */
	var features_questions = [
		"<p>On a scale of -2 = Abstract to 2 = Concrete, what is the <em>Realisticity</em> of the artwork shown? </br> <b>-2 = Abstract, -1 = Slightly Abstract, 0 = Neutral, 1 = Slightly Concrete, 2 = Concrete</b> </p>",
		"<p>On a scale of -2 = Still to 2 = Dynamic, what is the <em>Dynamicity</em> is the artwork shown? </br> <b>-2 = Still, -1 = Slightly Still, 0 = Neutral, 1 = Slightly Dynamic, 2 = Dynamic</b> </p>",
		"<p>On a scale of -2 = Warm to 2 = Cold, what is the <em>Temperature</em> of the artwork shown? </br> <b>-2 = Warm, -1 = Slightly Warm, 0 = Neutral, 1 = Slightly Cold, 2 = Cold</b> </p>",
		"<p>On a scale of -2 = Negative to 2 = Positive, what is the <em>Valence</em> of the artwork shown? </br> <b>-2 = Negative, -1 = Slightly Negative, 0 = Neutral, 1 = Slightly Positive, 2 = Positive</b> </p>"
	];

	var features_options = ["-2", "-1", "0", "1", "2"];
	var arts = jsPsych.timelineVariable('stimulus');
  var catchMe = jsPsych.timelineVariable('stimulus');
	var artShowTime = 0;
	var fixationTime = 250;
	var instrChoices = ["Repeat the example.", "I'm ready!"];
	var mona = 'static/images/0.jpg';
  var theScream = 'static/images/1.jpg';
	var testBlocks = [test_stimuli_r1, test_stimuli_r2, test_stimuli_r3, test_stimuli_r4, test_stimuli_r5,
	test_stimuli_r6, test_stimuli_r7, test_stimuli_r8, test_stimuli_r9, test_stimuli_r10];

	var concreteness = 'static/images/training-for-features-task/abstract-training.bmp';
	var dynamic = 'static/images/training-for-features-task/dynamic-training.jpg';
	var temperature = 'static/images/training-for-features-task/colortemperature-training.bmp';
	var valence = 'static/images/training-for-features-task/valence-training.jpg';

	var qConc = {
    type: 'image-button-response',
		stimulus: arts,
		training: concreteness,
		prompt: features_questions[0],
		response_ends_trial: true,
		choices: features_options
  };

	var qDyna = {
    type: 'image-button-response',
		stimulus: arts,
		training: dynamic,
		prompt: features_questions[1],
		response_ends_trial: true,
		choices: features_options
  };

	var qTemp = {
    type: 'image-button-response',
		stimulus: arts,
		training: temperature,
		prompt: features_questions[2],
		response_ends_trial: true,
		choices: features_options
  };

	var qVale = {
    type: 'image-button-response',
		stimulus: arts,
		training: valence,
		prompt: features_questions[3],
		response_ends_trial: true,
		choices: features_options
  };

	var fixation = {
		type: 'html-keyboard-response',
		stimulus: '<div style="font-size:60px;">+</div>',
		choices: jsPsych.NO_KEYS,
		trial_duration: fixationTime,
		data: {test_part: 'fixation'},
		response_ends_trial: false
	};

	// write a pause between trial function
	var pausePeriod = {
		type: "html-button-response",
		stimulus: "<p>The new set of questions is about to start.</p>" +
				"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the new set!"],
		response_ends_trial: true
	};

	// example shows here

	var qConcEx = {
		type: 'image-button-response',
		stimulus: mona,
		training: concreteness,
		prompt: features_questions[0],
		response_ends_trial: true,
		choices: features_options
	};

	var qDynaEx = {
    type: 'image-button-response',
		stimulus: mona,
		training: dynamic,
		prompt: features_questions[1],
		response_ends_trial: true,
		choices: features_options
  };

	var qTempEx = {
    type: 'image-button-response',
		stimulus: mona,
		training: temperature,
		prompt: features_questions[2],
		response_ends_trial: true,
		choices: features_options
  };

	var qValeEx = {
    type: 'image-button-response',
		stimulus: mona,
		training: valence,
		prompt: features_questions[3],
		response_ends_trial: true,
		choices: features_options
  };

	var beginRealSurvey ={
		type: "html-button-response",
		stimulus: "<p>Ok, very simple, right?</p>" +
				"<p>To repeat the example, click on <b>\"Repeat the example.\"</b> button.</p>" +
				"<p>Ready for the task? Click on the <b>\"I'm ready!\"</b> button.</p>",
				post_trial_gap: 0,
				choices: instrChoices,
				response_ends_trial: true
	};

	var welcome = {
		type: 'instructions',
		pages: [
				"<p>Welcome to our easy and simple survey!</p>",
				"<p>In this survey, you will see various paintings created by different artists.</p>" +
				"<p>We will ask you a few simple questions about the artwork.</p>",
				"<p>You will recieve <b>$15</b> when you complete the task regardless of your knowledge and preferences.</p>" +
				"<p><b>This is not a test of your knowledge, so please answer as honestly as you can.</b></p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	};
	timeline.push(welcome);

	var concExpInstr = {
		type: 'instructions',
		pages: [
				"<p>Ok, let's do an example.</p>",
				"<p>You will see a <b>\"+\"</b> at the beginning of each round.</p>",
				"<p>A painting will appear at the center of the screen.</p>",
				"<p>An example of <b>ABSTRACT</b> vs <b>CONCRETE</b> image will appear on top of the painting.</p>",
				"<p>You can slide to select the option that will appear at the bottom of the screen.</p>",
				"<p>If you think this picture is <b>ABSTRACT</b>, please click on \"-2\"</p>",
				"<p>If you think this picture is <b>SLIGHTLY ABSTRACT</b>, please click on \"-1\".</p>",
				"<p>If you think this picture is <b>NEUTRAL</b>, please click on \"0\".</p>",
				"<p>If you think this picture is <b>SLIGHTLY CONCRETE</b>, please click on \"1\".</p>",
				"<p>If you think this picture is <b>CONCRETE</b>, please click on \"2\".</p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	};

	var dynaExpInstr = {
		type: 'instructions',
		pages: [
				"<p>Ok, let's do an example.</p>",
				"<p>You will see a <b>\"+\"</b> at the beginning of each round.</p>",
				"<p>A painting will appear at the center of the screen.</p>",
				"<p>An example of <b>STILL</b> vs <b>DYNAMIC</b> image will appear on top of the painting.</p>",
				"<p>You can slide to select the option that will appear at the bottom of the screen.</p>",
				"<p>If you think this picture is <b>STILL</b>, please click on \"-2\"</p>",
				"<p>If you think this picture is <b>SLIGHTLY STILL</b>, please click on \"-1\".</p>",
				"<p>If you think this picture is <b>NEUTRAL</b>, please click on \"0\".</p>",
				"<p>If you think this picture is <b>SLIGHTLY DYNAMIC</b>, please click on \"2\".</p>",
				"<p>If you think this picture is <b>DYNAMIC</b>, please click on \"2\".</p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	};

	var tempExpInstr = {
		type: 'instructions',
		pages: [
				"<p>Ok, let's do an example.</p>",
				"<p>You will see a <b>\"+\"</b> at the beginning of each round.</p>",
				"<p>A painting will appear at the center of the screen.</p>",
				"<p>An example of <b>WARM</b> vs <b>COLD</b> image will appear on top of the painting.</p>",
				"<p>You can slide to select the option that will appear at the bottom of the screen.</p>",
				"<p>If you think this picture is <b>WARM</b>, please click on \"-2\"</p>",
				"<p>If you think this picture is <b>SLIGHTLY WARM</b>, please click on \"-1\".</p>",
				"<p>If you think this picture is <b>NEUTRAL</b>, please click on \"0\".</p>",
				"<p>If you think this picture is <b>SLIGHTLY COLD</b>, please click on \"2\".</p>",
				"<p>If you think this picture is <b>COLD</b>, please click on \"2\".</p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	};

	var valeExpInstr = {
		type: 'instructions',
		pages: [
				"<p>Ok, let's do an example.</p>",
				"<p>You will see a <b>\"+\"</b> at the beginning of each round.</p>",
				"<p>A painting will appear at the center of the screen.</p>",
				"<p>An example of <b>NEGATIVE</b> vs <b>POSITIVE</b> image will appear on top of the painting.</p>",
				"<p>You can slide to select the option that will appear at the bottom of the screen.</p>",
				"<p>If you think this picture is <b>NEGATIVE</b>, please click on \"-2\"</p>",
				"<p>If you think this picture is <b>SLIGHTLY NEGATIVE</b>, please click on \"-1\".</p>",
				"<p>If you think this picture is <b>NEUTRAL</b>, please click on \"0\".</p>",
				"<p>If you think this picture is <b>SLIGHTLY POSITIVE</b>, please click on \"2\".</p>",
				"<p>If you think this picture is <b>POSITIVE</b>, please click on \"2\".</p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	};

	var repeatConcInstructions = {
			timeline: [concExpInstr, fixation, qConcEx, beginRealSurvey],
			loop_function: function(data){
					var data = jsPsych.data.get().last(1).values()[0];
					console.log(data);
					if(data.button_pressed == 0){
							return true;
					} else {
							return false;
					}
			}
	};

	var repeatDynaInstructions = {
			timeline: [dynaExpInstr, fixation, qDynaEx, beginRealSurvey],
			loop_function: function(data){
					var data = jsPsych.data.get().last(1).values()[0];
					console.log(data);
					if(data.button_pressed == 0){
							return true;
					} else {
							return false;
					}
			}
	};


	var repeatTempInstructions = {
			timeline: [tempExpInstr, fixation, qTempEx, beginRealSurvey],
			loop_function: function(data){
					var data = jsPsych.data.get().last(1).values()[0];
					console.log(data);
					if(data.button_pressed == 0){
							return true;
					} else {
							return false;
					}
			}
	};
	timeline.push(repeatTempInstructions);

	var repeatValeInstructions = {
			timeline: [valeExpInstr, fixation, qValeEx, beginRealSurvey],
			loop_function: function(data){
					var data = jsPsych.data.get().last(1).values()[0];
					console.log(data);
					if(data.button_pressed == 0){
							return true;
					} else {
							return false;
					}
			}
	};

	var concInstructions = {
		type: 'html-button-response',
		stimulus: "<p>In this part of survey, we ask you to answer the following question.</br></p>" +
		"<p><b>\"What is the REALISTICITY the artwork shown?\"</b></br></p>"+
		"<b>-2 = \'ABSTRACT\', -1 = \'SLIGHTLY ABSTRACT\', 0 = \'NEUTRAL\', 1 = \'SLIGHTLY CONCRETE\',  and 2 = \'CONCRETE\'.\"</b></br></p>" +
		"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the task!"],
		response_ends_trial: true
	};

	var dynaInstructions = {
		type: 'html-button-response',
		stimulus: "<p>In this part of survey, we ask you to answer the following question.</br></p>" +
		"<p><b>\"What is the DYNAMICITY the artwork shown?\"</b></br></p>"+
		"<b>-2 = \'STILL\', -1 = \'SLIGHTLY STILL\', 0 = \'NEUTRAL\', 1 = \'SLIGHTLY DYNAMIC\',  and 2 = \'DYNAMIC\'.\"</b></br></p>" +
		"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the task!"],
		response_ends_trial: true
	};


	var tempInstructions = {
		type: 'html-button-response',
		stimulus: "<p>In this part of survey, we ask you to answer the following question.</br></p>" +
		"<p><b>\"What is the TEMPERATURE the artwork shown?\"</b></br></p>"+
		"<b>-2 = \'WARM\', -1 = \'SLIGHTLY WARM\', 0 = \'NEUTRAL\', 1 = \'SLIGHTLY COLD\',  and 2 = \'COLD\'.\"</b></br></p>" +
		"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the task!"],
		response_ends_trial: true
	};
	timeline.push(tempInstructions);

	var valeInstructions = {
		type: 'html-button-response',
		stimulus: "<p>In this part of survey, we ask you to answer the following question.</br></p>" +
		"<p><b>\"What is the VALENCE the artwork shown?\"</b></br></p>"+
		"<b>-2 = \'NEGATIVE\', -1 = \'SLIGHTLY NEGATIVE\', 0 = \'NEUTRAL\', 1 = \'SLIGHTLY POSITIVE\',  and 2 = \'POSITIVE\'.\"</b></br></p>" +
		"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the task!"],
		response_ends_trial: true
	};

	var i;

	for (i = 0; i < testBlocks.length; i++) {
			var testTemp = {
				timeline: [fixation, qTemp],
				timeline_variables: testBlocks[i],
				repetitions: 0,
				randomize_order: true
			};
			timeline.push(testTemp);

			// break variable
			var breakPoint = {
				type: 'html-button-response',
				stimulus: "<p>This is a break point. Please take your time to relax and refresh your eyes.</br></p>" +
				"<p>Once you're ready to begin again, please click on the button below.</p>",
				post_trial_gap: 0,
				choices: ["Begin the next set!"],
				response_ends_trial: true
			};
			timeline.push(breakPoint);
	}

	var surveyIntro = {
		type: "html-button-response",
		stimulus: "<p>You are almost done!</p>" +
					"<p>Please answer a few more questions.</p>" +
					"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Next \>"],
		response_ends_trial: true
	};
	timeline.push(surveyIntro);

	//survey parameters

	//“Color,” “Composition,” “Meaning/Content,” and “Texture/Brushstrokes.”
	//Other factors mentioned by people include“Shape,” “Perspective,”
	//“Feeling of Motion,” “Balance,”“Style,” “Mood,” “Originality,” “Unity,” etc.
	var yesNo = ["Yes", "No"];
	var ageRange = ["18 to 24 years old", "25 to 34 years old", "35 to 44 years old", "45 years old or above"];
	var genders = ["Female", "Male", "Non-binary"];
	var degrees = ["Did not complete High School", "High School/GED", "Some College or Associate Degree",
								"Bachelor's Degree", "Master's Degree or higher"];
	var artMuseum = ["Less than once a month", "1 to 3 times per month", "Once a week or more"];
	var races = ["American Indian or Alaska Native", "Asian or Asian American", "Black or African American",
							"Native Hawaiian and Other Pacific Islander", "White or Caucasian"];
	var features = ["Color", "Composition", "Meaning/Content", "Texture/Brushstrokes",
								"Shape", "Perspective", "Feeling of Motion", "Balance", "Style",
								"Mood", "Originality", "Unity", "Others"];
			features = jsPsych.randomization.shuffle(features);
	var artSurveyQ = ["Do you have a degree in fine arts or art history?", "How often do you visit arts museum?"];
	var postSurveyQ = ["How old are you?", "Which gender do you most closely identify yourself as?", "Please select the highest degree you have earned?"];
	var arrayofartchoices = [yesNo, artMuseum];
	var arrayofchoices = [ageRange, genders, degrees];

	var participantID = {
		type: 'survey-text',
		questions: [{prompt: "Please enter your participant ID:", rows: 1, columns: 10}]
	};
	timeline.push(participantID);

	var i;
	for (i = 0; i < artSurveyQ.length; i++) {
    	var artSur= {
				type: 'survey-multi-choice',
				questions: [{prompt: artSurveyQ[i], options: arrayofartchoices[i], required: true}]
			};
			//timeline.push(artSur);
	}

	var featuresQ = {
		type: 'survey-multi-select',
		questions: [{prompt: "What are the important factors you concerned with when judging a piece of artwork?", options: features, required: true}]
	};
	//timeline.push(featuresQ);

	var otherFeatures = {
		type: 'survey-text',
		questions: [{prompt: "Are there other factors you concerned with when judging a piece of artwork? Please type them down in the box below.", rows: 5, columns: 100}]
	};
	//timeline.push(otherFeatures);

	var raceQ = {
		type: 'survey-multi-select',
		questions: [{prompt: "Which ethnicity or ethnicities do you closely identify yourself as?", options: races, required: false}]
	};
	//timeline.push(raceQ);

	var i;
	for (i = 0; i < postSurveyQ.length; i++) {
    	var surveyQ = {
				type: 'survey-multi-choice',
				questions: [{prompt: postSurveyQ[i], options: arrayofchoices[i], required: false}]
			};
			//timeline.push(surveyQ);
	}

	var suggestionsBox = {
		type: 'survey-text',
		questions: [{prompt: "Do you have any suggestion or question regarding our task? Please type them down in the box below.", rows: 5, columns: 100}]
	};
	timeline.push(suggestionsBox);

	var all_data = jsPsych.data.get();
	var interactions = jsPsych.data.getInteractionData();

	/* start the survey */
	jsPsych.init({
		timeline: timeline,
		on_finish: function() {
        psiTurk.saveData({
        		success: function() { psiTurk.completeHIT(); }
    		});
		},
		on_data_update: function(data) {
              psiTurk.recordTrialData(data);
							psiTurk.recordTrialData(interactions);
		}
	});
}
/****************
* Questionnaire *
****************/

var Questionnaire = function() {

	var error_message = "<h1>Oops!</h1><p>Something went wrong submitting your HIT. This might happen if you lose your internet connection. Press the button to resubmit.</p><button id='resubmit'>Resubmit</button>";

	record_responses = function() {

		psiTurk.recordTrialData({'phase':'postquestionnaire', 'status':'submit'});

		$('textarea').each( function(i, val) {
			psiTurk.recordUnstructuredData(this.id, this.value);
		});
		$('select').each( function(i, val) {
			psiTurk.recordUnstructuredData(this.id, this.value);
		});

	};

	prompt_resubmit = function() {
		document.body.innerHTML = error_message;
		$("#resubmit").click(resubmit);
	};

	resubmit = function() {
		document.body.innerHTML = "<h1>Trying to resubmit...</h1>";
		reprompt = setTimeout(prompt_resubmit, 10000);

		psiTurk.saveData({
			success: function() {
			    clearInterval(reprompt);
                psiTurk.computeBonus('compute_bonus', function(){
                	psiTurk.completeHIT(); // when finished saving compute bonus, the quit
                });
			},
			error: prompt_resubmit
		});
	};

	// Load the questionnaire snippet
	psiTurk.showPage('postquestionnaire.html');
	psiTurk.recordTrialData({'phase':'postquestionnaire', 'status':'begin'});

	$("#next").click(function () {
	    record_responses();
	    psiTurk.saveData({
            success: function(){
                psiTurk.computeBonus('compute_bonus', function() {
                psiTurk.completeHIT(); // when finished saving compute bonus, the quit
                });
            },
            error: prompt_resubmit});
	});
};

// Task object to keep track of the current phase
var currentview;

/*******************
 * Run Task
 ******************/
$(window).load( function(){
    psiTurk.doInstructions(
    	instructionPages, // a list of pages you want to display in sequence
    	function() { currentview = new ArtExperiment(); } // what you want to do when you are done with instructions
    );
});
