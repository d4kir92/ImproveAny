local _, ImproveAny = ...
local textc = "|cFF00FF00" -- Colored
local textw = "|r" -- "WHITE"
local maxlevel = 60

function ImproveAny:GetMaxLevel()
	return maxlevel
end

local xpPerMobLevel = 0
local xpPerMob = 0
local xpPerMobs = {}

function ImproveAny:AddXPPerMob(xp)
	if xpPerMobLevel ~= UnitLevel("PLAYER") then
		xpPerMobLevel = UnitLevel("PLAYER")
		xpPerMobs = {}
	end

	xpPerMobs[xp] = true
	local c = 0
	local total = 0

	for i, v in pairs(xpPerMobs) do
		total = total + i
		c = c + 1
	end

	xpPerMob = total / c
end

function ImproveAny:GetXPPerMob()
	if xpPerMob > 0 then return xpPerMob end

	return 1
end

function ImproveAny:GetKillsToLevelUp()
	local currXP = UnitXP("PLAYER")
	local maxBar = UnitXPMax("PLAYER")
	local xpm = ImproveAny:GetXPPerMob()
	if xpm > 1 then return (maxBar - currXP) / xpm end

	return 0
end

local lastTotalXp = 0

function ImproveAny:GetQuestCompleteXP()
	if QuestLogFrame:IsShown() then return lastTotalXp end
	local totalXP = 0

	for i = 1, GetNumQuestLogEntries() do
		--local name = select(1, GetQuestLogTitle(i))
		local questID = select(8, GetQuestLogTitle(i))
		SelectQuestLogEntry(i)

		if IsQuestComplete(questID) then
			local xp = GetQuestLogRewardXP(questID)

			if xp then
				totalXP = totalXP + xp
			end
		end
	end

	lastTotalXp = totalXP

	return math.floor(totalXP)
end

