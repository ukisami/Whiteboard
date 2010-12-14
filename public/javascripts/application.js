var WIDTH = 640;
var HEIGHT = 480;
var THUMB_WIDTH = 160;
var THUMB_HEIGHT = 120;
var SAVE_INTERVAL = 1000;
var POLL_INTERVAL = 2000;
var UNDO_STEPS = 10;
var container, canvas, context, toolbar, publishButton, layerList, editLayers;
var chat, chatBody;
var x, y;
var activeWidth = null;
var activeColor = null;
var saveTimer = false;
var dragging = null;
var undoBuffer = [];
var undoIndex = -1;
var changed = false;

function init() {
	findElements();
	registerChat();
	registerShowURLs();
	if (layerid && token) {
		injectCanvas();
		registerTools();
		clickTool(document.getElementById('defaultwidth'));
		clickTool(document.getElementById('defaultcolor'));
	}
	if (layerList.className == 'owned') registerControls();
	schedulePoll();
}

function findElements() {
	container = document.getElementById('container');
	chat = document.getElementById('chat');
	chatBody = document.getElementById('chatbody');
	toolbar = document.getElementById('toolbar');
	publishButton = document.getElementById('publish');
	rearrangeLayers = document.getElementById('rearrangeLayers');
	layerList = document.getElementById('layerList');
}

function registerChat() {
	document.getElementById('chatform').addEventListener('submit', sendChat, false);
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
	canvas.id = img.id;
	canvas.style.zIndex = img.style.zIndex;
	canvas.style.opacity = img.style.opacity;
	canvas.style.visibility = img.style.visibility;
	container.insertBefore(canvas, img);
	container.removeChild(img);
	snapshot();
}

function registerTools() {
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
	document.addEventListener('keydown', keyDown, false);
}

function registerControls() {
	publishButton.addEventListener('click', publish, false);
	rearrangeLayers.addEventListener('click', unlockOrder, false);

	var visibilities = layerList.getElementsByClassName('visible');
	for (var i = 0; i < visibilities.length; i++) {
		visibilities[i].addEventListener('change', saveVisible, false);
	}
	var opacities = layerList.getElementsByClassName('opacity');
	for (var i = 0; i < opacities.length; i++) {
		opacities[i].addEventListener('change', saveOpacity, false);
	}
}

function clickTool(t) {
	var e = document.createEvent('MouseEvents');
	e.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
	t.dispatchEvent(e);
}

function toolWidth(e) {
	var active = e.currentTarget;
	var w = parseInt(active.firstChild.style.width, 10);
	context.lineWidth = w;
	var o = w > 4 ? w / 2 + 1 : 9;
	container.style.cursor = 'url("/images/brush' + w + '.png") ' + o + ' ' + o + ',crosshair';
	activeWidth && (activeWidth.className = 'width');
	(activeWidth = active).className = 'active width';
	e.preventDefault();
}

function toolColor(e) {
	var active = e.currentTarget;
	context.globalCompositeOperation = 'source-over';
	context.strokeStyle = active.style.backgroundColor;
	activeColor && (activeColor.className = 'color');
	(activeColor = active).className = 'active color';
	e.preventDefault();
}

function toolEraser(e) {
	context.globalCompositeOperation = 'destination-out';
	activeColor && (activeColor.className = '');
	(activeColor = e.currentTarget).className = 'active';
	e.preventDefault();
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
	if (changed) {
		snapshot();
		changed = false;
	}
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
	changed = true;
}

function keyDown(e) {
	if (!e.ctrlKey) return;
	if (e.keyCode == 90) {
		undo();
		e.preventDefault();
	} else if (e.keyCode == 89) {
		redo();
		e.preventDefault();
	}
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
		handlePoll(xhr.responseText);
	};
	xhr.send(null);
}

function handlePoll(json) {
	var response = null;
	try { response = eval('(' + json + ')'); }
	catch (e) { return; }
	if (response.revision <= revision) return;
	revision = response.revision;
	for (var layer in response.layers) {
		var img = document.getElementById('layer' + layer);
		if (!img) {
			img = document.createElement('img');
			img.id = 'layer' + layer;
			container.appendChild(img);
		}
		var updates = response.layers[layer];
		if ('data' in updates && layer != layerid) img.src = updates.data;
		if ('order' in updates) img.style.zIndex = updates.order;
		if ('opacity' in updates) img.style.opacity = updates.opacity / 100;
		if ('visible' in updates) img.style.visibility = updates.visible ? 'visible' : 'hidden';
		// is it worth it to update the layers list?
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
		chat.scrollTop = 0x1000000; // bottom?
	}
}

function sendChat(e) {
	e.preventDefault();
	var body =
		(token ? 'token=' + token + '&' : '') +
		'body=' + encodeURIComponent(chatBody.value);
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/chats.xml');
	xhr.onreadystatechange = function() {
		if (xhr.readyState < 4) return;
		poll();
	};
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
	chatBody.value = '';
}

