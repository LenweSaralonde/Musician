Musician.KuiNamePlates = LibStub("AceAddon-3.0"):NewAddon("Musician.KuiNamePlates", "AceEvent-3.0")

local MODULE_NAME = "KuiNamePlates"
Musician.AddModule(MODULE_NAME)

--- OnEnable
--
function Musician.KuiNamePlates:OnEnable()

	if KuiNameplates then
		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate, player)
			if namePlate.kui and namePlate.kui.NameText then
				Musician.NamePlates.AppendNoteIcon(namePlate, namePlate.kui.NameText)
			end
		end)

		-- Total RP 3: KuiNameplates
		if TRP3_API and TRP3_API.module and TRP3_API.module.startModules then
			hooksecurefunc(TRP3_API.module, "startModules", function()
				local mod = KuiNameplates:GetPlugin('Total RP 3: KuiNameplates')
				if mod and mod.UpdateRPName then
					hooksecurefunc(mod, "UpdateRPName", function(self, f)
						local namePlate = f.parent
						Musician.NamePlates.AppendNoteIcon(namePlate, f.NameText)
					end)
				end
			end)
		end

	end

	if KuiNameplatesCore then

		hooksecurefunc(KuiNameplatesCore, "CreateNameText", function(self, f)
			hooksecurefunc(f, "UpdateNameText", function(f)
				local namePlate = f.parent
				Musician.NamePlates.AppendNoteIcon(namePlate, f.NameText)
			end)
		end)

		hooksecurefunc(KuiNameplatesCore, "NameOnlySetNameTextToHealth", function(self, f)
			local namePlate = f.parent
			Musician.NamePlates.AppendNoteIcon(namePlate, f.NameText)
		end)

	end
end
