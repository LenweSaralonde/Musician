

MusicianFrame.Init = function()
	MusicianFrame.Refresh()
	Musician:RegisterMessage(Musician.Events.RefreshFrame, MusicianFrame.Refresh)
	MusicianFrameSource:SetText(Musician.Msg.PASTE_MUSIC_CODE)
	MusicianFrameTitle:SetText(Musician.Msg.PLAY_A_SONG)
	MusicianFrameClearButton:SetText(Musician.Msg.CLEAR)
end

MusicianFrame.Test = function()
	if Musician.testSongIsPlaying then
		Musician.StopTestSong()
	else
		local success = pcall(function()
			local testSong = Musician.Utils.UnpackSong(MusicianBase64.decode(MusicianFrameSource:GetText()))
			C_Timer.After(0.1, function()
				Musician.PlayTestSong(testSong)
			end)
		end)

		if not(success) then
			Musician.Utils.Error(Musician.Msg.INVALID_MUSIC_CODE)
		end
	end
end

MusicianFrame.Load = function()
	if not(Musician.Comm.isSending) then
		local success = pcall(function()
			local songData = Musician.Utils.UnpackSong(MusicianBase64.decode(MusicianFrameSource:GetText()))
			Musician.Comm.BroadcastSong(songData)
		end)

		if not(success) then
			Musician.Utils.Error(Musician.Msg.INVALID_MUSIC_CODE)
		end
	end
end

MusicianFrame.Play = function()
	if Musician.songIsPlaying then
		Musician.Comm.StopSong()
	else
		Musician.Comm.PlaySong()
	end
end

MusicianFrame.Escape = function()
	if MusicianFrameSource:HasFocus() then
		MusicianFrameSource:ClearFocus()
	else
		MusicianFrame:Hide()
	end
end

MusicianFrame.Refresh = function()

	local editBoxIsEmpty = MusicianFrameSource:GetText() == Musician.Msg.PASTE_MUSIC_CODE or string.len(MusicianFrameSource:GetText()) == 0

	-- Test song button
	if editBoxIsEmpty and not(Musician.testSongIsPlaying) then
		MusicianFrameTestButton:Disable()
	else
		MusicianFrameTestButton:Enable()
	end

	if Musician.testSongIsPlaying then
		MusicianFrameTestButton:SetText(Musician.Msg.STOP_TEST)
	else
		MusicianFrameTestButton:SetText(Musician.Msg.TEST_SONG)
	end

	-- Load button
	if editBoxIsEmpty or Musician.Comm.isSending then
		MusicianFrameLoadButton:Disable()
	else
		MusicianFrameLoadButton:Enable()
	end

	if Musician.Comm.isSending then

		if MusicianFrame.LoadingSpinner == nil then
			MusicianFrameLoadButton:SetText(Musician.Msg.LOADING)

			local dots = 1
			MusicianFrame.LoadingSpinner = C_Timer.NewTicker(.25, function()
				if Musician.Comm.isSending then
					MusicianFrameLoadButton:SetText(Musician.Msg.LOADING .. string.rep('.', dots) .. string.rep(' ', 3 - dots))
					dots = (dots + 1) % 4
				else
					MusicianFrame.LoadingSpinner:Cancel()
					MusicianFrame.LoadingSpinner = nil
					MusicianFrame.Refresh()
				end
			end)

		end
	else
		if MusicianFrame.LoadingSpinner ~= nil then
			MusicianFrame.LoadingSpinner:Cancel()
			MusicianFrame.LoadingSpinner = nil
		end

		MusicianFrameLoadButton:SetText(Musician.Msg.LOAD)
	end

	-- Play button
	if Musician.Comm.isPlaySent or Musician.Comm.isStopSent or not(Musician.Comm.SongIsLoaded()) and not(Musician.songIsPlaying) then
		MusicianFramePlayButton:Disable()
	else
		MusicianFramePlayButton:Enable()
	end

	if Musician.songIsPlaying then
		MusicianFramePlayButton:SetText(Musician.Msg.STOP)
	else
		MusicianFramePlayButton:SetText(Musician.Msg.PLAY)
	end
end

						