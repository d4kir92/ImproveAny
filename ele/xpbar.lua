local _, ImproveAny = ...
local textc = "|cFF00FF00" -- Colored
local textw = "|r" -- "WHITE"
local maxlevel = 60

function ImproveAny:GetMaxLevel()
	return maxlevel
end

local XPS = 0

function ImproveAny:GetXPPerSec()
	return XPS
end

local XPH = 0

function ImproveAny:GetXPPerHour()
	return XPH
end

local HOUR = ImproveAny:ReplaceStr(COOLDOWN_DURATION_HOURS, "%d ", "")
HOUR = ImproveAny:ReplaceStr(HOUR, "%d", "")
local inCombat = false
local f = CreateFrame("FRAME")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")

f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
	elseif event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
	end
end)

local ts = 0
local totalxp = 0
local lastxp = UnitXP("PLAYER")

function ImproveAny:XPPerHourLoop()
	if inCombat or true then
		ts = ts + 0.2
	end

	local curxp = UnitXP("PLAYER")
	local curxpmax = UnitXPMax("PLAYER")
	local gainedxp = 0

	if curxp > lastxp then
		-- Gained Xp
		gainedxp = curxp - lastxp
	elseif curxp < lastxp then
		-- Gained Xp + Levelup
		--gainedxp = lastxpmax - lastxp + curxp
		ts = 0
		totalxp = 0
	end

	if gainedxp > 0 then
		totalxp = totalxp + gainedxp
	end

	lastxp = curxp
	lastxpmax = curxpmax

	if curxpmax ~= 0 and ts > 0 then
		local xps = totalxp / ts
		local xpm = xps * 60
		local xph = xpm * 60
		XPS = xps
		XPH = xph

		if MainMenuBarExpText then
			MainMenuBarExpText:SetText(MainMenuBarExpText:GetText() or "LOADING")
		end

		if MainMenuExpBar and MainMenuExpBar.xph then
			local sw, _ = MainMenuExpBar:GetSize()
			local px = curxp / curxpmax * sw
			local wi = xph / curxpmax * sw

			if wi <= 0 then
				wi = 1
			end

			if px + wi > sw then
				wi = sw - px
			end

			if ImproveAny:IsEnabled("XPXPPERHOUR", true) then
				MainMenuExpBar.xph:SetPoint("LEFT", MainMenuExpBar, "LEFT", px, 0)
				MainMenuExpBar.xph:SetWidth(wi)
				MainMenuExpBar.xph:Show()
			else
				MainMenuExpBar.xph:Hide()
			end
		end
	end

	C_Timer.After(0.2, ImproveAny.XPPerHourLoop)
end

function ImproveAny:InitXPBar()
	if ImproveAny:IsEnabled("XPBAR", true) then
		C_Timer.After(1, function()
			lastxp = UnitXP("PLAYER")
			lastxpmax = UnitXPMax("PLAYER")
			ImproveAny:XPPerHourLoop()
		end)

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
			end

			if ImproveAny:IsEnabled("XPHIDEARTWORK", false) then
				for i = 0, 3 do
					local art = _G["MainMenuXPBarTexture" .. i]

					if art then
						art:Hide()
					end
				end
			end

			if MainMenuExpBar then
				local _, sh = MainMenuExpBar:GetSize()
				MainMenuExpBar.xph = MainMenuExpBar:CreateTexture(nil, "ARTWORK")
				MainMenuExpBar.xph:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
				MainMenuExpBar.xph:SetVertexColor(1, 1, 0.5, 0.5)
				MainMenuExpBar.xph:SetDrawLayer("ARTWORK", 1)
				MainMenuExpBar.xph:SetSize(1, sh)
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

					local xps = ImproveAny:GetXPPerSec()
					local xph = ImproveAny:GetXPPerHour()
					local per = currXP / maxBar
					local percent = per * 100
					local missingXp = maxBar - currXP
					local percent2 = missingXp / maxBar * 100
					local xplu = 0

					if xps > 0 then
						xplu = missingXp / xps -- XP to  level up
					end

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

					if ImproveAny:IsEnabled("XPXPPERHOUR", true) then
						if text2 ~= "" then
							text2 = text2 .. " "
						end

						text2 = text2 .. textc .. string.format(SecondsToTime(xplu)) .. textw
					end

					if ImproveAny:IsEnabled("XPXPPERHOUR", true) and xph > 0 then
						text2 = text2 .. "    " .. textc .. ImproveAny:FormatValue(xph, xph <= 5000 and 1 or 0) .. textw .. " " .. textw .. XP .. "/" .. HOUR
					end

					sel:SetText(text2)

					if MainMenuExpBar.show then
						sel:Show()
					end

					sel.iasettext = false
				end)

				MainMenuBarExpText:SetText("LOADING")
			end
		end)
	end
end