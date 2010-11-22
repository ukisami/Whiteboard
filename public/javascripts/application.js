var WIDTH = 640;
var HEIGHT = 480;
var THUMB_WIDTH = 160;
var THUMB_HEIGHT = 120;
var SAVE_INTERVAL = 500;
var POLL_INTERVAL = 500;
var container, canvas, context, toolbar;
var chat, chatBody;
var x, y;
var activeWidth = null;
var activeColor = null;
var saveTimer = false;

function init() {
	findElements();
	if (token) {
		injectCanvas();
		registerHandlers();
		clickTool(document.getElementById('defaultwidth'));
		clickTool(document.getElementById('defaultcolor'));
	}
	schedulePoll();
}

function clickTool(t) {
	var e = document.createEvent('MouseEvents');
	e.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
	t.dispatchEvent(e);
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
		var widths = toolbar.getElementsByClassName('width');
		for (var i = 0; i < widths.length; i++) {
			widths[i].addEventListener('click', toolWidth, false);
		}
		var colors = toolbar.getElementsByClassName('color');
		for (var i = 0; i < colors.length; i++) {
			colors[i].addEventListener('click', toolColor, false);
		}
		document.getElementById('eraser').addEventListener('click', toolEraser, false);
		container.addEventListener('mousedown', mouseDown, false);
		document.body.addEventListener('mouseup', mouseUp, false);
	}
	var publishButton = document.getElementById('publish');
	if (publishButton) publishButton.addEventListener('click', publish, false);
	document.getElementById('chatform').addEventListener('submit', sendChat, false);
	chatBody.disabled = false;
}

function toolWidth(e) {
	var active = e.currentTarget;
	var w = parseInt(active.firstChild.style.width, 10);
	context.lineWidth = w;
	var o = w > 4 ? w / 2 + 1 : 9;
	container.style.cursor = 'url("brush' + w + '.png") ' + o + ' ' + o + ',crosshair';
	activeWidth && (activeWidth.className = 'width');
	(activeWidth = active).className = 'active width';
}

function toolColor(e) {
	var active = e.currentTarget;
	context.globalCompositeOperation = 'source-over';
	context.strokeStyle = active.style.backgroundColor;
	activeColor && (activeColor.className = 'color');
	(activeColor = active).className = 'active color';
}

function toolEraser(e) {
	context.globalCompositeOperation = 'destination-out';
	activeColor && (activeColor.className = '');
	(activeColor = e.currentTarget).className = 'active';
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
		'&data=' + encodeURIComponent(canvas.toDataURL());
	var xhr = new XMLHttpRequest();
	xhr.open('PUT', '/boards/' + boardid + '/layers/' + layerid);
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
		var response = eval('(' + xhr.responseText + ')');
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
		'&body=' + encodeURIComponent(chatBody.value);
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/chats');
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
		'&composite=' + encodeURIComponent(compose(WIDTH, HEIGHT)) +
		'&thumbnail=' + encodeURIComponent(compose(THUMB_WIDTH, THUMB_HEIGHT));
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
