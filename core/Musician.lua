Musician = LibStub("AceAddon-3.0"):NewAddon("Musician")

function Musician:OnInitialize()
	Musician.Utils.Print(string.gsub(Musician.Msg.STARTUP, "{version}", Musician.Utils.Highlight(GetAddOnMetadata("Musician", "Version"))))

	Musician.songs = {}
	Musician.testSong = nil

	Musician.songIsPlaying = false
	Musician.testSongIsPlaying = false

	Musician.Comm.Init()
	Musician.Registry.Init()

	C_Timer.NewTicker(0.5, Musician.Utils.MuteGameMusic)

	MusicianFrame.Init()

	-- /musician command
	SlashCmdList["MUSICIAN"] = function(cmd)

		cmd = strlower(strtrim(cmd))

		-- Stop all music currently playing
		if cmd == "stop" or cmd == "panic" then

			Musician.StopTestSong()

			local song, player
			for player, song in pairs(Musician.songs) do
				if song.playing then
					Musician.Utils.StopSong(song.playing)
					Musician.songs[player].playing = nil
				end
			end

			-- Show main window
		elseif cmd == "show" or cmd == "" then
			MusicianFrame:Show()
			MusicianFrameSource:SetFocus()
		end
	end

	SLASH_MUSICIAN1 = "/musician"
	SLASH_MUSICIAN2 = "/music"
	SLASH_MUSICIAN3 = "/mus"

	-- /stopmusic command
	SlashCmdList["STOPMUSIC"] = function()
		SlashCmdList["MUSICIAN"]("stop")
	end

	SLASH_STOPMUSIC1 = "/stopmusic"
	SLASH_STOPMUSIC2 = "/stopmus"
	SLASH_STOPMUSIC3 = "/musicstop"
	SLASH_STOPMUSIC4 = "/musstop"
end

--- Play a song, locally
-- @param songData (table)
function Musician.PlayTestSong(songData)
	if Musician.testSongIsPlaying then
		Musician.StopTestSong()
	end

	Musician.testSongIsPlaying = true
	Musician.Utils.MuteGameMusic()

	Musician.testSong = songData
	local duration = Musician.Utils.PlaySong(Musician.testSong, Musician.PLAY_PREROLL)

	-- Remove song currently playing when finished
	Musician.testSong.endTimer = C_Timer.NewTimer(duration, function()
		Musician.testSong = nil
		Musician.testSongIsPlaying = false
		Musician.Utils.MuteGameMusic()
		Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
	end)

	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
end

--- Stop song test
--
function Musician.StopTestSong()
	if Musician.testSong then
		Musician.Utils.StopSong(Musician.testSong)
		Musician.testSong = nil
		Musician.testSongIsPlaying = false
		Musician.Utils.MuteGameMusic()
	end

	Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
end

--- Play a song loaded by a player
-- @param playerName (string)
function Musician.PlayLoadedSong(playerName)
	if Musician.songs[playerName] ~= nil and Musician.songs[playerName].received ~= nil then
		Musician.StopLoadedSong(playerName)
		Musician.songs[playerName].playing = Musician.songs[playerName].received
		Musician.songs[playerName].received = nil
		Musician.Utils.MuteGameMusic()

		local duration = Musician.Utils.PlaySong(Musician.songs[playerName].playing, Musician.PLAY_PREROLL)

		-- Remove song currently playing when finished
		Musician.songs[playerName].playing.endTimer = C_Timer.NewTimer(duration, function()
			Musician.songs[playerName].playing = nil

			-- Stop broadcasting my position if the song is initiated by myself
			if playerName == Musician.Utils.NormalizePlayerName(UnitName("player")) then
				Musician.Comm.StopPositionUpdate()
				Musician.songIsPlaying = false
				Musician.Comm:SendMessage(Musician.Events.RefreshFrame)
			end

			Musician.Utils.MuteGameMusic()
		end)
	end
end

--- Stop a song loaded by a player
-- @param playerName (string)
function Musician.StopLoadedSong(playerName)
	if Musician.songs[playerName] ~= nil and Musician.songs[playerName].playing ~= nil then
		Musician.Utils.StopSong(Musician.songs[playerName].playing)
		Musician.songs[playerName].playing = nil
		Musician.Utils.MuteGameMusic()
	end
end

