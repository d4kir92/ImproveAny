local _, ImproveAny = ...
local config_update = 0.3
function ImproveAny:InitIACoordsFrame()
	if ImproveAny:IsEnabled("IACoordsFrame", false) then
		IACoordsFrame = CreateFrame("Frame", "IACoordsFrame", UIParent)
		IACoordsFrame:SetSize(100, 20)
		IACoordsFrame:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 0)
		IACoordsFrame.coords = IACoordsFrame:CreateFontString("IACoordsFrame.coords", "BACKGROUND")
		IACoordsFrame.coords:SetPoint("CENTER", IACoordsFrame, "CENTER", 0, 0)
		IACoordsFrame.coords:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
		function ImproveAny:CoordsThink()
			local ok = xpcall(
				function()
					if ImproveAny.GetBestPosXY then
						local rawX, rawY = ImproveAny:GetBestPosXY("PLAYER")
						if rawX and rawY then
							local displayX = rawX * 100
							local displayY = rawY * 100
							IACoordsFrame.coords:SetText(format("|cff3FC7EB%0.1f, %0.1f", displayX, displayY))
						else
							IACoordsFrame.coords:SetText("")
						end
					end
				end, function(err) end
			)

			if not ok then
				IACoordsFrame.coords:SetText("")
			end

			ImproveAny:Debug("coords.lua: CoordsThink")
			ImproveAny:After(
				config_update,
				function()
					ImproveAny:CoordsThink()
				end, "CoordsThink"
			)
		end

		ImproveAny:CoordsThink()
	end
end
