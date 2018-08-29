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

	//survey parameters

	//"Color,” "Composition,” "Meaning/Content,” and "Texture/Brushstrokes.”
	//Other factors mentioned by people include"Shape,” “Perspective,”
	//“Feeling of Motion,” “Balance,”“Style,” “Mood,” “Originality,” “Unity,” etc.
	var yesNo = ["Yes", "No"];
	var ageRange = ["18 to 24 years old", "25 to 34 years old", "35 to 44 years old", "45 years old or above"];
	var genders = ["Female", "Male", "Non-binary"];
	var degrees = ["Did not complete High School", "High School/GED", "Some College or Associate Degree",
								"Bachelor's Degree", "Master's Degree or higher"];
	var artMuseum = ["Less than once a month", "1 to 3 times per month", "Once a week or more"];
	var races = ["American Indian or Alaska Native", "Asian or Asian American", "Black or African American",
							"Native Hawaiian and Other Pacific Islander", "White or Caucasian"];
	var ses = ["Less than $5,000", "$5,000 through $11,999", "$12,000 through $15,999",
						"$16,000 through $24,999", "$25,000 through $34,999", "$35,000 through $49,999",
						"$50,000 through $74,999", "$75,000 through $99,999", "$100,000 and greater", "Don't know"];
	var features = ["Color", "Complexity", "Composition", "Familiarity", "Meaning/Content", "Texture/Brushstrokes", "Quality of Techniques Used",
								"Shape", "Perspective", "Feeling of Motion", "Balance", "Style", "Historical Context", "Symmetry", "Mood", "Originality", "Unity"];
			features = jsPsych.randomization.shuffle(features);
			features = features.concat("Others");
	var artSurveyQ = ["Do you have a degree in fine arts or art history?", "How often do you visit arts museum?"];
	var postSurveyQ = ["How old are you?", "Which gender do you most closely identify yourself as?", "Please select the highest degree you have earned?",
	"Which of these categories best describes your total combined family income for the past 12 months?"];
	var arrayofartchoices = [yesNo, artMuseum];
	var arrayofchoices = [ageRange, genders, degrees, ses];

	var surveyIntro = {
		type: "html-button-response",
		stimulus: "<p>You are almost done!</p>" +
					"<p>Please answer a few more questions.</p>" +
					"<p>For demographic questions, if you prefer not to answer please leave it blank and press continue.</p>"+
					"<p>Click on the button below to begin.</p>",
		post_trial_gap: 0,
		choices: ["Next \>"],
		response_ends_trial: true
	};
	timeline.push(surveyIntro);

	var participantID = {
		type: 'survey-text',
		questions: [{prompt: "Please enter your participant ID:", rows: 1, columns: 10}],
		required: true
	};
	timeline.push(participantID);

	var i;
	for (i = 0; i < artSurveyQ.length; i++) {
    	var artSur= {
				type: 'survey-multi-choice',
				questions: [{prompt: artSurveyQ[i], options: arrayofartchoices[i], required: true}]
			};
			timeline.push(artSur);
	}

	var featuresQ = {
		type: 'survey-multi-select',
		questions: [{prompt: "What are the important factors you are concerned with when judging a piece of artwork?", options: features, required: true}]
	};
	timeline.push(featuresQ);

	var otherFeatures = {
		type: 'survey-text',
		questions: [{prompt: "Are there other factors you are concerned with when judging a piece of artwork? Please type them down in the box below.", rows: 5, columns: 100}]
	};
	timeline.push(otherFeatures);

	var colorOpinions = {
		type: 'image-button-response'
		questions:
	};
	timeline.push(colorOpinions);

	var raceQ = {
		type: 'survey-multi-select',
		questions: [{prompt: "Which ethnicity or ethnicities do you closely identify yourself as?", options: races, required: false}]
	};
	timeline.push(raceQ);

	var i;
	for (i = 0; i < postSurveyQ.length; i++) {
    	var surveyQ = {
				type: 'survey-multi-choice',
				questions: [{prompt: postSurveyQ[i], options: arrayofchoices[i], required: false}]
			};
			timeline.push(surveyQ);
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
