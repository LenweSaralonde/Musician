--- Instrument dropdown template
-- @module MusicianInstrumentDropdownTemplate

--- OnLoad handler
-- @param self (Frame)
function MusicianInstrumentDropdownTemplate_OnLoad(self)

	MSA_DropDownMenu_SetWidth(self, 115)

	self.value = nil

	self.UpdateValue = function(value)
		local originalMidiId = value
		local instrumentId = Musician.Sampler.GetInstrumentName(originalMidiId)
		local midiId = Musician.INSTRUMENTS[instrumentId].midi
		local instrumentName = Musician.Msg.INSTRUMENT_NAMES[instrumentId]
		self.value = midiId
		self.midiId = midiId
		self.instrumentId = instrumentId

		if Musician.INSTRUMENTS[instrumentId].color ~= nil then
			instrumentName = Musician.Utils.GetColorCode(unpack(Musician.INSTRUMENTS[instrumentId].color)) .. instrumentName .. "|r"
		end

		MSA_DropDownMenu_SetText(self, instrumentName)
	end

	self.SetValue = function(value)
		self.UpdateValue(value)

		if self.OnChange then
			self.OnChange(self.midiId, self.instrumentId)
		end
	end

	self.OnClick = function(_, value)
		self.SetValue(value)
	end

	self.GetItems = function()
		local info = MSA_DropDownMenu_CreateInfo()
		info.func = self.OnClick

		for _, instrumentId in pairs(Musician.INSTRUMENTS_AVAILABLE) do
			local midiId = Musician.INSTRUMENTS[instrumentId].midi
			info.text = Musician.Msg.INSTRUMENT_NAMES[instrumentId]
			info.arg1 = midiId
			info.checked = self.value == midiId
			if Musician.INSTRUMENTS[instrumentId].color ~= nil then
				info.colorCode = Musician.Utils.GetColorCode(unpack(Musician.INSTRUMENTS[instrumentId].color))
			end
			MSA_DropDownMenu_AddButton(info)
		end
	end

	MSA_DropDownMenu_Initialize(self, self.GetItems)
end
