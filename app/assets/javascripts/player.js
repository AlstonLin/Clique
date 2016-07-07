var queue = [];
var nowPlaying = null;
var repeat = false;

// JQuery setup
$(document).on('ready pjax:success', function() {
	setupPlayers();
});

var setupPlayers = function() {
	// Handles resizing
	$( window ).resize(function() {
		onResize($(window));
	});
	// Progress bar
	$("#progressBar").slider({
		range: "min",
		min: 0,
		max: 1000,
		slide: function(event, ui) {
			if(nowPlaying !== null && nowPlaying.id !== null){
				soundManager.setPosition(nowPlaying.id, ui.value / 1000 * nowPlaying.duration);
			} else{
				event.stopPropagation();
				return false;
			}
		}
	});
	// Volume
	$("#volumeClick").click(function(){
		$("#volumeBuffer").toggle();
	});
	 $("#volumeClick #volumeBuffer").click(function(e) {
	      e.stopPropagation();
	 });
	// Track control
	$("#repeat").click(function(){
		$(this).toggleClass("repeatOn");
		repeat = $(this).hasClass("repeatOn");
	});
	$("#playpause").click(function() {
		if($(this).hasClass("glyphicon-play")){//play button shown, song not playing
			if(null !== nowPlaying){
				nowPlaying.resume();
			} else if(undefined !== queue[0]){
				queue[0].play();
			} else{
				return;
			}
			$(this).removeClass("glyphicon-play").addClass("glyphicon-pause");
			nowPlaying.mySpan.removeClass("glyphicon-play").addClass("glyphicon-pause");
		}else{//pause button shown, song playing
			nowPlaying.pause();
			$(this).addClass("glyphicon-play").removeClass("glyphicon-pause");
			nowPlaying.mySpan.addClass("glyphicon-play").removeClass("glyphicon-pause");
		}
	});
	$("#next").click(function(){
		if(nowPlaying == null || nowPlaying.myArrIndex == null)
		return;
		if(nowPlaying.myArrIndex == (queue.length - 1)){
			queue[0].play();
		}else{
			queue[nowPlaying.myArrIndex + 1].play();
		}
	});
	$("#prev").click(function(){
		if(nowPlaying == null || nowPlaying.myArrIndex == null)
		return;
		if(nowPlaying.myArrIndex == 0){
			queue[queue.length - 1].play();
		}else{
			queue[nowPlaying.myArrIndex - 1].play();
		}
	});
	// Volume slider
	$("#volume").slider({
		range: "min",
		orientation: "vertical",
		value: 100,
		min: 0,
		max: 100,
		slide: function( event, ui ) {
			if(nowPlaying !== null && nowPlaying.id !== null){
				soundManager.setVolume(nowPlaying.id,ui.value );
			}
		}
	});
	// The play button on the actual page
	if (nowPlaying == null){
		$("#audioplayer").css('display', 'none'); //NOTE: Not a mistake but rather a workaround for css bug in a few browsers
	}
	setupSoundManager();
	onResize($(window));
};

// HELPERS
var setupSoundManager = function(){
	soundManager.setup({
		url: 'swfs/',
		flashVersion: 9,
		preferFlash: false, // prefer 100% HTML5 mode, where both supported
		debugMode: false,
		onready: function(){
			// Sets the on clicks
			$(".playa").each(function(i, v){
				$span = $(this).find('span');
				var sound = createSound($(this), $span)
				sound.mySpan = $span;
				sound.myArrIndex = i;
				queue[i] = sound;
				setOnPlayerClick($(this));
			});
			// Sets initial track
			var sound = queue[0];
			if (sound == null){
				$("#desc h4").text("No songs available");
				$("#desc p").text("Follow people now!");
			} else{
				$("#desc img").attr("src", sound.myImage);
				$("#desc h4").text(sound.myArtist);
				$("#desc p").text(sound.mySongName);
			}
			// Already playing
			if (nowPlaying !== null) {
				$span = $('#' + nowPlaying.mySpan.attr('id'));
				$("#playpause").removeClass("glyphicon-play").addClass("glyphicon-pause");
				$span.removeClass("glyphicon-play").addClass("glyphicon-pause");
			}
		},
		ontimeout: function() {
			console.log('SM2 init failed!');
		},
		defaultOptions: {
			volume: 100
		}
	});
}