function ImproveAny:InitXPBar()
	if ImproveAny:IsEnabled("XPBAR", false) then
		if QuestLogFrame then
			QuestLogFrame:Show()
			QuestLogFrame:Hide()
		end

		C_Timer.After(0.01, function()
			if GetQuestLogRewardXP == nil and GetRewardXP then
				local qaf = CreateFrame("FRAME")
				qaf:RegisterEvent("QUEST_ACCEPTED")
				qaf:RegisterEvent("QUEST_COMPLETE")
				qaf:RegisterEvent("QUEST_TURNED_IN")

				qaf:SetScript("OnEvent", function(sel, event, ...)
					if event == "QUEST_ACCEPTED" then
						local _, questID = ...
						local xp = GetRewardXP()

						if xp > 0 then
							IATAB["QUESTS"] = IATAB["QUESTS"] or {}
							IATAB["QUESTS"][questID] = xp
						end
					end

					C_Timer.After(0.01, function()
						if MainMenuBarExpText then
							MainMenuBarExpText:SetText(MainMenuBarExpText:GetText())
						end
					end)
				end)

				function ImproveAny:UpdateQAF()
					if MainMenuBarExpText then
						MainMenuBarExpText:SetText(MainMenuBarExpText:GetText())
					end

					C_Timer.After(1, ImproveAny.UpdateQAF)
				end

				ImproveAny:UpdateQAF()

				function GetQuestLogRewardXP(questID)
					if questID == nil then return nil end
					IATAB["QUESTS"] = IATAB["QUESTS"] or {}
					if IATAB["QUESTS"][questID] ~= nil then return IATAB["QUESTS"][questID] end
					local level = select(2, GetQuestLogTitle(questID))
					local gold = GetQuestLogRewardMoney(questID)

					if level and level == 0 then
						level = nil
					end

					if gold and gold == 0 then
						gold = nil
					end

					if level and gold then return gold * 3.75 * (level + 1) end

					return 0
				end
			end

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

				for sec = 1, 3 do
					C_Timer.After(sec, function()
						MainMenuBarExpText:Show()
					end)
				end
			end

			if ImproveAny:IsEnabled("XPHIDEARTWORK", false) then
				for nr = 0, 3 do
					local art = _G["MainMenuXPBarTexture" .. nr]

					if art then
						art:Hide()
					end
				end
			end

			if true then
				local frame = CreateFrame("Frame")
				frame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")

				if strfind(COMBATLOG_XPGAIN_FIRSTPERSON, "%1$s", 1, true) then
					COMBATLOG_XPGAIN_FIRSTPERSON = ImproveAny:ReplaceStr(COMBATLOG_XPGAIN_FIRSTPERSON, "%1$s", "%s")
				end

				if strfind(COMBATLOG_XPGAIN_FIRSTPERSON, "%2$d", 1, true) then
					COMBATLOG_XPGAIN_FIRSTPERSON = ImproveAny:ReplaceStr(COMBATLOG_XPGAIN_FIRSTPERSON, "%2$d", "%d")
				end

				local xpKillText = ImproveAny:ReplaceStr(ImproveAny:ReplaceStr(COMBATLOG_XPGAIN_FIRSTPERSON, "%s", "(.-)"), "%d", "(%d+)")

				frame:SetScript("OnEvent", function(sel, event, message, ...)
					-- Only if it is a kill
					if strfind(message, xpKillText) then
						local xpGained, xpGainedEx = message:match("(%d+)%D*(%d*)")
						xpGained = tonumber(xpGained)

						if xpGained then
							if xpGainedEx then
								xpGainedEx = tonumber(xpGainedEx)
								ImproveAny:AddXPPerMob(xpGained)
							else
								ImproveAny:AddXPPerMob(xpGained)
							end
						end
					end
				end)
			end

			if MainMenuExpBar then
				local _, sh = MainMenuExpBar:GetSize()
				MainMenuExpBar.qcx = MainMenuExpBar:CreateTexture(nil, "ARTWORK")
				MainMenuExpBar.qcx:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
				MainMenuExpBar.qcx:SetVertexColor(0.66, 0.66, 1, 0.33)
				MainMenuExpBar.qcx:SetDrawLayer("ARTWORK", 1)
				MainMenuExpBar.qcx:SetSize(1, sh)
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
					local questCompleteXP = ImproveAny:GetQuestCompleteXP()
					local text2 = ""

					if ImproveAny:IsEnabled("XPLEVEL", false) then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. LEVEL .. ": " .. textc .. UnitLevel("PLAYER") .. textw .. "/" .. textc .. ImproveAny:GetMaxLevel() .. textw
					end

					if ImproveAny:IsEnabled("XPNUMBER", false) then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. XP .. ": " .. textc .. ImproveAny:FormatValue(currXP) .. textw .. "/" .. textc .. ImproveAny:FormatValue(maxBar)
					end

					if ImproveAny:IsEnabled("XPPERCENT", false) then
						if ImproveAny:IsEnabled("XPNUMBER", false) then
							if text2 ~= "" then
								text2 = text2 .. textw .. " ("
							end
						else
							if text2 ~= "" then
								text2 = text2 .. "    "
							end
						end

						text2 = text2 .. textc .. format("%.2f", percent) .. textw .. "%"

						if ImproveAny:IsEnabled("XPNUMBER", false) and text2 ~= "" then
							text2 = text2 .. textw .. ")"
						end
					end

					if ImproveAny:IsEnabled("XPEXHAUSTION", false) and GetXPExhaustion() and GetXPExhaustion() >= 0 then
						local eper = GetXPExhaustion() / maxBar
						local epercent = eper * 100

						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. textw .. TUTORIAL_TITLE26 .. ": " .. textc .. ImproveAny:FormatValue(GetXPExhaustion()) .. " " .. textw .. "(" .. textc .. format("%.2f", epercent) .. "%" .. textw .. ")"
					end

					if ImproveAny:IsEnabled("XPMISSING", false) then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. ADDON_MISSING .. ": " .. textc .. ImproveAny:FormatValue(missingXp) .. textw .. " (" .. textc .. format("%.2f", percent2) .. "%" .. textw .. ")"
					end

					if MainMenuExpBar and MainMenuExpBar.qcx then
						local sw, _ = MainMenuExpBar:GetSize()
						local px = currXP / maxBar * sw
						local wi = questCompleteXP / maxBar * sw

						if wi <= 1 then
							MainMenuExpBar.qcx:Hide()
						else
							if px + wi > sw then
								wi = sw - px
							end

							if ImproveAny:IsEnabled("XPQUESTCOMPLETE", false) then
								MainMenuExpBar.qcx:SetPoint("LEFT", MainMenuExpBar, "LEFT", px, 0)
								MainMenuExpBar.qcx:SetWidth(wi)
								MainMenuExpBar.qcx:Show()
							else
								MainMenuExpBar.qcx:Hide()
							end
						end
					end

					if ImproveAny:IsEnabled("XPQUESTCOMPLETE", false) and questCompleteXP > 0 then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. QUEST_COMPLETE .. "-" .. XP .. ": " .. textc .. questCompleteXP .. textw
					end

					if ImproveAny:IsEnabled("XPKILLSTOLEVELUP", false) then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						local kpm = ImproveAny:GetKillsToLevelUp()

						if kpm > 0 then
							text2 = text2 .. format(QUICKBUTTON_NAME_KILLS .. ": " .. textc .. "%0.1f" .. textw, kpm)
						else
							text2 = text2 .. format(QUICKBUTTON_NAME_KILLS .. ": " .. textc .. UNKNOWN .. textw, kpm)
						end
					end

					sel:SetText(text2)

					if MainMenuExpBar.show then
						sel:Show()
					end

					sel.iasettext = false
				end)

				hooksecurefunc(MainMenuBarExpText, "Hide", function(sel, text)
					if MainMenuExpBar.show then
						sel:Show()
					end
				end)

				hooksecurefunc(MainMenuBarExpText, "Show", function(sel, text)
					if not MainMenuExpBar.show then
						sel:Hide()
					end
				end)

				MainMenuBarExpText:SetText("LOADING")
			end
		end)
	end
end