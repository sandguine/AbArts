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
	var questions = [
		"<p>Do you know the name of the artist who painted this picture?</p>",
		"<p>How much do you like the artwork shown? </br> 0 = \'Not at all\', and 3 = \'Strongly Like\'\" </br> </p>"
	]

	var familiar_options = ["I don't know.", "I know."];
	var like_options = ["0", "1", "2", "3"];
	var arts = jsPsych.timelineVariable('stimulus');
	var artShowTime = 2000
	var responsePeriodArtist = 3000
	var responsePeriodLike = 6000
	var fixationTime = 500
	var instrChoices = ["Repeat the example.", "I'm ready!"];
	var mona = 'static/js/img/0.jpg'

	var showArtsFam ={
		type: 'image-button-response',
		stimulus: arts,
		trial_duration: artShowTime,
		response_ends_trial: false,
		prompt: questions[0]
	}

	var showArtsLike ={
		type: 'image-button-response',
		stimulus: arts,
		trial_duration: artShowTime,
		response_ends_trial: false,
		prompt: questions[1]
	}

	var qFamiliar = {
		type: 'image-button-response',
		stimulus: arts,
		prompt: questions[0],
		trial_duration: responsePeriodArtist,
		response_ends_trial: true,
		choices: familiar_options //[, familiar_options, human_options]
	}

	var qLike = {
		type: 'image-button-response',
		stimulus: arts,
		prompt: questions[1],
		trial_duration: responsePeriodLike,
		response_ends_trial: true,
		choices: like_options //[, familiar_options, human_options]
	}

	var fixation = {
		type: 'html-keyboard-response',
		stimulus: '<div style="font-size:60px;">+</div>',
		choices: jsPsych.NO_KEYS,
		trial_duration: function(){
			return jsPsych.randomization.sampleWithoutReplacement([fixationTime], 1)[0];
		},
		data: {test_part: 'fixation'},
		response_ends_trial: false
	}

	// write a pause between trial function
	var pausePeriod = {
		type: "html-button-response",
		stimulus: "<p>The new set of questions is about to start.</p>" +
				"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the new set"],
		response_ends_trial: true
	}

	// example shows here
	var showArtsEx1 ={
		type: 'image-button-response',
		stimulus: mona,
		trial_duration: artShowTime,
		response_ends_trial: false,
		prompt: questions[0]
	}

	var qFamEx = {
		type: 'image-button-response',
		stimulus: mona,
		prompt: questions[0],
		trial_duration: responsePeriodArtist,
		response_ends_trial: true,
		choices: familiar_options //[, familiar_options, human_options]
	}

	var qLikeEx = {
		type: 'image-button-response',
		stimulus: mona,
		prompt: questions[1],
		trial_duration: responsePeriodLike,
		response_ends_trial: true,
		choices: like_options //[, familiar_options, human_options]
	}

	var beginRealSurvey ={
		type: "html-button-response",
		stimulus: "<p>Ok, very simple, right?</p>" +
				"<p>To repeat the example, click on <b>\"Repeat the example.\"</b> button.</p>" +
				"<p>Ready for the task? Click on the <b>\"I'm ready!\"</b> button.</p>",
				post_trial_gap: 0,
				choices: instrChoices,
				response_ends_trial: true
			}

	var welcome = {
		type: 'instructions',
		pages: [
				"<p>Welcome to our easy and simple survey!</p>",
				"<p>In this survey, you will see various paintings created by different artists.</p>" +
				"<p>We will ask you a few simple questions about the artwork.</p>",
				"<p>You will recieve <b>$1</b> when you complete the task regardless of your knowledge and preferences.</p>" +
				"<p><b>This is not a test of your knowledge, so please answer as honestly as you can.</b></p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	}
	timeline.push(welcome);

	var famExpInstr = {
		type: 'instructions',
		pages: [
				"<p>Ok, let's do an example.</p>",
				"<p>You will see a <b>\"+\"</b> at the beginning of each round.</p>",
				"<p>A painting will appear at the center of the screen.</p>" +
				"<p>You have <b>2 seconds</b> to look at the painting.</p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	}

	var afterFamExpInstr = {
		type: 'instructions',
		pages: [
				"<p>You can click on one of the two options that will appear at the bottom of the screen.</p>",
				"<p>If you think you <b>DO NOT KNOW</b> the name of the artist, please click <b>\"I don't know\"</b>.</p>",
				"<p>If you think you <b>KNOW</b> the name of the artist, please click <b>\"I know\"</b>.</p>",
				"<p>You have <b>3 seconds</b> to respond.</p>"
		],
		show_clickable_nav: true,
		allow_backward: true
	}

	var repeatInstructions = {
			timeline: [famExpInstr, fixation, showArtsEx1, afterFamExpInstr, qFamEx, beginRealSurvey],
			loop_function: function(data){
					var data = jsPsych.data.get().last(1).values()[0];
					console.log(data)
					if(data.button_pressed == 0){
							return true;
					} else {
							return false;
					}
			}
	}
	timeline.push(repeatInstructions);

	var familiarInstructions = {
		type: 'html-button-response',
		stimulus: "<p>In this part of survey, we ask you to answer the following question.</br></p>" +
		"<p><b>\"Do you know the name of the artist who painted this picture?\"</b></br></p>" +
		"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the task!"],
		response_ends_trial: true
	}
	timeline.push(familiarInstructions)

	var testFamiliar = {
		timeline: [fixation, showArtsFam, qFamiliar],
		timeline_variables: test_stimuli,
		repetitions: 0,
		randomize_order: true
	}
	timeline.push(testFamiliar);
	timeline.push(pausePeriod);

	var likeExpInstr = {
		type: 'instructions',
		pages: [
				"<p>Ok, let's do another example.</p>",
				"<p>You will see a <b>\"+\"</b> at the beginning of each round.</p>",
				"<p>A painting will appear at the center of the screen.</p>" +
				"<p>You have <b>2 seconds</b> to look at the painting.</p>",
				"<p>You can click on one of the four options that will appear at the bottom of the screen.</p>",
				"<p>If you <b>DO NOT LIKE</b> the painting <b>AT ALL</b>, please click on the option <b>\"0\"</b>.</p>",
				"<p>If you <b>LIKE</b> the painting <b>A LITTLE</b>, please click on the option <b>\"1\"</b>.</p>",
				"<p>If you <b>LIKE</b> the painting, please click on the option <b>\"2\"</b>.</p>",
				"<p>If you <b>STRONGLY LIKE</b> the painting, please click on the option <b>\"3\"</b>.</p>",
				"<p>You have <b>6 seconds</b> to respond.</p>",
		],
		show_clickable_nav: true,
		allow_backward: true
	}

	var repeatLikeInstructions = {
			timeline: [likeExpInstr, fixation, qLikeEx, beginRealSurvey],
			loop_function: function(data){
					var data = jsPsych.data.get().last(1).values()[0];
					console.log(data)
					if(data.button_pressed == 0){
							return true;
					} else {
							return false;
					}
			}
	}
	timeline.push(repeatLikeInstructions);

	var likeInstructions = {
		type: 'html-button-response',
		stimulus: "<p>In this part of survey, we ask you to answer the following question.</br></p>" +
		"<p>\"How much do you like the artwork shown? </br> </p>"+
		"0 = \'Not at all\', 1 = \'Like a little\', 2 = \'Like\', and 3 = \'Strongly Like\'.\"</br></p>" +
		"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Begin the task!"],
		response_ends_trial: true
	}
	timeline.push(likeInstructions)

	var testLike = {
		timeline: [fixation, showArtsLike, qLike],
		timeline_variables: test_stimuli,
		repetitions: 0,
		randomize_order: true
	}
	timeline.push(testLike);

	var surveyIntro = {
		type: "html-button-response",
		stimulus: "<p>You are almost done!</p>" +
					"<p>Please answer a few more questions.</p>" +
					"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Next \>"],
		response_ends_trial: true
	}
	timeline.push(surveyIntro);

	//survey parameters
	var yesNo = ["Yes", "No", "Prefer not to answer"];
	var ageRange = ["18 to 24 years old", "25 to 34 years old", "35 to 44 years old", "45 years old or above", "Prefer not to answer"];
	var genders = ["Female", "Male", "Prefer not to answer"];
	var degrees = ["Did not complete High School", "High School/GED", "Some College or Associate Degree",
								"Bachelor's Degree", "Master's Degree or higher", "Prefer not to answer"]
	var artMuseum = ["Less than once a month", "1 to 3 times per month", "Once a week or more", "Prefer not to answer"]
	var races = ["American Indian or Alaska Native", "Asian or Asian American", "Black or African American",
							"Native Hawaiian and Other Pacific Islander", "White or Caucasian", "Prefer not to answer"]
	var postSurveyQ = ["How old are you?", "What's your gender?", "Do you have a degree in fine arts or art history?",
									"Please select the highest degree you have earned?", "How often do you visit art museums?"]
	var arrayofchoices = [ageRange, genders, yesNo, degrees, artMuseum]

	var raceQ = {
		type: 'survey-multi-select',
		questions: [{prompt: "Which ethnicity or ethnicities do you identify yourself as?", options: races, required: true}]
	}
	timeline.push(raceQ);

	var i;
	for (i = 0; i < postSurveyQ.length; i++) {
    	var surveyQ = {
				type: 'survey-multi-choice',
				questions: [{prompt: postSurveyQ[i], options: arrayofchoices[i], required: true}]
			}
			timeline.push(surveyQ)
	}

	var suggestionsBox = {
		type: 'survey-text',
		questions: [{prompt: "Do you have any suggestion or question regarding our task? Please type them down in the box below.", rows: 5, columns: 100}],
	}
	timeline.push(suggestionsBox);

	var all_data = jsPsych.data.get();

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
