var trackIdQueue = [];
var trackMap = {};
var spanTrackIdMap = {};
var spanIdCounter = {}; // When there are > 1 of the same tracks (reposts)
var trackIdCounter = {}; // When there are > 1 of the same tracks (reposts)
var currentTrackId = null;
var repeat = false;

// JQuery setup
$(document).on('ready pjax:success', function() {
	$( window ).resize(function() {
		onResize($(window));
	});
	setupSoundManager();
	onResize($(window));
});
$(document).ready(function(){
	setupPlayer();
});


var setupPlayer = function() {
	// Progress bar
	$("#progressBar").slider({
		range: "min",
		min: 0,
		max: 1000,
		slide: function(event, ui) {
			if (currentTrackId !== null){
				soundManager.setPosition(currentTrackId, ui.value / 1000 * trackMap[currentTrackId].duration);
			} else{
				event.stopPropagation();
				return false;
			}
		}
	});
	$(".trackProgressBar").slider({
		range: "min",
		min: 0,
		max: 1000
	});
	// Volume
	$("#volumeClick").click(function(){
		$("#volumeBuffer").toggle();
	});
	 $("#volumeClick #volumeBuffer").click(function(e) {
				e.stopPropagation();
	 });
	// PLAYER BAR TRACK CONTROL
	$("#repeat").click(function(){
		$(this).toggleClass("repeatOn");
		repeat = $(this).hasClass("repeatOn");
	});
	$("#playpause").click(function() {
		if($(this).hasClass("glyphicon-play")){ // No track being played
			var track = currentTrackId ? trackMap[currentTrackId] : null;
			if (track){
				resumeCurrentTrack();
			} else if (trackIdQueue[0] !== undefined){
				playNewTrack(trackIdQueue[0]);
			}
		} else { // Track being played
			pauseCurrentTrack();
		}
	});
	$("#next").click(function(){
		playNextTrack();
	});
	$("#prev").click(function(){
		playPrevTrack();
	});
	// Volume slider
	$("#volume").slider({
		range: "min",
		orientation: "vertical",
		value: 100,
		min: 0,
		max: 100,
		slide: function(event, ui) {
			if (currentTrackId){
				soundManager.setVolume(currentTrackId, ui.value);
			}
		}
	});
	if (!currentTrackId){
		$("#audioplayer").css('display', 'none'); //NOTE: Workaround for css bug in some browsers
	}
};

// HELPERS
var setupSoundManager = function(){
	spanIdCounter = {};
	trackIdCounter = {};
	soundManager.setup({
		url: 'swfs/',
		flashVersion: 9,
		preferFlash: false, // prefer 100% HTML5 mode, where both supported
		debugMode: false,
		onready: function(){
			// Sets the on clicks
			$(".playa").each(function(i, v){
				var $span = $(this).find('span');
				var sound = createSound($(this), $span, i);
				sound.spanId = $span.attr('id');
				setOnPlayerClick($(this));
			});
			if (currentTrackId) {
				$span = $('#' + currentTrackId.spanId);
				$("#playpause").removeClass("glyphicon-play").addClass("glyphicon-pause");
				$span.removeClass("glyphicon-play").addClass("glyphicon-pause");
			} else{
				// Sets initial track
				var initTrack = trackIdQueue[0] ? trackMap[trackIdQueue[0]] : null;
				if (initTrack == null){
					$("#desc h4").text("No songs available");
					$("#desc p").text("Follow people now!");
				} else{
					$("#desc img").attr("src", initTrack.image);
					$("#desc h4").text(initTrack.artist);
					$("#desc p").text(initTrack.trackName);
				}
			}
		},
		ontimeout: function() {
			console.log('Sound Manager init failed!');
		},
		defaultOptions: {
			volume: 100
		}
	});
};

var setOnPlayerClick = function($playa){
	$playa.click(function(){
		$span = $(this).find('span');
		if ($span.hasClass('glyphicon-play')){  // Plays the track
			if ($("#audioplayer").css('display') == 'none'){
				$("#audioplayer").css('display', 'inline-flex');
				onResize($(window));
			}
			var newTrackId = spanTrackIdMap[$span.attr('id')];
			if (newTrackId == currentTrackId){
				resumeCurrentTrack();
			} else {
				playNewTrack(newTrackId);
			}
		} else{ // Pauses the track
			pauseCurrentTrack();
		}
	});
};

var playNewTrack = function(trackId){
	trackMap[trackId].play();
};

var resumeCurrentTrack = function(){
	var track = trackMap[currentTrackId];
	var $span = $('#' + track.spanId);
	track.resume();
	$span.removeClass("glyphicon-play").addClass("glyphicon-pause");
	$("#playpause").removeClass("glyphicon-play").addClass("glyphicon-pause");
};

