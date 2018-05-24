Musician.INSTRUMENTS = {
	["none"] = {
		["midi"] = -1
	},
	["bagpipe"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bagpipe",
		["decay"] = 100,
		["isPercussion"] = false,
		["midi"] = 109
	},
	["bassoon"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bassoon",
		["decay"] = 150,
		["isPercussion"] = false,
		["midi"] = 70
	},
	["cello"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\cello",
		["decay"] = 100,
		["isPercussion"] = false,
		["midi"] = 42
	},
	["clarinet"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\clarinet",
		["decay"] = 150,
		["isPercussion"] = false,
		["midi"] = 71
	},
	["dulcimer"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\dulcimer",
		["decay"] = 500,
		["isPercussion"] = false,
		["isPlucked"] = true,
		["midi"] = 15
	},
	["female-voice"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\female-voice",
		["decay"] = 200,
		["isPercussion"] = false,
		["midi"] = 53
	},
	["male-voice"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\male-voice",
		["decay"] = 200,
		["isPercussion"] = false,
		["midi"] = 52
	},
	["fiddle"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\fiddle",
		["decay"] = 100,
		["isPercussion"] = false,
		["midi"] = 110
	},
	["harp"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\harp",
		["decay"] = 500,
		["isPercussion"] = false,
		["isPlucked"] = true,
		["midi"] = 46
	},
	["lute"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\lute",
		["decay"] = 100,
		["isPercussion"] = false,
		["isPlucked"] = true,
		["midi"] = 24
	},
	["recorder"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\recorder",
		["decay"] = 150,
		["isPercussion"] = false,
		["midi"] = 74
	},
	["trombone"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\trombone",
		["decay"] = 150,
		["isPercussion"] = false,
		["midi"] = 57
	},
	["trumpet"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\trumpet",
		["decay"] = 150,
		["isPercussion"] = false,
		["midi"] = 56
	},
	["percussions"] = {
		["midi"] = 128
	},

	-- Percussion
	["clap"] = {
		["pathFunc"] = function() return "Sound\\Character\\EmoteClap" .. (floor(math.random() * 7) + 1) end, -- EmoteClap1 - 7
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-crash-long1"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long1",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-crash-long2"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-long2",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-crash-short1"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short1",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-crash-short2"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short2",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-crash-short-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\crash-short-hi",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-hit1"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit1",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-hit2"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\hit2",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-shake-long"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-long",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["tambourine-shake-short"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\tambourine\\shake-short",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["rattle-egg"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\rattle-egg\\rattle-egg",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-bassdrum-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-hi",
		["decay"] = 250,
		["isPercussion"] = true
	},
	["bodhran-bassdrum-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\bassdrum-low",
		["decay"] = 250,
		["isPercussion"] = true,
		["midi"] = 47
	},
	["bodhran-guiro-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-hi",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-guiro-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\guiro-low",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-roll-bassdrum"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-bassdrum",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-roll-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-hi",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-roll-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll-low",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-roll"] = {
		["pathFunc"] = function() return "Interface\\AddOns\\Musician\\instruments\\bodhran\\roll" .. (floor(math.random() * 3) + 1) end, -- roll1 - 3
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-snare-long-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-hi",
		["decay"] = 100,
		["isPercussion"] = true,
		["midi"] = 117
	},
	["bodhran-snare-long-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-low",
		["decay"] = 100,
		["isPercussion"] = true,
		["midi"] = 118
	},
	["bodhran-snare-long-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-long-med",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-snare-short-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-hi",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-snare-short-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\snare-short-low",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-stick-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-hi",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-stick-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-low",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-stick-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\stick-med",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-tom-long-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-hi",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-tom-long-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-low",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-tom-long-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-long-med",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-tom-short-hi"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-hi",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-tom-short-low"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-low",
		["decay"] = 100,
		["isPercussion"] = true
	},
	["bodhran-tom-short-med"] = {
		["path"] = "Interface\\AddOns\\Musician\\instruments\\bodhran\\tom-short-med",
		["decay"] = 100,
		["isPercussion"] = true
	},
}


Musician.INSTRUMENTS_AVAILABLE = {
	"lute",
	"recorder",
	"harp",
	"dulcimer",
	"bagpipe",
	"fiddle",
	"cello",
	"male-voice",
	"female-voice",
	"trumpet",
	"trombone",
	"clarinet",
	"bassoon",
	"bodhran-bassdrum-low",
	"bodhran-snare-long-hi",
	"bodhran-snare-long-low",
	"percussions",
	"none",
}
