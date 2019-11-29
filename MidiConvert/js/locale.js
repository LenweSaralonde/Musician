var userLang = (navigator.language || navigator.userLanguage).replace(/-.*$/g, '');
var MUSICIAN_MSG = {};

var MUSICIAN_DOWNLOAD_URL = null;
var MUSICIAN_VERSION = null;

switch (userLang) {
	case 'fr':
		localeFile = userLang + '.js?v=3';
		break;

	default:
		localeFile = 'default.js?v=3';
}

// Set localized strings
window.onload = function() {
	document.title = MUSICIAN_MSG.title;
	document.getElementById("header").innerHTML = MUSICIAN_MSG.header;
	document.getElementById("Text").innerHTML = MUSICIAN_MSG.instructions;
	document.getElementById("CopyButton").innerHTML = MUSICIAN_MSG.copy;
	setDownloadLink();
	document.getElementById("main").style = 'opacity: 1';
	document.getElementById("MusicianWindow").src = 'img/' + MUSICIAN_MSG.windowBackgroundImage;
	document.querySelector("#Discord a").title = MUSICIAN_MSG.joinDiscord;
	document.querySelector("#BattleNet a").title = MUSICIAN_MSG.joinBattleNet;
	document.querySelector("#Patreon a").title = MUSICIAN_MSG.becomeAPatron;
	document.querySelector("#PayPal a").title = MUSICIAN_MSG.donatePayPal;
	document.querySelector('#PatreonLink').innerHTML = MUSICIAN_MSG.patreonLink;
	document.querySelector('#DonateLink').innerHTML = MUSICIAN_MSG.donateLink;

	var localeScriptTag = document.createElement('script');
	localeScriptTag.src = 'https://musician.lenwe.io/version/';
	document.body.appendChild(localeScriptTag);
};

function setMusicianVersion(version, url) {
	MUSICIAN_VERSION = version;
	MUSICIAN_DOWNLOAD_URL = url;
	setDownloadLink();
}

function setDownloadLink() {
	if (MUSICIAN_VERSION != null)
		document.getElementById("DowloadLink").innerHTML = MUSICIAN_MSG.dowloadVersion.replace(/\{version\}/, MUSICIAN_VERSION);
	else
		document.getElementById("DowloadLink").innerHTML = MUSICIAN_MSG.dowload;
}

var localeScriptTag = document.createElement('script');
localeScriptTag.src = './locale/' + localeFile;
document.head.appendChild(localeScriptTag);