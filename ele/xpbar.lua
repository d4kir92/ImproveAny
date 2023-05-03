local _, ImproveAny = ...
local textc = "|cFF00FF00" -- Colored
local textw = "|r" -- "WHITE"
local maxlevel = 60

function ImproveAny:GetMaxLevel()
	return maxlevel
end

function ImproveAny:InitXPBar()
	if ImproveAny:IsEnabled("XPBAR", true) then
		C_Timer.After(0.01, function()
			if ImproveAny:GetWoWBuild() == "TBC" then
				maxlevel = 70
			end

			if ImproveAny:GetWoWBuild() == "WRATH" then
				maxlevel = 80
			end

			if GetMaxLevelForPlayerExpansion then
				maxlevel = GetMaxLevelForPlayerExpansion()
			end

			if MainMenuExpBar then
				MainMenuExpBar:SetHeight(15)
				MainMenuExpBar.show = true

				MainMenuExpBar:HookScript("OnEnter", function(sel)
					MainMenuExpBar.show = false
					MainMenuBarExpText:Hide()
				end)

				MainMenuExpBar:HookScript("OnLeave", function(sel)
					MainMenuExpBar.show = true
					MainMenuBarExpText:Show()
				end)

				for i = 1, 3 do
					C_Timer.After(i, function()
						MainMenuBarExpText:Show()
					end)
				end
			end

			if ImproveAny:IsEnabled("XPHIDEARTWORK", false) then
				for i = 0, 3 do
					local art = _G["MainMenuXPBarTexture" .. i]

					if art then
						art:Hide()
					end
				end
			end

			if MainMenuExpBar and MainMenuBarExpText then
				local fontName, _, fontFlags = MainMenuBarExpText:GetFont()
				MainMenuBarExpText:SetFont(fontName, 12, fontFlags)
				MainMenuBarExpText:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 1)

				hooksecurefunc(MainMenuBarExpText, "SetText", function(sel, text)
					if sel.iasettext then return end
					sel.iasettext = true
					local currXP = UnitXP("PLAYER")
					local maxBar = UnitXPMax("PLAYER")

					if maxBar == 0 then
						sel.iasettext = false

						return
					end

					if GameLimitedMode_IsActive() then
						local rLevel = GetRestrictedAccountData()

						if UnitLevel("player") >= rLevel then
							currXP = UnitTrialXP("player")
						end
					end

					local per = currXP / maxBar
					local percent = per * 100
					local missingXp = maxBar - currXP
					local percent2 = missingXp / maxBar * 100
					local text2 = ""

					if ImproveAny:IsEnabled("XPLEVEL", false) then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. LEVEL .. ": " .. textc .. UnitLevel("PLAYER") .. textw .. "/" .. textc .. ImproveAny:GetMaxLevel() .. textw
					end

					if ImproveAny:IsEnabled("XPNUMBER", true) then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. XP .. ": " .. textc .. ImproveAny:FormatValue(currXP) .. textw .. "/" .. textc .. ImproveAny:FormatValue(maxBar)
					end

					if ImproveAny:IsEnabled("XPPERCENT", true) then
						if ImproveAny:IsEnabled("XPNUMBER", true) then
							if text2 ~= "" then
								text2 = text2 .. textw .. " ("
							end
						else
							if text2 ~= "" then
								text2 = text2 .. "    "
							end
						end

						text2 = text2 .. textc .. format("%.2f", percent) .. textw .. "%"

						if ImproveAny:IsEnabled("XPNUMBER", true) and text2 ~= "" then
							text2 = text2 .. textw .. ")"
						end
					end

					if ImproveAny:IsEnabled("XPEXHAUSTION", true) and GetXPExhaustion() and GetXPExhaustion() >= 0 then
						local eper = GetXPExhaustion() / maxBar
						local epercent = eper * 100

						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. textw .. TUTORIAL_TITLE26 .. ": " .. textc .. ImproveAny:FormatValue(GetXPExhaustion()) .. " " .. textw .. "(" .. textc .. format("%.2f", epercent) .. "%" .. textw .. ")"
					end

					if ImproveAny:IsEnabled("XPMISSING", true) then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. ADDON_MISSING .. ": " .. textc .. ImproveAny:FormatValue(missingXp) .. textw .. " (" .. textc .. format("%.2f", percent2) .. "%" .. textw .. ")"
					end

					sel:SetText(text2)

					if MainMenuExpBar.show then
						sel:Show()

						C_Timer.After(0.1, function()
							sel:Show()
						end)
					end

					sel.iasettext = false
				end)

				MainMenuBarExpText:SetText("LOADING")
			end
		end)
	end
end