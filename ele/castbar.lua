local _, ImproveAny = ...
local br = 0.068
local f = CreateFrame("FRAME")
f.update = 0.1
function ImproveAny:InitCastBar()
	local castbar = CastingBarFrame
	local height = 24
	if PlayerCastingBarFrame then
		castbar = PlayerCastingBarFrame
		height = 16
	end

	-- OLD CastBar
	if castbar then
		hooksecurefunc(
			castbar.Border,
			"Show",
			function(sel, ...)
				if true then
					sel:Hide()
				end
			end
		)

		if true then
			castbar.Border:Hide()
		end

		if true then
			castbar.Flash:SetParent(IAHIDDEN)
			if PlayerCastingBarFrame then
				castbar.Text:SetFont(STANDARD_TEXT_FONT, 10, "")
				castbar.Text:ClearAllPoints()
				castbar.Text:SetPoint("CENTER", castbar, "CENTER", 0, -14)
			else
				castbar.Text:SetFont(STANDARD_TEXT_FONT, 10, "")
				castbar.Text:ClearAllPoints()
				castbar.Text:SetPoint("CENTER", castbar, "CENTER", 0, 0)
			end

			castbar:SetHeight(height)
			castbar.Spark:SetHeight(height)
			castbar.Border:SetHeight(96)
			castbar.Border:ClearAllPoints()
			castbar.Border:SetPoint("CENTER", castbar, "CENTER", 0, 0)
			castbar.icon = castbar:CreateTexture(nil, "ARTWORK")
			castbar.icon:SetSize(height, height)
			castbar.icon:SetPoint("RIGHT", castbar, "LEFT", 0, 0)
			castbar.icon:SetTexCoord(br, 1 - br, br, 1 - br)
			castbar.timer = castbar:CreateFontString(nil)
			castbar.timer:SetFont(STANDARD_TEXT_FONT, 10, "")
			castbar.timer:SetPoint("CENTER", castbar, "RIGHT", 12, 0)
			castbar.update = 0
			castbar.tick = 0.01
			function ImproveAny:UpdateCastbarTimer()
				if castbar.timer ~= nil then
					if castbar.update and castbar.update < castbar.tick then
						local name, _, texture = nil, nil, nil
						if UnitCastingInfo ~= nil then
							name, _, texture = UnitCastingInfo("PLAYER")
						end

						if name == nil and UnitChannelInfo ~= nil then
							name, _, texture = UnitChannelInfo("PLAYER")
						end

						if CastingInfo ~= nil then
							name, _, texture = CastingInfo()
						end

						if name == nil and ChannelInfo ~= nil then
							name, _, texture = ChannelInfo()
						end

						if D4:GetWoWBuild() ~= "RETAIL" and texture == 136235 then
							texture = 136243 -- 136192
						end

						if castbar.icon ~= nil and castbar.icon:GetTexture() ~= texture then
							castbar.icon:SetTexture(texture)
						end

						if castbar.casting then
							castbar.timer:SetText(format("%2.1f", max(castbar.maxValue - castbar.value, 0)))
						elseif castbar.channeling then
							castbar.timer:SetText(format("%.1f", max(castbar.value, 0)))
						else
							castbar.timer:SetText("")
						end

						castbar.update = 0.1
					else
						castbar.update = castbar.update - castbar.tick
					end

					ImproveAny:Debug("castbar.lua: tick #1", "think")
					C_Timer.After(castbar.tick, ImproveAny.UpdateCastbarTimer)
				else
					ImproveAny:Debug("castbar.lua: tick #2")
					C_Timer.After(castbar.tick, 0.3)
				end
			end

			ImproveAny:UpdateCastbarTimer()
		end
	end
end