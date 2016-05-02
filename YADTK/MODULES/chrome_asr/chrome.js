// #############################################################################
// This file is part of the YADTK Toolkit (Yet Another Dialogue Toolkit)
// Copyright © Jérôme Lehuen 2010-2015 - Jerome.Lehuen@univ-lemans.fr
//
// This software is governed by the CeCILL license under French law and
// abiding by the rules of distribution of free software. You can use,
// modify and/or redistribute the software under the terms of the CeCILL
// license as circulated by CEA, CNRS and INRIA (http://www.cecill.info).
//
// As a counterpart to the access to the source code and rights to copy,
// modify and redistribute granted by the license, users are provided only
// with a limited warranty and the software's author, the holder of the
// economic rights, and the successive licensors have only limited
// liability.
//
// In this respect, the user's attention is drawn to the risks associated
// with loading, using, modifying and/or developing or reproducing the
// software by the user in light of its specific status of free software,
// that may mean that it is complicated to manipulate, and that also
// therefore means that it is reserved for developers and experienced
// professionals having in-depth computer knowledge. Users are therefore
// encouraged to load and test the software's suitability as regards their
// requirements in conditions enabling the security of their systems and/or
// data to be ensured and, more generally, to use and operate it in the
// same conditions as regards security.
//
// The fact that you are presently reading this means that you have had
// knowledge of the CeCILL license and that you accept its terms.
// #############################################################################

// This free software is registered at the Agence de Protection des Programmes.
// For further information or commercial purpose, please contact the author.

var pause = false;
var recognizing = false;
var recognition = new webkitSpeechRecognition();
var speech = new SpeechSynthesisUtterance();
var sock = new WebSocket('ws://127.0.0.1:9999');
var lang = getParam('lang');

recognition.continuous = true;
recognition.interimResults = true;
recognition.interimResults = lang;

recognition.onstart = function() {
	start_img.src = 'mic_anim.gif';
	showInfo('msg_on');
	recognizing = true;
}

recognition.onend = function() {
	start_img.src = 'mic_off.png';
	showInfo('msg_off');
	recognizing = false;
}

recognition.onerror = function(event) {
	start_img.src = 'mic_err.png';
	alert(event.error);
}

recognition.onresult = function(event) {
	var interim_transcript = '';
	var final_transcript = '';
	final_span.innerHTML = '';
	for (var i = event.resultIndex; i < event.results.length; ++i) {
		if (event.results[i].isFinal) {
			interim_span.innerHTML = '';
			final_transcript += event.results[i][0].transcript;
			final_span.innerHTML = final_transcript;
			if (!pause) sock.send(final_transcript);
			// document.getElementById('log').innerHTML += '<div class="user">' + final_transcript + '</div>';
		}
		else {
			interim_transcript += event.results[i][0].transcript;
			interim_span.innerHTML = interim_transcript;
		}
    }
}

sock.onmessage = function(event) {
    msg = event.data;
    // alert(msg);
    if (msg == 'START') pause = false; //recognition.start();
    if (msg == 'STOP') pause = true; //recognition.stop();
}

function onLoad() {
	showInfo('msg_off');
	info.style.visibility = 'visible';
    document.getElementById('lang').innerHTML = lang;
}

function startButton() {
	if (recognizing) recognition.stop();
	else recognition.start();
}

function showInfo(id) {
	for (var child = info.firstChild; child; child = child.nextSibling)
		if (child.style) child.style.display = child.id == id ? 'inline' : 'none';
}

function speech(text) {
	speech.text = text;
	speech.lang = lang.value;
	window.speechSynthesis.speak(speech);
}

function getParam(sname) {
    var params = location.search.substr(location.search.indexOf('?') + 1);
    var sval = '';
    params = params.split('&');
    for (var i = 0; i < params.length; i++) {
        temp = params[i].split('=');
        if ([temp[0]] == sname) sval = temp[1];
    }
    return sval;
}
