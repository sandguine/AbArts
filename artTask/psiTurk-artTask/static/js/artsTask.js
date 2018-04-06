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
	"instructions/instruct-1.html",
	"instructions/instruct-ready.html",
	"stage.html",
	"postquestionnaire.html"
];

psiTurk.preloadPages(pages);

var instructionPages = [ // add as a list as many pages as you like
	"instructions/instruct-1.html",
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

/********************
* STROOP TEST       *
********************/
/*
var StroopExperiment = function() {

	var wordon, // time word is presented
	    listening = false;

	// Stimuli for a basic Stroop experiment
	var stims = [
			["SHIP", "red", "unrelated"],
			["MONKEY", "green", "unrelated"],
			["ZAMBONI", "blue", "unrelated"],
			["RED", "red", "congruent"],
			["GREEN", "green", "congruent"],
			["BLUE", "blue", "congruent"],
			["GREEN", "red", "incongruent"],
			["BLUE", "green", "incongruent"],
			["RED", "blue", "incongruent"]
		];

	stims = _.shuffle(stims);

	var next = function() {
		if (stims.length===0) {
			finish();
		}
		else {
			stim = stims.shift();
			show_word( stim[0], stim[1] );
			wordon = new Date().getTime();
			listening = true;
			d3.select("#query").html('<p id="prompt">Type "R" for Red, "B" for blue, "G" for green.</p>');
		}
	};

	var response_handler = function(e) {
		if (!listening) return;

		var keyCode = e.keyCode,
			response;

		switch (keyCode) {
			case 82:
				// "R"
				response="red";
				break;
			case 71:
				// "G"
				response="green";
				break;
			case 66:
				// "B"
				response="blue";
				break;
			default:
				response = "";
				break;
		}
		if (response.length>0) {
			listening = false;
			var hit = response == stim[1];
			var rt = new Date().getTime() - wordon;

			psiTurk.recordTrialData({'phase':"TEST",
                                     'word':stim[0],
                                     'color':stim[1],
                                     'relation':stim[2],
                                     'response':response,
                                     'hit':hit,
                                     'rt':rt}
                                   );
			remove_word();
			next();
		}
	};

	var finish = function() {
	    $("body").unbind("keydown", response_handler); // Unbind keys
	    currentview = new Questionnaire();
	};

	var show_word = function(text, color) {
		d3.select("#stim")
			.append("div")
			.attr("id","word")
			.style("color",color)
			.style("text-align","center")
			.style("font-size","150px")
			.style("font-weight","400")
			.style("margin","20px")
			.text(text);
	};

	var remove_word = function() {
		d3.select("#word").remove();
	};


	// Load the stage.html snippet into the body of the page
	psiTurk.showPage('stage.html');

	// Register the response handler that is defined above to handle any
	// key down events.
	$("body").focus().keydown(response_handler);

	// Start the test
	next();
};
*/

var ArtExperiment = function() {
		/* create timeline */
		var timeline = [];

		timeline.push({
			type: 'fullscreen',
			fullscreen_mode: true
		});

		/* define welcome message trial */
		var welcome = {
			type: "html-keyboard-response",
			stimulus: "<p>Welcome to our easy and simple survey!</p>" +
								"<p>Press any key to begin.</p>",
		};
		timeline.push(welcome);
		/* define instructions trial */
		// extend instructions and show example of task

		var mainInstructions = {
			type: "html-keyboard-response",
			stimulus: "<p>In this survey, you will see various paintings created by different artists.</p>" +
					"<p>We will ask you a few simple questions about the artwork.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		};
		timeline.push(mainInstructions);

		var mainInstructions1 = {
			type: "html-keyboard-response",
			stimulus: "<p>You will recieve $3 when you complete the task regardless of your responses. </p>" +
								"<p>This is not a test of your knowledge, so please answer as honestly as you can. </p>" +
								"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		};
		timeline.push(mainInstructions1);

		/* declare necessary variables */
		var questions = [
			"<p>Do you know the name of the artist who painted this picture?</p>",
			"<p>How much do you like the artwork shown? </br> 0 = \'Not at all\', and 3 = \'Strongly\'\" </br> </p>"
		]

		var familiar_options = ["I don't know.", "I know."];
		var like_options = ["0", "1", "2", "3"];
		var arts = jsPsych.timelineVariable('stimulus');
		var artShowTime = 2//000
		var responsePeriodArtist = 3//000
		var responsePeriodLike = 6//000
		var fixationTime = 5//00

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
			data: {test_part: 'fixation'}
		}

		// write a pause between trial function
		var pausePeriod = {
			type: "html-keyboard-response",
			stimulus: "<p>The new set of questions is about to start.</p>" +
					"<p>Press any key to begin.</p>",
			post_trial_gap: 0
		}

		// example shows here
		var exampleP1 ={
			type: "html-keyboard-response",
			stimulus: "<p>Ok, let's do an example together.</p>" +
					"<p>Press any key to begin.</p>",
			post_trial_gap: 0
		}

		var exampleP2 ={
			type: "html-keyboard-response",
			stimulus: "<p>You will see a \"+\" at the beginning of each round.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var exampleP3 ={
			type: "html-keyboard-response",
			stimulus: "<p>A painting will appear at the center of the screen.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var exampleP4 ={
			type: "html-keyboard-response",
			stimulus: "<p>You have 2 seconds to look at the painting.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var showArtsEx1 ={
			type: 'image-button-response',
			stimulus: '/static/js/img/0.jpg',
			trial_duration: artShowTime,
			response_ends_trial: false,
			prompt: questions[0]
		}

		var explanationQFam ={
			type: "html-keyboard-response",
			stimulus: "<p>You can click on one of the two options that will appear at the bottom of the screen.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var explFamChoices1 = {
			type: 'html-keyboard-response',
			stimulus: "<p>If you think you DO NOT know the name of the artist, please click \"I don't know\".</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var explFamChoices2 = {
			type: 'html-keyboard-response',
			stimulus: "<p>If you think you know the name of the artist, please click \"I know\".</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var responseTime = {
			type: 'html-keyboard-response',
			stimulus: "<p>You have 3 seconds to respond.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var responseTimeLike = {
			type: 'html-keyboard-response',
			stimulus: "<p>You have 6 seconds to respond.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var qFamEx = {
			type: 'image-button-response',
			stimulus: '/static/js/img/0.jpg',
			prompt: questions[0],
			trial_duration: responsePeriodArtist,
			response_ends_trial: true,
			choices: familiar_options //[, familiar_options, human_options]
		}

		var explanationQLike = {
			type: "html-keyboard-response",
			stimulus: "<p>You can click on one of the four options that will appear at the bottom of the screen.</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var explanationQLike0 = {
			type: "html-keyboard-response",
			stimulus: "<p>If you DO NOT LIKE the painting AT ALL, please click on the option \"0\".</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var explanationQLike1 = {
			type: "html-keyboard-response",
			stimulus: "<p>If you LIKE the painting A LITTLE, please click on the option \"1\".</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var explanationQLike2 = {
			type: "html-keyboard-response",
			stimulus: "<p>If you LIKE the painting, please click on the option \"2\".</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var explanationQLike3 = {
			type: "html-keyboard-response",
			stimulus: "<p>If you STRONGLY LIKE the painting, please click on the option \"3\".</p>" +
					"<p>Press any key to continue.</p>",
			post_trial_gap: 0
		}

		var qLikeEx = {
			type: 'image-button-response',
			stimulus: '/static/js/img/0.jpg',
			prompt: questions[1],
			trial_duration: responsePeriodLike,
			response_ends_trial: true,
			choices: like_options //[, familiar_options, human_options]
		}

		var exampleP5 ={
			type: "html-keyboard-response",
			stimulus: "<p>Ok, very simple, right?</p>" +
					"<p>Press any key to begin the real survey.</p>",
			post_trial_gap: 0
		}

		var showExample = {
			timeline: [exampleP1, exampleP2, fixation, exampleP3, exampleP4, showArtsEx1,
				explanationQFam, explFamChoices1, explFamChoices2, responseTime, qFamEx, exampleP5],
			repetitions: 0,
			randomize_order: true
		}
		timeline.push(showExample)

		var familiarInstructions = {
			type: 'html-keyboard-response',
			stimulus: "<p>In this part of survey, we ask you to answer the following question. </br> </p>" +
			"<p>\"Do you know the name of the artist who painted this picture?\" </br> </p>" +
			"<p>Press any key to begin.</p>"
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

		var likeExample = {
			timeline: [explanationQLike, explanationQLike0, explanationQLike1,
				explanationQLike2, explanationQLike3, responseTimeLike, qLikeEx, exampleP5],
			repetitions: 0,
			randomize_order: true
		}
		timeline.push(likeExample);

		var likeInstructions = {
			type: 'html-keyboard-response',
			stimulus: "<p>In this part of survey, we ask you to answer the following question. </br> </p>" +
			"<p>\"How much do you like the artwork shown? </br> </p>"+
			"0 = \'Not at all\', and 3 = \'Strongly\'\" </br> </p>" +
			"<p>Press any key to begin.</p>"
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
			type: "html-keyboard-response",
			stimulus: "<p>You are almost done!</p>" +
						"<p>Please answer a few more questions.</p>" +
						"<p>Press any key to begin.</p>",
			post_trial_gap: 0
		}
		timeline.push(surveyIntro);

		var yesNo = ["Yes", "No", "Prefer not to answer"];
		var ageRange = ["18 to 24 years old", "25 to 34 years old", "35 to 44 years old", "45 years old or above", "Prefer not to answer"];
		var genders = ["Female", "Male", "Prefer not to answer"];
		var degrees = ["Did not complete High School", "High School/GED", "Some College or Associate Degree",
									"Bachelor's Degree", "Master's Degree or higher", "Prefer not to answer"]
		var artMuseum = ["Less than once a month", "1 to 3 times per month", "Once a week or more", "Prefer not to answer"]
		var races = ["American Indian or Alaska Native", "Asian or Asian American", "Black or African American",
								"Native Hawaiian and Other Pacific Islander", "White or Caucasian", "Prefer not to answer"]

		var ageQ = {
			type: 'survey-multi-choice',
			questions: [{prompt: "How old are you?", options: ageRange, required: true}]
		}

		var genderQ = {
			type: 'survey-multi-choice',
			questions: [{prompt: "What's your gender?", options: genders, required: true}]
		}

		var artHistQ = {
			type: 'survey-multi-choice',
			questions: [{prompt: "Do you have a degree in fine arts or art history?", options: yesNo, required: true}]
		}

		var degreeQ = {
			type: 'survey-multi-choice',
			questions: [{prompt: "Please select the highest degree you have earned?", options: degrees, required: true}]
		}

		var artMuseumQ = {
			type: 'survey-multi-choice',
			questions: [{prompt: "How often do you visit art museums?", options: artMuseum, required: true}]
		}

		var raceQ = {
			type: 'survey-multi-select',
			questions: [{prompt: "Which ethnicity or ethnicities do you identify yourself as?", options: races, required: true}]
		}

		var testSurvey = {
			timeline: [ageQ, genderQ, raceQ, degreeQ, artHistQ, artMuseumQ],
			repetitions: 0,
			randomize_order: true
		}
		timeline.push(testSurvey);

		var suggestionsBox = {
			type: 'survey-text',
			questions: [{prompt: "Do you have any suggestion or question regarding our task? Please type them down in the box below.", rows: 5, columns: 100}],
		};
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
								psiTurk.recordTrialData(all_data);
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
