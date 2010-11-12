var WIDTH = 640;
var HEIGHT = 480;
var SAVE_INTERVAL = 500;
var POLL_INTERVAL = 500;
var container, canvas, context;
var chat, chatBody;
var x, y;
var saveTimer = false;

function init() {
	//return; // %%% disabled for layout phase
	container = document.getElementById('container');
	chat = document.getElementById('chat');
	chatBody = document.getElementById('chatbody');
	if (token) {
		injectCanvas();
		registerHandlers();
		chatBody.disabled = false;
		toolBlack();
	}
}

function injectCanvas() {
	canvas = document.createElement('canvas');
	canvas.width = WIDTH;
	canvas.height = HEIGHT;
	context = canvas.getContext('2d');
	var img = document.getElementById('layer' + layerid);
	context.drawImage(img, 0, 0);
	context.lineCap = 'round';
	context.lineJoin = 'round';
	container.insertBefore(canvas, img);
	container.removeChild(img);
	return canvas;
}

function registerHandlers() {
	// TODO: register tool button handlers
	container.addEventListener('mousedown', mouseDown, false);
	document.body.addEventListener('mouseup', mouseUp, false);
	alert(0);
	document.getElementById('chatform').addEventListener('submit', chat, false);
	alert(1);
}

function toolEraser() {
	context.globalCompositeOperation = 'destination-out';
	context.lineWidth = 16;
	container.style.cursor = 'url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAABFUlEQVQ4ja2UQU7DMBBFrZZdxC2KROAKtBIVPQxV4AxvPKvIS1TgDD5ChES5QTcpPUKyRT0AG1dy0zSgtCN5M/Y8/7E135iWAB6Ad2ADbMPahNy0rWYvVPUK+AJKIFPV1DmXOOcSVU1F5CnsLYFRKwSYABWQAYNjl3nvh+FMBUyakBFQi8jsT9khRGQG1HvKgA8RefwvJKqbA0Xc0qqrnQ7QAFhZa8cGeO2jpqFqYYBv4LovSFVTYG2ArXMu6QvK8/wS+Dkr6GytnfrYGfBirLXjU78fuNslCmDeU00RJ/qOSHUwvPHQeu+HHSougpL6YGgbypZAGSzjZmcj1tpb4DnYyOdRG2kAp8AbsI6MrQw/fN9W8wvvc96yMvzesAAAAABJRU5ErkJggg==") 9 9,crosshair';
}

function toolPen() {
	context.globalCompositeOperation = 'source-over';
	context.lineWidth = 2;
	container.style.cursor = 'url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAbElEQVQ4je3TOw7CQAxF0SwrkJLPlkh57Ab2CKIILCRVGjTMINGkyJVe5efryl3XACOurV6T9Yk26uCMN144VssRcVlSED3RY49HdRe3JSVRZu4yc8C9MP+6+3nxhAlTRByq5Y3/Wd/3/yqaAQYtUQ98N+QQAAAAAElFTkSuQmCC") 9 9,crosshair';
}

function toolBlack() {
	toolPen();
	context.strokeStyle = '#000000';
}

function toolRed() {
	toolPen();
	context.strokeStyle = '#ff0000';
}

function canvasCoords(e) {
	return {
		x: e.clientX + document.documentElement.scrollLeft + document.body.scrollLeft - container.offsetLeft,
		y: e.clientY + document.documentElement.scrollTop + document.body.scrollTop - container.offsetTop
	};
}

function mouseDown(e) {
	e.preventDefault();
	e = canvasCoords(e);
	x = e.x;
	y = e.y;
	container.addEventListener('mousemove', mouseMove, false);
}

function mouseUp(e) {
	e.preventDefault();
	container.removeEventListener('mousemove', mouseMove, false);
	save();
}

function mouseMove(e) {
	e.preventDefault();
	e = canvasCoords(e);
	context.beginPath();
	context.moveTo(x, y);
	x = e.x;
	y = e.y;
	context.lineTo(x, y);
	context.closePath();
	context.stroke();
	scheduleSave();
}

function scheduleSave() {
	if (saveTimer) return;
	saveTimer = setTimeout(save, SAVE_INTERVAL);
}

function save() {
	if (!saveTimer) return;
	var body =
		'token=' + token +
		'&data=' + escape(canvas.toDataUrl());
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/layers/' + layerid + '/update'); // %%% fill in actual endpoint
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
	saveTimer = false;
}

function schedulePoll() {
	setInterval(poll, POLL_INTERVAL);
}

function poll() {
	var xhr = new XMLHttpRequest();
	xhr.open('GET', '/boards/' + boardid + '/poll?revision=' + revision);
	xhr.onreadystatechange = function() {
		if (xhr.readyState < 4) return;
		var response = eval(xhr.responseText);
		if (response.revision <= revision) return;
		revision = response.revision;
		for (var layer in response.layers) {
			if (layer == layerid) continue;
			document.getElementById('layer' + layer).src = response.layers[layer];
		}
		for (var i in response.chats) {
			var line = response.chats[i];
			var p = document.createElement('p');
			var span = document.createElement('span');
			span.appendChild(document.createTextNode(line.author));
			span.appendChild(document.createTextNode(': '));
			p.appendChild(span);
			p.appendChild(document.createTextNode(line.body));
			chat.appendChild(p);
			chat.scrollTop = 0x7fffffff; // bottom?
		}
	};
	xhr.send(null);
}

function chat(e) {
	e.preventDefault();
	var body =
		(token ? 'token=' + token : '') +
		'&body=' + escape(chatBody.value) +
		'&boardid=' + boardid;
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/chats'); // %%% fill in actual endpoint
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
	chatBody.value = '';
}