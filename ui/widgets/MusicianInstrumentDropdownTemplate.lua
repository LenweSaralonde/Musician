--- Instrument dropdown template
-- @module MusicianInstrumentDropdownTemplate

--- Return the colored name of the instrument
-- @param instrumentId (string)
-- @return instrumentName (string)
local function getColoredInstrumentName(instrumentId)
	local instrumentName = Musician.Msg.INSTRUMENT_NAMES[instrumentId]
	if Musician.INSTRUMENTS[instrumentId].color ~= nil then
		instrumentName = Musician.Utils.GetColorCode(unpack(Musician.INSTRUMENTS[instrumentId].color)) ..
			instrumentName .. "|r"
	end
	return instrumentName
end

--- OnLoad handler
-- @param self (DropdownButton)
function MusicianInstrumentDropdownTemplate_OnLoad(self)

	self.value = nil

	self.UpdateValue = function(value)
		local originalMidiId = value
		local instrumentId = Musician.Sampler.GetInstrumentName(originalMidiId)
		local midiId = Musician.INSTRUMENTS[instrumentId].midi
		self.value = midiId
		self.midiId = midiId
		self.instrumentId = instrumentId

		self:OverrideText(getColoredInstrumentName(instrumentId))
	end

	self.SetValue = function(value)
		self.UpdateValue(value)

		if self.OnChange then
			self.OnChange(self.midiId, self.instrumentId)
		end
	end

	local isSelected = function(midiId)
		return self.value == midiId
	end

	self.SetupScrollableMenu(function(_, rootDescription)
		for _, instrumentId in pairs(Musician.INSTRUMENTS_AVAILABLE) do
			local midiId = Musician.INSTRUMENTS[instrumentId].midi
			rootDescription:CreateRadio(getColoredInstrumentName(instrumentId), isSelected, self.SetValue, midiId)
		end
	end)
end
