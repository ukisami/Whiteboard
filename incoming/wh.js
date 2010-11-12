var WIDTH = 640;
var HEIGHT = 480;
var THUMB_WIDTH = 160;
var THUMB_HEIGHT = 120;
var SAVE_INTERVAL = 500;
var POLL_INTERVAL = 500;
var container, canvas, context, toolbar;
var chat, chatBody;
var x, y;
var saveTimer = false;

function init() {
	findElements();
	if (token) {
		injectCanvas();
		registerHandlers();
		toolBlack();
	}
	schedulePoll();
}

function findElements() {
	container = document.getElementById('container');
	chat = document.getElementById('chat');
	chatBody = document.getElementById('chatbody');
	toolbar = document.getElementById('toolbar');
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
}

function registerHandlers() {
	if (token) {
		document.getElementById('toolblack').addEventListener('click', toolBlack, false);
		document.getElementById('toolred').addEventListener('click', toolRed, false);
		document.getElementById('tooleraser').addEventListener('click', toolEraser, false);
		var tools = toolbar.getElementsByTagName('a');
		for (var i = 0; i < tools.length; i++) {
			tools[i].addEventListener('click', switchTool, false);
		}
		container.addEventListener('mousedown', mouseDown, false);
		document.body.addEventListener('mouseup', mouseUp, false);
	}
	var publishButton = document.getElementById('publish');
	if (publishButton) publishButton.addEventListener('click', publish, false);
	document.getElementById('chatform').addEventListener('submit', sendChat, false);
	chatBody.disabled = false;
}

function switchTool(e) {
	toolbar.getElementsByClassName('active')[0].className = '';
	e.currentTarget.className = 'active';
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
	document.body.addEventListener('mousemove', mouseMove, false);
}

function mouseUp(e) {
	e.preventDefault();
	document.body.removeEventListener('mousemove', mouseMove, false);
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
		'&data=' + escape(canvas.toDataURL());
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/layers/' + layerid + '/update');
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

function sendChat(e) {
	e.preventDefault();
	var body =
		(token ? 'token=' + token : '') +
		'&body=' + escape(chatBody.value) +
		'&boardid=' + boardid;
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/chats/create');
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
	chatBody.value = '';
}

function publish(e) {
	e.preventDefault();
	var body =
		'token=' + token +
		'&revision=' + revision +
		'&composite=' + escape(compose(WIDTH, HEIGHT)) +
		'&thumbnail=' + escape(compose(THUMB_WIDTH, THUMB_HEIGHT));
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/publish');
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
}

function compose(width, height) {
	var composite = document.createElement('canvas');
	composite.width = width;
	composite.height = height;
	var compositeContext = composite.getContext('2d');
	var layers = container.children;
	for (var i = 0; i < layers.length; i++) {
		compositeContext.drawImage(layers[i], 0, 0, width, height);
	}
	return composite.toDataURL();
}