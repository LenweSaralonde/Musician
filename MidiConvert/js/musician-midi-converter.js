!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t():"function"==typeof define&&define.amd?define("MusicianMidiConverter",[],t):"object"==typeof exports?exports.MusicianMidiConverter=t():e.MusicianMidiConverter=t()}(this,(()=>(()=>{var e={473:(e,t,r)=>{t.parseMidi=r(650),r(772)},650:e=>{function t(e){for(var t,n=new r(e),a=[];!n.eof();){var i=o();a.push(i)}return a;function o(){var e={};e.deltaTime=n.readVarInt();var r=n.readUInt8();if(240==(240&r)){if(255!==r){if(240==r)return e.type="sysEx",i=n.readVarInt(),e.data=n.readBytes(i),e;if(247==r)return e.type="endSysEx",i=n.readVarInt(),e.data=n.readBytes(i),e;throw"Unrecognised MIDI event type byte: "+r}e.meta=!0;var a=n.readUInt8(),i=n.readVarInt();switch(a){case 0:if(e.type="sequenceNumber",2!==i)throw"Expected length for sequenceNumber event is 2, got "+i;return e.number=n.readUInt16(),e;case 1:return e.type="text",e.text=n.readString(i),e;case 2:return e.type="copyrightNotice",e.text=n.readString(i),e;case 3:return e.type="trackName",e.text=n.readString(i),e;case 4:return e.type="instrumentName",e.text=n.readString(i),e;case 5:return e.type="lyrics",e.text=n.readString(i),e;case 6:return e.type="marker",e.text=n.readString(i),e;case 7:return e.type="cuePoint",e.text=n.readString(i),e;case 32:if(e.type="channelPrefix",1!=i)throw"Expected length for channelPrefix event is 1, got "+i;return e.channel=n.readUInt8(),e;case 33:if(e.type="portPrefix",1!=i)throw"Expected length for portPrefix event is 1, got "+i;return e.port=n.readUInt8(),e;case 47:if(e.type="endOfTrack",0!=i)throw"Expected length for endOfTrack event is 0, got "+i;return e;case 81:if(e.type="setTempo",3!=i)throw"Expected length for setTempo event is 3, got "+i;return e.microsecondsPerBeat=n.readUInt24(),e;case 84:if(e.type="smpteOffset",5!=i)throw"Expected length for smpteOffset event is 5, got "+i;var o=n.readUInt8();return e.frameRate={0:24,32:25,64:29,96:30}[96&o],e.hour=31&o,e.min=n.readUInt8(),e.sec=n.readUInt8(),e.frame=n.readUInt8(),e.subFrame=n.readUInt8(),e;case 88:if(e.type="timeSignature",2!=i&&4!=i)throw"Expected length for timeSignature event is 4 or 2, got "+i;return e.numerator=n.readUInt8(),e.denominator=1<<n.readUInt8(),4===i?(e.metronome=n.readUInt8(),e.thirtyseconds=n.readUInt8()):(e.metronome=36,e.thirtyseconds=8),e;case 89:if(e.type="keySignature",2!=i)throw"Expected length for keySignature event is 2, got "+i;return e.key=n.readInt8(),e.scale=n.readUInt8(),e;case 127:return e.type="sequencerSpecific",e.data=n.readBytes(i),e;default:return e.type="unknownMeta",e.data=n.readBytes(i),e.metatypeByte=a,e}}else{var c;if(0==(128&r)){if(null===t)throw"Running status byte encountered before status byte";c=r,r=t,e.running=!0}else c=n.readUInt8(),t=r;var u=r>>4;switch(e.channel=15&r,u){case 8:return e.type="noteOff",e.noteNumber=c,e.velocity=n.readUInt8(),e;case 9:var s=n.readUInt8();return e.type=0===s?"noteOff":"noteOn",e.noteNumber=c,e.velocity=s,0===s&&(e.byte9=!0),e;case 10:return e.type="noteAftertouch",e.noteNumber=c,e.amount=n.readUInt8(),e;case 11:return e.type="controller",e.controllerType=c,e.value=n.readUInt8(),e;case 12:return e.type="programChange",e.programNumber=c,e;case 13:return e.type="channelAftertouch",e.amount=c,e;case 14:return e.type="pitchBend",e.value=c+(n.readUInt8()<<7)-8192,e;default:throw"Unrecognised MIDI event type: "+u}}}}function r(e){this.buffer=e,this.bufferLen=this.buffer.length,this.pos=0}r.prototype.eof=function(){return this.pos>=this.bufferLen},r.prototype.readUInt8=function(){var e=this.buffer[this.pos];return this.pos+=1,e},r.prototype.readInt8=function(){var e=this.readUInt8();return 128&e?e-256:e},r.prototype.readUInt16=function(){return(this.readUInt8()<<8)+this.readUInt8()},r.prototype.readInt16=function(){var e=this.readUInt16();return 32768&e?e-65536:e},r.prototype.readUInt24=function(){return(this.readUInt8()<<16)+(this.readUInt8()<<8)+this.readUInt8()},r.prototype.readInt24=function(){var e=this.readUInt24();return 8388608&e?e-16777216:e},r.prototype.readUInt32=function(){return(this.readUInt8()<<24)+(this.readUInt8()<<16)+(this.readUInt8()<<8)+this.readUInt8()},r.prototype.readBytes=function(e){var t=this.buffer.slice(this.pos,this.pos+e);return this.pos+=e,t},r.prototype.readString=function(e){var t=this.readBytes(e);return String.fromCharCode.apply(null,t)},r.prototype.readVarInt=function(){for(var e=0;!this.eof();){var t=this.readUInt8();if(!(128&t))return e+t;e+=127&t,e<<=7}return e},r.prototype.readChunk=function(){var e=this.readString(4),t=this.readUInt32();return{id:e,length:t,data:this.readBytes(t)}},e.exports=function(e){var n=new r(e),a=n.readChunk();if("MThd"!=a.id)throw"Bad MIDI file.  Expected 'MHdr', got: '"+a.id+"'";for(var i=function(e){var t=new r(e),n={format:t.readUInt16(),numTracks:t.readUInt16()},a=t.readUInt16();return 32768&a?(n.framesPerSecond=256-(a>>8),n.ticksPerFrame=255&a):n.ticksPerBeat=a,n}(a.data),o=[],c=0;!n.eof()&&c<i.numTracks;c++){var u=n.readChunk();if("MTrk"!=u.id)throw"Bad MIDI file.  Expected 'MTrk', got: '"+u.id+"'";var s=t(u.data);o.push(s)}return{header:i,tracks:o}}},772:e=>{function t(e){return t="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},t(e)}function r(e,t,r){var i,o=new a,c=t.length,u=null;for(i=0;i<c;i++)!1!==r.running&&(r.running||t[i].running)||(u=null),u=n(o,t[i],u,r.useByte9ForNoteOff);e.writeChunk("MTrk",o.buffer)}function n(e,t,r,n){var a=t.type,i=t.deltaTime,o=t.text||"",c=t.data||[],u=null;switch(e.writeVarInt(i),a){case"sequenceNumber":e.writeUInt8(255),e.writeUInt8(0),e.writeVarInt(2),e.writeUInt16(t.number);break;case"text":e.writeUInt8(255),e.writeUInt8(1),e.writeVarInt(o.length),e.writeString(o);break;case"copyrightNotice":e.writeUInt8(255),e.writeUInt8(2),e.writeVarInt(o.length),e.writeString(o);break;case"trackName":e.writeUInt8(255),e.writeUInt8(3),e.writeVarInt(o.length),e.writeString(o);break;case"instrumentName":e.writeUInt8(255),e.writeUInt8(4),e.writeVarInt(o.length),e.writeString(o);break;case"lyrics":e.writeUInt8(255),e.writeUInt8(5),e.writeVarInt(o.length),e.writeString(o);break;case"marker":e.writeUInt8(255),e.writeUInt8(6),e.writeVarInt(o.length),e.writeString(o);break;case"cuePoint":e.writeUInt8(255),e.writeUInt8(7),e.writeVarInt(o.length),e.writeString(o);break;case"channelPrefix":e.writeUInt8(255),e.writeUInt8(32),e.writeVarInt(1),e.writeUInt8(t.channel);break;case"portPrefix":e.writeUInt8(255),e.writeUInt8(33),e.writeVarInt(1),e.writeUInt8(t.port);break;case"endOfTrack":e.writeUInt8(255),e.writeUInt8(47),e.writeVarInt(0);break;case"setTempo":e.writeUInt8(255),e.writeUInt8(81),e.writeVarInt(3),e.writeUInt24(t.microsecondsPerBeat);break;case"smpteOffset":e.writeUInt8(255),e.writeUInt8(84),e.writeVarInt(5);var s=31&t.hour|{24:0,25:32,29:64,30:96}[t.frameRate];e.writeUInt8(s),e.writeUInt8(t.min),e.writeUInt8(t.sec),e.writeUInt8(t.frame),e.writeUInt8(t.subFrame);break;case"timeSignature":e.writeUInt8(255),e.writeUInt8(88),e.writeVarInt(4),e.writeUInt8(t.numerator);var l=255&Math.floor(Math.log(t.denominator)/Math.LN2);e.writeUInt8(l),e.writeUInt8(t.metronome),e.writeUInt8(t.thirtyseconds||8);break;case"keySignature":e.writeUInt8(255),e.writeUInt8(89),e.writeVarInt(2),e.writeInt8(t.key),e.writeUInt8(t.scale);break;case"sequencerSpecific":e.writeUInt8(255),e.writeUInt8(127),e.writeVarInt(c.length),e.writeBytes(c);break;case"unknownMeta":null!=t.metatypeByte&&(e.writeUInt8(255),e.writeUInt8(t.metatypeByte),e.writeVarInt(c.length),e.writeBytes(c));break;case"sysEx":e.writeUInt8(240),e.writeVarInt(c.length),e.writeBytes(c);break;case"endSysEx":e.writeUInt8(247),e.writeVarInt(c.length),e.writeBytes(c);break;case"noteOff":(u=(!1!==n&&t.byte9||n&&0==t.velocity?144:128)|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.noteNumber),e.writeUInt8(t.velocity);break;case"noteOn":(u=144|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.noteNumber),e.writeUInt8(t.velocity);break;case"noteAftertouch":(u=160|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.noteNumber),e.writeUInt8(t.amount);break;case"controller":(u=176|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.controllerType),e.writeUInt8(t.value);break;case"programChange":(u=192|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.programNumber);break;case"channelAftertouch":(u=208|t.channel)!==r&&e.writeUInt8(u),e.writeUInt8(t.amount);break;case"pitchBend":(u=224|t.channel)!==r&&e.writeUInt8(u);var f=8192+t.value,h=127&f,p=f>>7&127;e.writeUInt8(h),e.writeUInt8(p);break;default:throw"Unrecognized event type: "+a}return u}function a(){this.buffer=[]}a.prototype.writeUInt8=function(e){this.buffer.push(255&e)},a.prototype.writeInt8=a.prototype.writeUInt8,a.prototype.writeUInt16=function(e){var t=e>>8&255,r=255&e;this.writeUInt8(t),this.writeUInt8(r)},a.prototype.writeInt16=a.prototype.writeUInt16,a.prototype.writeUInt24=function(e){var t=e>>16&255,r=e>>8&255,n=255&e;this.writeUInt8(t),this.writeUInt8(r),this.writeUInt8(n)},a.prototype.writeInt24=a.prototype.writeUInt24,a.prototype.writeUInt32=function(e){var t=e>>24&255,r=e>>16&255,n=e>>8&255,a=255&e;this.writeUInt8(t),this.writeUInt8(r),this.writeUInt8(n),this.writeUInt8(a)},a.prototype.writeInt32=a.prototype.writeUInt32,a.prototype.writeBytes=function(e){this.buffer=this.buffer.concat(Array.prototype.slice.call(e,0))},a.prototype.writeString=function(e){var t,r=e.length,n=[];for(t=0;t<r;t++)n.push(e.codePointAt(t));this.writeBytes(n)},a.prototype.writeVarInt=function(e){if(e<0)throw"Cannot write negative variable-length integer";if(e<=127)this.writeUInt8(e);else{var t=e,r=[];for(r.push(127&t),t>>=7;t;){var n=127&t|128;r.push(n),t>>=7}this.writeBytes(r.reverse())}},a.prototype.writeChunk=function(e,t){this.writeString(e),this.writeUInt32(t.length),this.writeBytes(t)},e.exports=function(e,n){if("object"!==t(e))throw"Invalid MIDI data";n=n||{};var i,o=e.header||{},c=e.tracks||[],u=c.length,s=new a;for(function(e,t,r){var n=null==t.format?1:t.format,i=128;t.timeDivision?i=t.timeDivision:t.ticksPerFrame&&t.framesPerSecond?i=-(255&t.framesPerSecond)<<8|255&t.ticksPerFrame:t.ticksPerBeat&&(i=32767&t.ticksPerBeat);var o=new a;o.writeUInt16(n),o.writeUInt16(r),o.writeUInt16(i),e.writeChunk("MThd",o.buffer)}(s,o,u),i=0;i<u;i++)r(s,c[i],n);return s.buffer}}},t={};function r(n){var a=t[n];if(void 0!==a)return a.exports;var i=t[n]={exports:{}};return e[n](i,i.exports,r),i.exports}r.d=(e,t)=>{for(var n in t)r.o(t,n)&&!r.o(e,n)&&Object.defineProperty(e,n,{enumerable:!0,get:t[n]})},r.o=(e,t)=>Object.prototype.hasOwnProperty.call(e,t),r.r=e=>{"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})};var n={};return(()=>{"use strict";function e(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var r=null==e?null:"undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(null!=r){var n,a,i=[],o=!0,c=!1;try{for(r=r.call(e);!(o=(n=r.next()).done)&&(i.push(n.value),!t||i.length!==t);o=!0);}catch(e){c=!0,a=e}finally{try{o||null==r.return||r.return()}finally{if(c)throw a}}return i}}(e,t)||c(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function t(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function a(e){for(var r=1;r<arguments.length;r++){var n=null!=arguments[r]?arguments[r]:{};r%2?t(Object(n),!0).forEach((function(t){i(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):t(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function i(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r="undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(!r){if(Array.isArray(e)||(r=c(e))||t&&e&&"number"==typeof e.length){r&&(e=r);var n=0,a=function(){};return{s:a,n:function(){return n>=e.length?{done:!0}:{done:!1,value:e[n++]}},e:function(e){throw e},f:a}}throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}var i,o=!0,u=!1;return{s:function(){r=r.call(e)},n:function(){var e=r.next();return o=e.done,e},e:function(e){u=!0,i=e},f:function(){try{o||null==r.return||r.return()}finally{if(u)throw i}}}}function c(e,t){if(e){if("string"==typeof e)return u(e,t);var r=Object.prototype.toString.call(e).slice(8,-1);return"Object"===r&&e.constructor&&(r=e.constructor.name),"Map"===r||"Set"===r?Array.from(e):"Arguments"===r||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r)?u(e,t):void 0}}function u(e,t){(null==t||t>e.length)&&(t=e.length);for(var r=0,n=new Array(t);r<t;r++)n[r]=e[r];return n}r.r(n),r.d(n,{CONVERTER_VERSION:()=>l,packSong:()=>I});var s=r(473).parseMidi,l="8.5",f=273.0625,h=100,p=101;function d(e,t){e&=Math.pow(256,t)-1;for(var r="",n=0;n<t;n++)r=String.fromCharCode(255&e)+r,e>>=8;return r}function y(e){var t=function(e){return unescape(encodeURIComponent(e)).replace(/\u0000+$/,"")}(e);return d(t.length,2)+t}function I(t,r,n){var i=function(t,r,n){t instanceof ArrayBuffer&&(t=new Uint8Array(t));var i,c=s(t),u=function(e){var t=[];for(var r in e.tracks){var n,a=0,i=o(e.tracks[r]);try{for(i.s();!(n=i.n()).done;){var c=n.value;a+=c.deltaTime,c.tick=a,c.trackIndex=parseInt(r,10),t.push(c)}}catch(e){i.e(e)}finally{i.f()}}t.sort((function(e,t){return e.tick<t.tick?-1:e.tick>t.tick?1:0}));var u,s=0,l=0,f=120;u=e.header.ticksPerBeat?60/f/e.header.ticksPerBeat:1e6/(e.header.framesPerSecond*e.header.ticksPerFrame);for(var h=0,p=t;h<p.length;h++){var d=p[h],y=d.tick-s;d.time=l+y*u,l=d.time,s=d.tick,"setTempo"===d.type&&(f=6e7/d.microsecondsPerBeat,e.header.ticksPerBeat&&(u=60/f/e.header.ticksPerBeat))}return t}(c),l=function(t){var r,n=[],i=new Map,c=new Map,u={},s=o(t);try{for(s.s();!(r=s.n()).done;){var l=r.value;if("noteOn"===l.type||"noteOff"===l.type){var f="".concat(l.channel,"-").concat(l.trackIndex,"-").concat(l.noteNumber);if("noteOn"===l.type){i.set(f,l);var h=c.get(f);h&&(n.push({deltaTime:l.deltaTime,tick:l.tick,time:l.time,channel:h.channel,noteNumber:h.noteNumber,trackIndex:h.trackIndex,type:"noteOff",velocity:h.velocity}),c.delete(f)),n.push(a({},l))}else i.delete(f),u[l.channel]?c.set(f,l):n.push(a({},l))}else if("controller"===l.type&&64===l.controllerType){var p=l.value>=64;if(!p&&u[l.channel]){var d,y=o(c);try{for(y.s();!(d=y.n()).done;){var I=e(d.value,2),w=I[0],m=I[1];m.channel!==l.channel||i.has(w)||(n.push({deltaTime:l.deltaTime,tick:l.tick,time:l.time,channel:m.channel,noteNumber:m.noteNumber,trackIndex:m.trackIndex,type:"noteOff",velocity:m.velocity}),c.delete(w))}}catch(e){y.e(e)}finally{y.f()}}u[l.channel]=p}else n.push(a({},l))}}catch(e){s.e(e)}finally{s.f()}var v,U=o(c);try{for(U.s();!(v=U.n()).done;){var b=e(v.value,2),g=(b[0],b[1]);n.push(a({},g))}}catch(e){U.e(e)}finally{U.f()}return n}(u),f=function(t){var r,n=(arguments.length>1&&void 0!==arguments[1]?arguments[1]:{}).fromMuseScore?12:2,i=[],c={},u={},s={},l={},f=[p,h,6,38],d={},y={},I=o(t);try{for(I.s();!(r=I.n()).done;){var w=r.value;if("controller"===w.type&&121===w.controllerType&&(l[w.channel]=n),"controller"===w.type&&f.includes(w.controllerType)){u[w.channel]||(u[w.channel]={}),u[w.channel][w.controllerType]=w.value;var m=!1;w.controllerType===p&&0===w.value?d[w.channel]=!0:w.controllerType===h&&0===w.value?y[w.channel]=!0:6===w.controllerType&&d[w.channel]?(d[w.channel]=!1,m=!0):38===w.controllerType&&y[w.channel]&&(y[w.channel]=!1,m=!0),m&&0===(u[w.channel][101]||0)&&0===(u[w.channel][100]||0)&&(l[w.channel]=(u[w.channel][6]||n)+(u[w.channel][38]||0)/100)}if("noteOn"===w.type||"noteOff"===w.type){var v=s[w.channel]||0,U=l[w.channel]||n,b=Math.round(v*U),g=w.noteNumber+b;i.push(a(a({},w),{},{noteNumber:g}));var k="".concat(w.trackIndex,"-").concat(w.noteNumber);c[w.channel]||(c[w.channel]=new Map),"noteOn"===w.type?c[w.channel].set(k,w):c[w.channel].delete(k)}else if("pitchBend"===w.type){var x=(s[w.channel]||0)*(l[w.channel]||n);"pitchBend"===w.type&&(s[w.channel]=w.value/8192);var S=(s[w.channel]||0)*(l[w.channel]||n),O=Math.round(x),M=Math.round(S);if(O!==M&&c[w.channel]){var P,T=o(c[w.channel]);try{for(T.s();!(P=T.n()).done;){var N=e(P.value,2),B=(N[0],N[1]);i.push({deltaTime:w.deltaTime,tick:w.tick,time:w.time,channel:B.channel,noteNumber:B.noteNumber+O,trackIndex:B.trackIndex,type:"noteOff",velocity:B.velocity}),i.push({deltaTime:w.deltaTime,tick:w.tick,time:w.time,channel:B.channel,noteNumber:B.noteNumber+M,trackIndex:B.trackIndex,type:"noteOn",velocity:B.velocity})}}catch(e){T.e(e)}finally{T.f()}}}else i.push(a({},w))}}catch(e){I.e(e)}finally{I.f()}return i}(l,n),d=function(e){var t,r=new Map,n=o(e);try{for(n.s();!(t=n.n()).done;){var a=t.value;if("noteOn"===a.type||"noteOff"===a.type){var i="".concat(a.trackIndex,"-").concat(a.channel,"-").concat(a.noteNumber),c=r.get(i)||[];if("noteOn"===a.type)c.push(a),r.set(i,c);else if(c.length>0){var u=c.pop();u.duration=a.time-u.time,0===c.length&&r.delete(i)}}}}catch(e){n.e(e)}finally{n.f()}return e}(f),y=d[d.length-1].time,I=new Map,w={},m=new Map,v=new Map,U=[];function b(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:0,t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:0,r=m.get("".concat(t,"-").concat(e)),n=v.get(t),a=void 0!==r?r:n||0,i="".concat(e,"-").concat(t,"-").concat(a),o=2===c.format?9===t||10===t:9===t;if(I.has(i))return I.get(i);var u={name:"",trackIndex:e,channel:t,instrument:a,isPercussion:o,notes:[]};return I.set(i,u),u}var g,k=o(d);try{for(k.s();!(g=k.n()).done;){var x=g.value;switch(x.type){case"noteOn":b(x.trackIndex,x.channel).notes.push({time:x.time,duration:x.duration,key:x.noteNumber,velocity:x.velocity});break;case"programChange":m.set("".concat(x.channel,"-").concat(x.trackIndex),x.programNumber),v.set(x.channel,x.programNumber);break;case"trackName":var S=x.text;w[x.trackIndex]=S;break;case"text":var O=x.text.match(/^@T(.*)$/);O&&U.push(O[1])}}}catch(e){k.e(e)}finally{k.f()}i=U.length>0?U.join(" - "):function(e){return e.replace(/[_]+/g," ").replace(/\.[a-zA-Z0-9]+$/,"").replace(/^(.)|\s+(.)/g,(function(e){return e.toUpperCase()}))}(r);var M=Array.from(I,(function(t){var r=e(t,2);return r[0],r[1]})).filter((function(e){return e.notes.length>0}));M.sort((function(e,t){return 1e6*e.trackIndex+1e3*e.channel+e.instrument<1e6*t.trackIndex+1e3*t.channel+t.instrument?-1:1}));var P,T=o(M);try{for(T.s();!(P=T.n()).done;){var N=P.value;N.name=w[N.trackIndex]||""}}catch(e){T.e(e)}finally{T.f()}return{title:i,duration:y,tracks:M}}(t,r,n),c="";c+="MUS8",c+=y(i.title),c+=d(16,1),c+=d(Math.ceil(i.duration),3);var u,l=[],I=o(i.tracks);try{for(I.s();!(u=I.n()).done;){var w=u.value,m={};w.isPercussion?m.instrument=w.instrument+128:m.instrument=w.instrument,m.isPercussion=w.isPercussion,m.channel=w.channel+1,m.name=w.name||"";var v,U=0,b=[],g=o(w.notes);try{for(g.s();!(v=g.n()).done;){var k=v.value,x=k.key;if(x>=0&&x<127){for(var S=k.time-U,O=Math.min(k.duration,1530),M="";S>f;)M+=d(255,1),S-=f,U+=f;var P=Math.round(240*S),T=P/240,N=Math.max(0,O+S-T),B=Math.floor(42.5*N),V=B>255&&x<127,j=V?128:0;b.push(M+d(x|j,1)+d(P,2)+d(B,V?2:1))}}}catch(e){g.e(e)}finally{g.f()}m.notes=b,l.push(m)}}catch(e){I.e(e)}finally{I.f()}if(l.length>255)throw"A song cannot have more than 255 tracks.";c+=d(l.length,1);for(var C=0,E=l;C<E.length;C++){var A=E[C];if(A.notes.length>65535)throw"A track cannot have more than 65535 notes.";c+=d(A.instrument,1),c+=d(A.channel,1),c+=d(A.notes.length,2)}for(var D=0,F=l;D<F.length;D++)c+=F[D].notes.join("");for(var R=0,q=l;R<q.length;R++)c+=y(q[R].name);return c}})(),n})()));
//# sourceMappingURL=musician-midi-converter.js.map