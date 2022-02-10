var userLang = (navigator.language || navigator.userLanguage).replace(/[-_].*$/g, '');

var LOCALE_VERSION = 7;
var MUSICIAN_MSG = {};

var MUSICIAN_DOWNLOAD_URL = null;
var MUSICIAN_VERSION = null;

var localeFile;

switch (userLang) {
	case 'de':
	case 'es':
	case 'fr':
	case 'it':
	case 'ko':
	case 'pt':
	case 'ru':
	case 'zh':
		localeFile = userLang;
		break;

	default:
		localeFile = 'default';
}

// Set localized strings
window.onload = function() {
	document.title = MUSICIAN_MSG.title;
	document.getElementById("header").innerHTML = MUSICIAN_MSG.header;
	document.getElementById("Text").innerHTML = MUSICIAN_MSG.instructions;
	document.getElementById("CopyButton").innerHTML = MUSICIAN_MSG.copy;
	setDownloadLink();
	document.getElementById("main").style = 'opacity: 1';
	document.querySelector("#Discord a").title = MUSICIAN_MSG.joinDiscord;
	document.querySelector("#BattleNet a").title = MUSICIAN_MSG.joinBattleNet;
	document.querySelector("#Patreon a").title = MUSICIAN_MSG.becomeAPatron;
	document.querySelector("#PayPal a").title = MUSICIAN_MSG.donatePayPal;
	document.querySelector('#PatreonLink').innerHTML = MUSICIAN_MSG.patreonLink;
	document.querySelector('#DonateLink').innerHTML = MUSICIAN_MSG.donateLink;
	document.querySelector('label[for=FromMuseScore]').innerHTML = MUSICIAN_MSG.fromMuseScore;

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
localeScriptTag.src = './locale/' + localeFile + '.js?v=' + LOCALE_VERSION;
document.head.appendChild(localeScriptTag);