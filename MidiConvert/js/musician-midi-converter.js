!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t():"function"==typeof define&&define.amd?define("MusicianMidiConverter",[],t):"object"==typeof exports?exports.MusicianMidiConverter=t():e.MusicianMidiConverter=t()}(this,(function(){return(()=>{var e={289:(e,t,r)=>{t.parseMidi=r(666),r(865)},666:e=>{function t(e){for(var t,n=new r(e),a=[];!n.eof();){var i=o();a.push(i)}return a;function o(){var e={};e.deltaTime=n.readVarInt();var r=n.readUInt8();if(240==(240&r)){if(255!==r){if(240==r)return e.type="sysEx",i=n.readVarInt(),e.data=n.readBytes(i),e;if(247==r)return e.type="endSysEx",i=n.readVarInt(),e.data=n.readBytes(i),e;throw"Unrecognised MIDI event type byte: "+r}e.meta=!0;var a=n.readUInt8(),i=n.readVarInt();switch(a){case 0:if(e.type="sequenceNumber",2!==i)throw"Expected length for sequenceNumber event is 2, got "+i;return e.number=n.readUInt16(),e;case 1:return e.type="text",e.text=n.readString(i),e;case 2:return e.type="copyrightNotice",e.text=n.readString(i),e;case 3:return e.type="trackName",e.text=n.readString(i),e;case 4:return e.type="instrumentName",e.text=n.readString(i),e;case 5:return e.type="lyrics",e.text=n.readString(i),e;case 6:return e.type="marker",e.text=n.readString(i),e;case 7:return e.type="cuePoint",e.text=n.readString(i),e;case 32:if(e.type="channelPrefix",1!=i)throw"Expected length for channelPrefix event is 1, got "+i;return e.channel=n.readUInt8(),e;case 33:if(e.type="portPrefix",1!=i)throw"Expected length for portPrefix event is 1, got "+i;return e.port=n.readUInt8(),e;case 47:if(e.type="endOfTrack",0!=i)throw"Expected length for endOfTrack event is 0, got "+i;return e;case 81:if(e.type="setTempo",3!=i)throw"Expected length for setTempo event is 3, got "+i;return e.microsecondsPerBeat=n.readUInt24(),e;case 84:if(e.type="smpteOffset",5!=i)throw"Expected length for smpteOffset event is 5, got "+i;var o=n.readUInt8();return e.frameRate={0:24,32:25,64:29,96:30}[96&o],e.hour=31&o,e.min=n.readUInt8(),e.sec=n.readUInt8(),e.frame=n.readUInt8(),e.subFrame=n.readUInt8(),e;case 88:if(e.type="timeSignature",4!=i)throw"Expected length for timeSignature event is 4, got "+i;return e.numerator=n.readUInt8(),e.denominator=1<<n.readUInt8(),e.metronome=n.readUInt8(),e.thirtyseconds=n.readUInt8(),e;case 89:if(e.type="keySignature",2!=i)throw"Expected length for keySignature event is 2, got "+i;return e.key=n.readInt8(),e.scale=n.readUInt8(),e;case 127:return e.type="sequencerSpecific",e.data=n.readBytes(i),e;default:return e.type="unknownMeta",e.data=n.readBytes(i),e.metatypeByte=a,e}}else{var c;if(0==(128&r)){if(null===t)throw"Running status byte encountered before status byte";c=r,r=t,e.running=!0}else c=n.readUInt8(),t=r;var u=r>>4;switch(e.channel=15&r,u){case 8:return e.type="noteOff",e.noteNumber=c,e.velocity=n.readUInt8(),e;case 9:var s=n.readUInt8();return e.type=0===s?"noteOff":"noteOn",e.noteNumber=c,e.velocity=s,0===s&&(e.byte9=!0),e;case 10:return e.type="noteAftertouch",e.noteNumber=c,e.amount=n.readUInt8(),e;case 11:return e.type="controller",e.controllerType=c,e.value=n.readUInt8(),e;case 12:return e.type="programChange",e.programNumber=c,e;case 13:return e.type="channelAftertouch",e.amount=c,e;case 14:return e.type="pitchBend",e.value=c+(n.readUInt8()<<7)-8192,e;default:throw"Unrecognised MIDI event type: "+u}}}}function r(e){this.buffer=e,this.bufferLen=this.buffer.length,this.pos=0}r.prototype.eof=function(){return this.pos>=this.bufferLen},r.prototype.readUInt8=function(){var e=this.buffer[this.pos];return this.pos+=1,e},r.prototype.readInt8=function(){var e=this.readUInt8();return 128&e?e-256:e},r.prototype.readUInt16=function(){return(this.readUInt8()<<8)+this.readUInt8()},r.prototype.readInt16=function(){var e=this.readUInt16();return 32768&e?e-65536:e},r.prototype.readUInt24=function(){return(this.readUInt8()<<16)+(this.readUInt8()<<8)+this.readUInt8()},r.prototype.readInt24=function(){var e=this.readUInt24();return 8388608&e?e-16777216:e},r.prototype.readUInt32=function(){return(this.readUInt8()<<24)+(this.readUInt8()<<16)+(this.readUInt8()<<8)+this.readUInt8()},r.prototype.readBytes=function(e){var t=this.buffer.slice(this.pos,this.pos+e);return this.pos+=e,t},r.prototype.readString=function(e){var t=this.readBytes(e);return String.fromCharCode.apply(null,t)},r.prototype.readVarInt=function(){for(var e=0;!this.eof();){var t=this.readUInt8();if(!(128&t))return e+t;e+=127&t,e<<=7}return e},r.prototype.readChunk=function(){var e=this.readString(4),t=this.readUInt32();return{id:e,length:t,data:this.readBytes(t)}},e.exports=function(e){var n=new r(e),a=n.readChunk();if("MThd"!=a.id)throw"Bad MIDI file.  Expected 'MHdr', got: '"+a.id+"'";for(var i=function(e){var t=new r(e),n={format:t.readUInt16(),numTracks:t.readUInt16()},a=t.readUInt16();return 32768&a?(n.framesPerSecond=256-(a>>8),n.ticksPerFrame=255&a):n.ticksPerBeat=a,n}(a.data),o=[],c=0;!n.eof()&&c<i.numTracks;c++){var u=n.readChunk();if("MTrk"!=u.id)throw"Bad MIDI file.  Expected 'MTrk', got: '"+u.id+"'";var s=t(u.data);o.push(s)}return{header:i,tracks:o}}},865:e=>{function t(e,t,a){var i,o=new n,c=t.length,u=null;for(i=0;i<c;i++)!1!==a.running&&(a.running||t[i].running)||(u=null),u=r(o,t[i],u,a.useByte9ForNoteOff);e.writeChunk("MTrk",o.buffer)}function r(e,t,r,n){var a=t.type,i=t.deltaTime,o=t.text||"",c=t.data||[],u=null;switch(e.writeVarInt(i),a){case"sequenceNumber":e.writeUInt8(255),e.writeUInt8(0),e.writeVarInt(2),e.writeUInt16(t.number);break;case"text":e.writeUInt8(255),e.writeUInt8(1),e.writeVarInt(o.length),e.writeString(o);break;case"copyrightNotice":e.writeUInt8(255),e.writeUInt8(2),e.writeVarInt(o.length),e.writeString(o);break;case"trackName":e.writeUInt8(255),e.writeUInt8(3),e.writeVarInt(o.length),e.writeString(o);break;case"instrumentName":e.writeUInt8(255),e.writeUInt8(4),e.writeVarInt(o.length),e.writeString(o);break;case"lyrics":e.writeUInt8(255),e.writeUInt8(5),e.writeVarInt(o.length),e.writeString(o);break;case"marker":e.writeUInt8(255),e.writeUInt8(6),e.writeVarInt(o.length),e.writeString(o);break;case"cuePoint":e.writeUInt8(255),e.writeUInt8(7),e.writeVarInt(o.length),e.writeString(o);break;case"channelPrefix":e.writeUInt8(255),e.writeUInt8(32),e.writeVarInt(1),e.writeUInt8(t.channel);break;case"portPrefix":e.writeUInt8(255),e.writeUInt8(33),e.writeVarInt(1),e.writeUInt8(t.port);break;case"endOfTrack":e.writeUInt8(255),e.writeUInt8(47),e.writeVarInt(0);break;case"setTempo":e.writeUInt8(255),e.writeUInt8(81),e.writeVarInt(3),e.writeUInt24(t.microsecondsPerBeat);break;case"smpteOffset":e.writeUInt8(255),e.writeUInt8(84),e.writeVarInt(5);var s=31&t.hour|{24:0,25:32,29:64,30:96}[t.frameRate];e.writeUInt8(s),e.writeUInt8(t.min),e.writeUInt8(t.sec),e.writeUInt8(t.frame),e.writeUInt8(t.subFrame);break;case"timeSignature":e.writeUInt8(255),e.writeUInt8(88),e.writeVarInt(4),e.writeUInt8(t.numerator);var f=255&Math.floor(Math.log(t.denominator)/Math.LN2);e.writeUInt8(f),e.writeUInt8(t.metronome),e.writeUInt8(t.thirtyseconds||8);break;case"keySignature":e.writeUInt8(255),e.writeUInt8(89),e.writeVarInt(2),e.writeInt8(t.key),e.writeUInt8(t.scale);break;case"sequencerSpecific":e.writeUInt8(255),e.writeUInt8(127),e.writeVarInt(c.length),e.writeBytes(c);break;case"unknownMeta":null!=t.metatypeByte&&(e.writeUInt8(255),e.writeUInt8(t.metatypeByte),e.writeVarInt(c.length),e.writeBytes(c));break;case"sysEx":e.writeUInt8(240),e.writeVarInt(c.length),e.writeBytes(c);break;case"endSysEx":e.writeUInt8(247),e.writeVarInt(c.length),e.writeBytes(c);break;case"noteOff":(u=(!1!==n&&t.byte9||n&&0==t.velocity?144:128)|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.noteNumber),e.writeUInt8(t.velocity);break;case"noteOn":(u=144|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.noteNumber),e.writeUInt8(t.velocity);break;case"noteAftertouch":(u=160|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.noteNumber),e.writeUInt8(t.amount);break;case"controller":(u=176|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.controllerType),e.writeUInt8(t.value);break;case"programChange":(u=192|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.programNumber);break;case"channelAftertouch":(u=208|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.amount);break;case"pitchBend":(u=224|t.channel)!==r&&e.writeUInt8(u);var l=8192+t.value,h=127&l,p=l>>7&127;e.writeUInt8(h),e.writeUInt8(p);break;default:throw"Unrecognized event type: "+a}return u}function n(){this.buffer=[]}n.prototype.writeUInt8=function(e){this.buffer.push(255&e)},n.prototype.writeInt8=n.prototype.writeUInt8,n.prototype.writeUInt16=function(e){var t=e>>8&255,r=255&e;this.writeUInt8(t),this.writeUInt8(r)},n.prototype.writeInt16=n.prototype.writeUInt16,n.prototype.writeUInt24=function(e){var t=e>>16&255,r=e>>8&255,n=255&e;this.writeUInt8(t),this.writeUInt8(r),this.writeUInt8(n)},n.prototype.writeInt24=n.prototype.writeUInt24,n.prototype.writeUInt32=function(e){var t=e>>24&255,r=e>>16&255,n=e>>8&255,a=255&e;this.writeUInt8(t),this.writeUInt8(r),this.writeUInt8(n),this.writeUInt8(a)},n.prototype.writeInt32=n.prototype.writeUInt32,n.prototype.writeBytes=function(e){this.buffer=this.buffer.concat(Array.prototype.slice.call(e,0))},n.prototype.writeString=function(e){var t,r=e.length,n=[];for(t=0;t<r;t++)n.push(e.codePointAt(t));this.writeBytes(n)},n.prototype.writeVarInt=function(e){if(e<0)throw"Cannot write negative variable-length integer";if(e<=127)this.writeUInt8(e);else{var t=e,r=[];for(r.push(127&t),t>>=7;t;){var n=127&t|128;r.push(n),t>>=7}this.writeBytes(r.reverse())}},n.prototype.writeChunk=function(e,t){this.writeString(e),this.writeUInt32(t.length),this.writeBytes(t)},e.exports=function(e,r){if("object"!=typeof e)throw"Invalid MIDI data";r=r||{};var a,i=e.header||{},o=e.tracks||[],c=o.length,u=new n;for(function(e,t,r){var a=null==t.format?1:t.format,i=128;t.timeDivision?i=t.timeDivision:t.ticksPerFrame&&t.framesPerSecond?i=-(255&t.framesPerSecond)<<8|255&t.ticksPerFrame:t.ticksPerBeat&&(i=32767&t.ticksPerBeat);var o=new n;o.writeUInt16(a),o.writeUInt16(r),o.writeUInt16(i),e.writeChunk("MThd",o.buffer)}(u,i,c),a=0;a<c;a++)t(u,o[a],r);return u.buffer}}},t={};function r(n){var a=t[n];if(void 0!==a)return a.exports;var i=t[n]={exports:{}};return e[n](i,i.exports,r),i.exports}r.d=(e,t)=>{for(var n in t)r.o(t,n)&&!r.o(e,n)&&Object.defineProperty(e,n,{enumerable:!0,get:t[n]})},r.o=(e,t)=>Object.prototype.hasOwnProperty.call(e,t),r.r=e=>{"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})};var n={};return(()=>{"use strict";function e(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var r=null==e?null:"undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(null!=r){var n,a,i=[],o=!0,c=!1;try{for(r=r.call(e);!(o=(n=r.next()).done)&&(i.push(n.value),!t||i.length!==t);o=!0);}catch(e){c=!0,a=e}finally{try{o||null==r.return||r.return()}finally{if(c)throw a}}return i}}(e,t)||c(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function t(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function a(e){for(var r=1;r<arguments.length;r++){var n=null!=arguments[r]?arguments[r]:{};r%2?t(Object(n),!0).forEach((function(t){i(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):t(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function i(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r="undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(!r){if(Array.isArray(e)||(r=c(e))||t&&e&&"number"==typeof e.length){r&&(e=r);var n=0,a=function(){};return{s:a,n:function(){return n>=e.length?{done:!0}:{done:!1,value:e[n++]}},e:function(e){throw e},f:a}}throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}var i,o=!0,u=!1;return{s:function(){r=r.call(e)},n:function(){var e=r.next();return o=e.done,e},e:function(e){u=!0,i=e},f:function(){try{o||null==r.return||r.return()}finally{if(u)throw i}}}}function c(e,t){if(e){if("string"==typeof e)return u(e,t);var r=Object.prototype.toString.call(e).slice(8,-1);return"Object"===r&&e.constructor&&(r=e.constructor.name),"Map"===r||"Set"===r?Array.from(e):"Arguments"===r||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r)?u(e,t):void 0}}function u(e,t){(null==t||t>e.length)&&(t=e.length);for(var r=0,n=new Array(t);r<t;r++)n[r]=e[r];return n}r.r(n),r.d(n,{CONVERTER_VERSION:()=>f,packSong:()=>y});var s=r(289).parseMidi,f="7.1",l=273.0625;function h(e,t){e&=Math.pow(256,t)-1;for(var r="",n=0;n<t;n++)r=String.fromCharCode(255&e)+r,e>>=8;return r}function p(e,t,r){return h(Math.round(e*r),t)}function d(e){var t=function(e){return unescape(encodeURIComponent(e)).replace(/\u0000+$/,"")}(e);return h(t.length,2)+t}function y(t,r){var n=function(t,r){t instanceof ArrayBuffer&&(t=new Uint8Array(t));var n,i=s(t),c=function(e){var t,r=new Map,n=o(e);try{for(n.s();!(t=n.n()).done;){var a=t.value;if("noteOn"===a.type||"noteOff"===a.type){var i="".concat(a.trackIndex,"-").concat(a.channel,"-").concat(a.noteNumber),c=r.get(i);c&&(c.duration=a.time-c.time,r.delete(i)),"noteOn"===a.type&&r.set(i,a)}}}catch(e){n.e(e)}finally{n.f()}return e}(function(t){var r,n=[],i={},c={},u={},s={},f=[6,100,101],l=o(t);try{for(l.s();!(r=l.n()).done;){var h=r.value,p=!1;if("controller"===h.type&&f.includes(h.controllerType)&&(c[h.channel]||(c[h.channel]={}),c[h.channel][h.controllerType]=h.value,p=6===h.controllerType&&!c[h.channel][100]&&0===c[h.channel][101]),"noteOn"===h.type||"noteOff"===h.type){var d=u[h.channel]||0,y=s[h.channel]||2,I=Math.round(d*y),w=h.noteNumber+I;n.push(a(a({},h),{},{noteNumber:w}));var v="".concat(h.trackIndex,"-").concat(h.noteNumber);i[h.channel]||(i[h.channel]=new Map),"noteOn"===h.type?i[h.channel].set(v,h):i[h.channel].delete(v)}else if("pitchBend"===h.type||p){var m=s[h.channel]||2,U=m;p&&(U=h.value,s[h.channel]=U);var g=u[h.channel]||0,b=g;"pitchBend"===h.type&&(b=h.value/8192,u[h.channel]=b);var k=Math.round(m*g),x=Math.round(U*b);if(k!==x&&i[h.channel]){var O,S=o(i[h.channel]);try{for(S.s();!(O=S.n()).done;){var P=e(O.value,2),M=(P[0],P[1]);n.push({deltaTime:h.deltaTime,tick:h.tick,time:h.time,channel:M.channel,noteNumber:M.noteNumber+k,trackIndex:M.trackIndex,type:"noteOff",velocity:M.velocity}),n.push({deltaTime:h.deltaTime,tick:h.tick,time:h.time,channel:M.channel,noteNumber:M.noteNumber+x,trackIndex:M.trackIndex,type:"noteOn",velocity:M.velocity})}}catch(e){S.e(e)}finally{S.f()}}}else n.push(a({},h))}}catch(e){l.e(e)}finally{l.f()}return n}(function(t){var r,n=[],i=new Map,c=new Map,u={},s=o(t);try{for(s.s();!(r=s.n()).done;){var f=r.value;if("noteOn"===f.type||"noteOff"===f.type){var l="".concat(f.channel,"-").concat(f.trackIndex,"-").concat(f.noteNumber);"noteOn"===f.type?(i.set(l,f),n.push(a({},f))):(i.delete(l),u[f.channel]?c.set(l,f):n.push(a({},f)))}else if("controller"===f.type&&64===f.controllerType){var h=f.value>=64;if(!h&&u[f.channel]){var p,d=o(c);try{for(d.s();!(p=d.n()).done;){var y=e(p.value,2),I=y[0],w=y[1];w.channel!==f.channel||i.has(I)||(n.push({deltaTime:f.deltaTime,tick:f.tick,time:f.time,channel:w.channel,noteNumber:w.noteNumber,trackIndex:w.trackIndex,type:"noteOff",velocity:w.velocity}),c.delete(I))}}catch(e){d.e(e)}finally{d.f()}}u[f.channel]=h}else n.push(a({},f))}}catch(e){s.e(e)}finally{s.f()}var v,m=o(c);try{for(m.s();!(v=m.n()).done;){var U=e(v.value,2),g=(U[0],U[1]);n.push(a({},g))}}catch(e){m.e(e)}finally{m.f()}return n}(function(e){var t=[];for(var r in e.tracks){var n,a=0,i=o(e.tracks[r]);try{for(i.s();!(n=i.n()).done;){var c=n.value;a+=c.deltaTime,c.tick=a,c.trackIndex=parseInt(r,10),t.push(c)}}catch(e){i.e(e)}finally{i.f()}}t.sort((function(e,t){return e.tick<t.tick?-1:e.tick>t.tick?1:0}));var u,s=0,f=0,l=120;u=e.header.ticksPerBeat?60/l/e.header.ticksPerBeat:1e6/(e.header.framesPerSecond*e.header.ticksPerFrame);for(var h=0,p=t;h<p.length;h++){var d=p[h],y=d.tick-s;d.time=f+y*u,f=d.time,s=d.tick,"setTempo"===d.type&&(l=6e7/d.microsecondsPerBeat,e.header.ticksPerBeat&&(u=60/l/e.header.ticksPerBeat))}return t}(i)))),u=c[c.length-1].time,f=new Map,l={},h=new Map,p=[];function d(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:0,t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:0,r="".concat(e,"-").concat(t),n=h.get(r)||0,a="".concat(e,"-").concat(t,"-").concat(n),o=2===i.format?9===t||10===t:9===t;if(f.has(a))return f.get(a);var c={name:"",trackIndex:e,channel:t,instrument:n,isPercussion:o,notes:[]};return f.set(a,c),c}var y,I=o(c);try{for(I.s();!(y=I.n()).done;){var w=y.value;switch(w.type){case"noteOn":d(w.trackIndex,w.channel).notes.push({time:w.time,duration:w.duration,key:w.noteNumber,velocity:w.velocity});break;case"programChange":var v="".concat(w.trackIndex,"-").concat(w.channel);h.set(v,w.programNumber);break;case"trackName":var m=w.text;l[w.trackIndex]=m;break;case"text":var U=w.text.match(/^@T(.*)$/);U&&p.push(U[1])}}}catch(e){I.e(e)}finally{I.f()}n=p.length>0?p.join(" - "):function(e){return e.replace(/[_]+/g," ").replace(/\.[a-zA-Z0-9]+$/,"").replace(/^(.)|\s+(.)/g,(function(e){return e.toUpperCase()}))}(r);var g=Array.from(f,(function(t){var r=e(t,2);return r[0],r[1]})).filter((function(e){return e.notes.length>0}));g.sort((function(e,t){return 1e6*e.trackIndex+1e3*e.channel+e.instrument<1e6*t.trackIndex+1e3*t.channel+t.instrument?-1:1}));var b,k=o(g);try{for(k.s();!(b=k.n()).done;){var x=b.value;x.name=l[x.trackIndex]||""}}catch(e){k.e(e)}finally{k.f()}return{title:n,duration:u,tracks:g}}(t,r),i="";i+="MUS7",i+=d(n.title),i+=h(16,1),i+=h(Math.ceil(n.duration),3);var c,u=[],f=o(n.tracks);try{for(f.s();!(c=f.n()).done;){var y=c.value,I={};y.isPercussion?I.instrument=y.instrument+128:I.instrument=y.instrument,I.isPercussion=y.isPercussion,I.channel=y.channel+1,I.name=y.name||"";var w,v=0,m=[],U=o(y.notes);try{for(U.s();!(w=U.n()).done;){for(var g=w.value,b=g.time-v,k=g.key,x=Math.min(g.duration,6),O="";b>l;)O+=h(255,1),b-=l,v+=l;m.push(O+h(k,1)+p(b,2,240)+p(x,1,42.5))}}catch(e){U.e(e)}finally{U.f()}I.notes=m,u.push(I)}}catch(e){f.e(e)}finally{f.f()}if(u.length>255)throw"A song cannot have more than 255 tracks.";i+=h(u.length,1);for(var S=0,P=u;S<P.length;S++){var M=P[S];if(M.notes.length>65535)throw"A track cannot have more than 65535 notes.";i+=h(M.instrument,1),i+=h(M.channel,1),i+=h(M.notes.length,2)}for(var B=0,N=u;B<N.length;B++)i+=N[B].notes.join("");for(var T=0,V=u;T<V.length;T++)i+=d(V[T].name);return i}})(),n})()}));
//# sourceMappingURL=musician-midi-converter.js.map