var pauseCurrentTrack = function(){
	var track = trackMap[currentTrackId];
	var $span = $('#' + track.spanId);
	track.pause();
	$span.addClass("glyphicon-play").removeClass("glyphicon-pause");
	$("#playpause").addClass("glyphicon-play").removeClass("glyphicon-pause");
};

var playNextTrack = function(){
	if (!currentTrackId){
		return;
	}
	var currIndex = trackIdQueue.indexOf(currentTrackId);
	if (currIndex >= trackIdQueue.length - 1){ // Loops back to start
		playNewTrack(trackIdQueue[0]);
	} else{ // Next in queue
		playNewTrack(trackIdQueue[currIndex + 1]);
	}
};

var playPrevTrack = function(){
	if (!currentTrackId){
		return;
	}
	var currIndex = trackIdQueue.indexOf(currentTrackId);
	if (currIndex <= 0){ // Loops back to start
		playNewTrack(trackIdQueue[trackIdQueue.length - 1]);
	} else{ // Next in queue
		playNewTrack(trackIdQueue[currIndex - 1]);
	}
};

var onResize = function(doc){
	var progBGWidth = $("#status").width()-2*$('curTime').width()-75;
	if(doc.width() <= 720){
		progBGWidth += 60;
	}
	$("#progressBar").width(progBGWidth);
};

// Creates the track
var createSound = function($playa, $span, i) {
	var trackUrl = $playa.attr("song");
	var image = $playa.attr("image");
	var artist = $playa.attr("artist");
	var name = $playa.attr("name")
	var trackLink = $playa.attr("trackLink");
	var ownerLink = $playa.attr("ownerLink");
	var trackId = createTrackId($playa);
	var actualId = $playa.attr("trackId");
	if (!soundManager.canPlayURL(trackUrl)){
		console.log("ERROR: " + trackUrl + " because: " + soundManager.canPlayURL(song));
		return null;
	}
	$span.attr('id', createSpanId($playa))
	var sound = soundManager.createSound({
		id: trackId,
		url: trackUrl,
		volume: 100,
		autoload: true,
		autoplay: false,
		stream: true,
		onload: function(){
			//update duration of song - cannot be put in onplay
			$("#totalTime").text(getTime(this.duration, true));
		},
		onplay: function(){
			if (currentTrackId) {
				var oldTrack = trackMap[currentTrackId];
				$('#' + oldTrack.spanId).removeClass("glyphicon-pause").addClass("glyphicon-play");
				oldTrack.stop();
			}
			currentTrackId = this.id;
			// Description
			$("#desc img").attr("src", image);
			$("#desc h4").text(artist);
			$("#desc p").text(name);
			$("#desc #ptrackLink").attr('href', trackLink);
			$("#desc #pprofileLink").attr('href', ownerLink);
			$("#progressBar").slider("value", 0);
			$("#progressBar-" + actualId).slider("value", 0);
			// Shows play button
			$("#playpause").removeClass("glyphicon-play").addClass("glyphicon-pause");
			$('#' + this.spanId).removeClass("glyphicon-play").addClass("glyphicon-pause");
		},
		whileplaying: function(){
			//update slider
			var val = Math.max(1000* this.position / this.durationEstimate);
			$("#progressBar").slider("value", val);
			$("#progressBar-" + actualId).slider("value", val);
			//update current
			$("#curTime").text(getTime(this.position, true));
		},
		onfinish: function(){
			playNextTrack();
		}
	});
	sound.artist = artist;
	sound.image = image;
	sound.trackName = name;
	trackIdQueue[i] = trackId;
	trackMap[trackId] = sound;
	spanTrackIdMap[$span.attr('id')] = trackId;
	return sound;
};

// Gets the time of the track
var getTime = function(msec, useString) {
	// convert milliseconds to hh:mm:ss, return as object literal or string
	var nSec = Math.floor(msec/1000),
	hh = Math.floor(nSec/3600),
	min = Math.floor(nSec/60) - Math.floor(hh * 60),
	sec = Math.floor(nSec -(hh*3600) -(min*60));
	// if (min === 0 && sec === 0) return null; // return 0:00 as null
	return (useString ? ((hh ? hh + ':' : '') + (hh && min < 10 ? '0' + min : min) + ':' + ( sec < 10 ? '0' + sec : sec ) ) : { 'min': min, 'sec': sec });
};

var createSpanId = function($playa){
	var trackId = $playa.attr("trackId");
	if (spanIdCounter[trackId] == undefined){
		spanIdCounter[trackId] = 0;
	}
	var counter = spanIdCounter[trackId]++;
	return 'soundSpan' + trackId + "-" + counter;
};

var createTrackId = function($playa){
	var trackId = $playa.attr("trackId");
	if (trackIdCounter[trackId] == undefined){
		trackIdCounter[trackId] = 0;
	}
	var counter = trackIdCounter[trackId]++;
	return 'track' + trackId + "-" + counter;
}