var setOnPlayerClick = function($playa){
	$playa.click(function(){
		$span = $(this).find('span');
		if ($span.hasClass('glyphicon-play')){
			if ($("#audioplayer").css('display') == 'none'){
				$("#audioplayer").css('display', 'inline-flex');
				onResize($(window));
			}
			for (var i = 0; i < queue.length; i++){
				if (queue[i] !== undefined && queue[i].url == $(this).attr('song')){
					if (nowPlaying !== null && nowPlaying.id !== null && nowPlaying.id == queue[i].id) {
						nowPlaying.mySpan = $span;
						nowPlaying.resume();
					} else{
						if (nowPlaying !== null){
							nowPlaying.mySpan.addClass("glyphicon-play").removeClass("glyphicon-pause");
						}
						queue[i].mySpan = $span;
						queue[i].play();
					}
					$("#playpause").removeClass("glyphicon-play").addClass("glyphicon-pause");
					$span.removeClass("glyphicon-play").addClass("glyphicon-pause");
					return;
				}
			}
		} else{
			if (nowPlaying !== null){
				nowPlaying.pause();
			}
			$span.addClass("glyphicon-play").removeClass("glyphicon-pause");
			$("#playpause").addClass("glyphicon-play").removeClass("glyphicon-pause");
		}
	});
}

var onResize = function(doc){
	var progBGWidth = $("#status").width()-2*$('curTime').width()-75;
	if(doc.width() <= 720){
		progBGWidth += 60;
	}
	$("#progressBar").width(progBGWidth);
}
// Plays the track
var createSound = function($playa, $span) {
	var song = $playa.attr("song");
	var image = $playa.attr("image");
	var artist = $playa.attr("artist");
	var name = $playa.attr("name")
	var trackLink = $playa.attr("trackLink");
	var ownerLink = $playa.attr("ownerLink")
	var trackId = $playa.attr("trackId")
	if (!soundManager.canPlayURL(song)){
		console.log("ERROR: " + song + " because: " + soundManager.canPlayURL(song));
		return null;
	}
	$span.attr('id', 'soundSpan' + trackId)
	var sound = soundManager.createSound({
		id: 'sound' + trackId,
		url: song,
		volume: 100,
		autoload: true,
		autoplay: false,
		stream: true,
		onload: function(){
			//update duration of song - cannot be put in onplay
			$("#totalTime").text(getTime(this.duration, true));
		},
		onplay: function(){
			if(nowPlaying != null && nowPlaying.id != this.id)
				soundManager.stop(nowPlaying.id);

			//for global access
			nowPlaying = this;

			//update description
			$("#desc img").attr("src", image);
			$("#desc h4").text(artist);
			$("#desc p").text(name);
			$("#desc #ptrackLink").attr('href', trackLink);
			$("#desc #pprofileLink").attr('href', ownerLink);
			$("#progressBar").slider("value", 0);

			//togglePause
			$("#playpause").removeClass("glyphicon-play").addClass("glyphicon-pause");
			nowPlaying.mySpan.removeClass("glyphicon-play").addClass("glyphicon-pause");
		},
		whileplaying: function(){
			//update slider
			$("#progressBar").slider("value", Math.max(1000* this.position/this.durationEstimate));
			//update current
			$("#curTime").text(getTime(this.position, true));
		},
		onfinish: function(){
			if (repeat){
				queue[this.myArrIndex].play();
			}else if (queue[this.myArrIndex + 1] != undefined){
				queue[this.myArrIndex + 1].play();
			}else if (queue[0] != undefined){
				queue[0].play();
			}
		}
	});
	sound.myArtist = artist;
	sound.myImage = image;
	sound.mySongName = name;
	return sound;
}

// Gets the time of the track
function getTime(msec, useString) {
	// convert milliseconds to hh:mm:ss, return as object literal or string
	var nSec = Math.floor(msec/1000),
	hh = Math.floor(nSec/3600),
	min = Math.floor(nSec/60) - Math.floor(hh * 60),
	sec = Math.floor(nSec -(hh*3600) -(min*60));
	// if (min === 0 && sec === 0) return null; // return 0:00 as null
	return (useString ? ((hh ? hh + ':' : '') + (hh && min < 10 ? '0' + min : min) + ':' + ( sec < 10 ? '0' + sec : sec ) ) : { 'min': min, 'sec': sec });
}
