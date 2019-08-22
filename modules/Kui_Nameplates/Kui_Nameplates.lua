Musician.KuiNamePlates = LibStub("AceAddon-3.0"):NewAddon("Musician.KuiNamePlates", "AceEvent-3.0")

local MODULE_NAME = "KuiNamePlates"
Musician.AddModule(MODULE_NAME)

local function updateKuiNameplate(f)
	local namePlate = f.parent
	Musician.NamePlates.AddNoteIcon(namePlate, f.NameText)
end

--- OnEnable
--
function Musician.KuiNamePlates:OnEnable()

	if Musician.NamePlates and KuiNameplates then

		Musician.Utils.Debug(MODULE_NAME, "Kui Nameplates detected.")

		hooksecurefunc(Musician.NamePlates, "UpdateNoteIcon", function(namePlate, player)
			if namePlate.kui and namePlate.kui.NameText then
				Musician.NamePlates.AddNoteIcon(namePlate, namePlate.kui.NameText)
			end
		end)

		if KuiNameplatesCore then
			hooksecurefunc(KuiNameplatesCore, "CreateNameText", function(self, f)
				hooksecurefunc(f, "UpdateNameText", updateKuiNameplate)
			end)

			hooksecurefunc(KuiNameplatesCore, "NameOnlySetNameTextToHealth", function(self, f)
				updateKuiNameplate(f)
			end)
		end

		-- Total RP 3 built-in module (1.7 and up)

		if AddOn_TotalRP3 and AddOn_TotalRP3.NamePlates and AddOn_TotalRP3.NamePlates.KuiDecoratorMixin then
			Musician.Utils.Debug(MODULE_NAME, "Total RP3 with built-in Kui module detected.")
			hooksecurefunc(AddOn_TotalRP3.NamePlates.KuiDecoratorMixin, "InitNamePlate", function(self, f)
				hooksecurefunc(f, "UpdateNameText", updateKuiNameplate)
			end)
		end

		-- Total RP 3: KuiNameplates (1.6)

		if TRP3_API and TRP3_API.module and TRP3_API.module.startModules then
			hooksecurefunc(TRP3_API.module, "startModules", function()
				local mod = KuiNameplates:GetPlugin('Total RP 3: KuiNameplates')
				if mod and mod.UpdateRPName then
					Musician.Utils.Debug(MODULE_NAME, "Total RP3 with external Kui module detected.")
					hooksecurefunc(mod, "UpdateRPName", function(self, f)
						updateKuiNameplate(f)
					end)
				end
			end)
		end

		-- Handle cinematic mode
		hooksecurefunc(Musician.NamePlates, "UpdateNamePlateCinematicMode", function(namePlate)
			if namePlate.kui then
				Musician.NamePlates.UpdateNamePlateCinematicMode(namePlate.kui)
				-- Refresh parent to fix layer ordering issues
				local parent = namePlate.kui:GetParent()
				namePlate.kui:SetParent(WorldFrame)
				namePlate.kui:SetParent(parent)
			end
		end)
	end
end