function publish(e) {
	e.preventDefault();
	publishButton.className = 'work';
	publishButton.innerHTML = '&middot; &middot; &middot;';
	publishButton.removeEventListener('click', publish, false);
	var body =
		'token=' + token +
		'&revision=' + revision +
		'&composite=' + encodeURIComponent(compose(WIDTH, HEIGHT)) +
		'&thumbnail=' + encodeURIComponent(compose(THUMB_WIDTH, THUMB_HEIGHT));
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/boards/' + boardid + '/galleries');
	xhr.onreadystatechange = function() {
		if (xhr.readyState < 4) return;
		publishButton.innerHTML = 'Done';
		setTimeout(function() {
			publishButton.className = '';
			publishButton.innerHTML = 'Publish';
			publishButton.addEventListener('click', publish, false);
		}, 1000);
	};
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

function unlockOrder() {
	rearrangeLayers.innerHTML = 'save';
	rearrangeLayers.removeEventListener('click', unlockOrder, false);
	rearrangeLayers.addEventListener('click', saveOrder, false);

	var layers = layerList.getElementsByTagName('li');
	for (var i = 0; i < layers.length; i++) {
		layers[i].addEventListener('mousedown', startDrag, false);
	}
}

function startDrag(e) {
	e.preventDefault();
	dragging = e.currentTarget;
	document.body.addEventListener('mouseup', stopDrag, false);
	addSwap();
}

function addSwap() {
	var prev, next;
	if (prev = dragging.previousElementSibling) prev.addEventListener('mouseover', swapUp, false);
	if (next = dragging.nextElementSibling) next.addEventListener('mouseover', swapDown, false);
}

function removeSwap() {
	var prev, next;
	if (prev = dragging.previousElementSibling) prev.removeEventListener('mouseover', swapUp, false);
	if (next = dragging.nextElementSibling) next.removeEventListener('mouseover', swapDown, false);
}

function swapUp(e) {
	e.preventDefault();
	removeSwap();
	var li = e.currentTarget;
	layerList.removeChild(dragging);
	layerList.insertBefore(dragging, li);
	addSwap();
	resetOrder();
}

function swapDown(e) {
	e.preventDefault();
	removeSwap();
	var li = e.currentTarget;
	layerList.removeChild(li);
	layerList.insertBefore(li, dragging);
	addSwap();
	resetOrder();
}

function stopDrag(e) {
	e.preventDefault();
	document.body.removeEventListener('mouseup', stopDrag, false);
	removeSwap();
	dragging = null;
}

function getOrder() {
	var layers = layerList.getElementsByTagName('li');
	var order = {};
	for (var i = 0; i < layers.length; i++) {
		order[layers[i].id.substr(2)] = layers.length - i - 1;
	}
	return order;
}

function resetOrder() {
	var order = getOrder();
	for (var layer in order) {
		document.getElementById('layer' + layer).style.zIndex = order[layer];
	}
}

function saveOrder() {
	rearrangeLayers.innerHTML = 'rearrange';

	var body = 'token=' + token;
	var order = getOrder();
	for (var layer in order) {
		body += '&' + layer + '=' + order[layer];
	}

	var layers = layerList.getElementsByTagName('li');
	for (var i = 0; i < layers.length; i++) {
		layers[i].removeEventListener('mousedown', startDrag, false);
	}
	document.body.removeEventListener('mouseup', stopDrag, false);

	rearrangeLayers.removeEventListener('click', saveOrder, false);
	rearrangeLayers.innerHTML = 'saving';
	var xhr = new XMLHttpRequest();
	xhr.open('PUT', '/boards/' + boardid + '/order');
	xhr.onreadystatechange = function() {
		if (xhr.readyState < 4) return;
		rearrangeLayers.innerHTML = 'saved';
		setTimeout(function() {
			rearrangeLayers.innerHTML = 'rearrange';
			rearrangeLayers.addEventListener('click', unlockOrder, false);
		}, 1000);
	};
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
}

function saveVisible(e) {
	var input = e.currentTarget;
	var layer = input.id.substr(7);

	document.getElementById('layer' + layer).style.visibility = input.checked ? 'visible' : 'hidden';

	var body =
		'token=' + token +
		'&visible=' + (input.checked ? 'true' : 'false');

	var xhr = new XMLHttpRequest();
	xhr.open('PUT', '/boards/' + boardid + '/layers/' + layer);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
}

function saveOpacity(e) {
	var input = e.currentTarget;
	var layer = input.id.substr(7);

	var opacity = parseInt(input.value, 10);
	input.value = opacity;
	document.getElementById('layer' + layer).style.opacity = opacity / 100;

	var body =
		'token=' + token +
		'&opacity=' + encodeURIComponent(opacity);

	var xhr = new XMLHttpRequest();
	xhr.open('PUT', '/boards/' + boardid + '/layers/' + layer);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.setRequestHeader('Content-Length', body.length);
	xhr.send(body);
}

function snapshot() {
	if (undoBuffer.length - 1 > undoIndex) undoBuffer.length = undoIndex + 1;
	undoBuffer.push(context.getImageData(0, 0, WIDTH, HEIGHT));
	if (undoBuffer.length > UNDO_STEPS) undoBuffer.shift();
	undoIndex = undoBuffer.length - 1;
}

function undo() {
	if (undoIndex <= 0) return;
	context.putImageData(undoBuffer[--undoIndex], 0, 0);
	scheduleSave();
}

function redo() {
	if (undoIndex >= undoBuffer.length - 1) return;
	context.putImageData(undoBuffer[++undoIndex], 0, 0);
	scheduleSave();
}

function registerShowURLs() {
	var links = document.getElementsByClassName('url');
	for (var i = 0; i < links.length; i++) {
		links[i].addEventListener('click', showURL, false);
	}
}

function showURL(e) {
	e.preventDefault();
	var a = e.currentTarget;
	var span = a.parentNode;
	var cont = span.parentNode;
	var input = document.createElement('input');
	input.className = 'url';
	input.value = a.href;
	input.addEventListener('blur', hideURL, false);
	span.style.display = 'none';
	cont.insertBefore(input, span);
	input.select();
}

function hideURL(e) {
	var input = e.currentTarget;
	var span = input.nextSibling;
	var cont = input.parentNode;
	cont.removeChild(input);
	span.style.display = '';
}
