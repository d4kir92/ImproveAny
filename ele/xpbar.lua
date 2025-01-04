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
	local oldQuestId = QuestLogFrame.selectedButtonID
	local totalXP = 0
	for i = 1, QUESTS_DISPLAYED do
		local questIndex = i + FauxScrollFrame_GetOffset(_G["QuestLogListScrollFrame"])
		local _, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(questIndex)
		if not isHeader then
			SelectQuestLogEntry(i)
			local xp = GetQuestLogRewardXP(questID)
			if xp and xp > 0 then
				IATAB["QUESTS"] = IATAB["QUESTS"] or {}
				IATAB["QUESTS"][questID] = xp
				if IsQuestComplete(questID) then
					totalXP = totalXP + xp
				end
			end
		end
	end

	lastTotalXp = totalXP
	SelectQuestLogEntry(oldQuestId)

	return math.floor(totalXP)
end

local function AddText(text, bNum, bPer, str, vNum, vNumMax, bDecimals, color)
	local res = ""
	if ImproveAny:IsEnabled(bNum, false) or (bPer and ImproveAny:IsEnabled(bPer, false)) then
		if text ~= "" then
			res = res .. "    "
		end

		local num = "%d"
		if bDecimals then
			num = "%0.1f"
		end

		local col1 = textw
		local col2 = textc
		if color then
			col1 = color
			col2 = textw .. textc
		end

		if vNum and vNum ~= 0 or vNumMax and vNumMax > 0 then
			if vNumMax and vNumMax > 0 then
				if ImproveAny:IsEnabled(bNum, false) and (bPer and ImproveAny:IsEnabled(bPer, false)) then
					res = res .. format("%s%s: %s%d%s/%s%d%s (%s%0.1f%s%%)", col1, str, col2, vNum, textw, textc, vNumMax, textw, textc, vNum / vNumMax * 100, textw)
				elseif bPer and ImproveAny:IsEnabled(bPer, false) then
					res = res .. format("%s%s: %s%0.1f%s%%", col1, str, col2, vNum / vNumMax * 100, textw)
				elseif ImproveAny:IsEnabled(bNum, false) then
					res = res .. format("%s%s: %s%d%s/%s%d", col1, str, col2, vNum, textw, textc, vNumMax, textw)
				end
			else
				if ImproveAny:IsEnabled(bNum, false) then
					res = res .. format("%s%s: %s" .. num .. "%s", col1, str, col2, vNum, textw)
				end
			end
		elseif ImproveAny:IsEnabled("XPHIDEUNKNOWNVALUES", false) == false then
			res = res .. format("%s%s: %s%s", col1, str, col2, UNKNOWN, textw)
		end
	end

	return res
end

local questlogWarning = false
function ImproveAny:UpdateQuestFrame()
	if not questlogWarning and LeaPlusDB and LeaPlusDB["EnhanceQuestLevels"] and LeaPlusDB["EnhanceQuestLevels"] == "On" then
		ImproveAny:MSG("LeatrixPlus \"EnhanceQuestLevels\" is enabled, may break QuestLog")
		questlogWarning = true
	end

	for i = 1, QUESTS_DISPLAYED do
		local questIndex = i + FauxScrollFrame_GetOffset(_G["QuestLogListScrollFrame"])
		local questNormalText = nil
		local questLogTitleText, lvl, questTag, isHeader, _, isComplete, _, questID = GetQuestLogTitle(questIndex)
		local rewardXP = ImproveAny:GetQuestLogRewardXP(questID)
		if not isHeader and rewardXP then
			local questTitleTag = _G["QuestLogTitle" .. i .. "Tag"]
			local questTitleCheck = _G["QuestLogTitle" .. i .. "Check"]
			local questTitleGroupMates = _G["QuestLogTitle" .. i .. "GroupMates"]
			if questTitleCheck then
				questTitleCheck:ClearAllPoints()
				questTitleCheck:SetPoint("RIGHT", questTitleTag, "LEFT", 0, 0)
			end

			if questTitleGroupMates then
				questTitleGroupMates:ClearAllPoints()
				questTitleGroupMates:SetPoint("LEFT", _G["QuestLogTitle" .. i], "LEFT", 0, 0)
			end

			if questTitleTag then
				local questTitleTagText = questTitleTag:GetText() or ""
				questNormalText = _G["QuestLogTitle" .. i .. "NormalText"]
				if questNormalText then
					questNormalText:ClearAllPoints()
					questNormalText:SetPoint("LEFT", _G["QuestLogTitle" .. i], "LEFT", 18, 0)
				end

				if lvl and lvl > 0 then
					local qnt = questNormalText:GetText() or ""
					local lvltext = lvl
					if questTag == "Dungeon" then
						lvltext = lvltext .. "D"
					elseif questTag == "Group" then
						lvltext = lvltext .. "G"
					elseif questTag == "Elite" then
						lvltext = lvltext .. "E"
					end

					if lvltext and qnt then
						questNormalText:SetText(format("[%s]%s", lvltext, qnt))
					else
						ImproveAny:MSG("[UpdateQuestFrame] FAILED", lvltext, qnt)
					end
				end

				if questTitleTag then
					questTitleTag:SetText(string.format("(%dXP)%s", rewardXP, questTitleTagText))
				end
			end

			if isComplete and isComplete < 0 then
				questTag = FAILED
			elseif isComplete and isComplete > 0 then
				questTag = COMPLETE
			end

			if questTag then
				QuestLogDummyText:SetText("  " .. questLogTitleText)
				local tempWidth = 274
				local textWidth = 0
				if questTitleTag then
					tempWidth = 274 - questTitleTag:GetWidth()
				end

				if QuestLogDummyText:GetWidth() > tempWidth then
					textWidth = tempWidth
				else
					textWidth = QuestLogDummyText:GetWidth()
				end

				questNormalText:SetWidth(textWidth)
			else
				if questNormalText:GetWidth() > 274 then
					questNormalText:SetWidth(260)
				end
			end
		end
	end
end

function ImproveAny:Clamp(vval, vmin, vmax)
	if vval < vmin then
		return vmin
	elseif vval > vmax then
		return vmax
	end

	return vval
end

function ImproveAny:InitXPBar()
	if ImproveAny:IsEnabled("XPBAR", false) then
		if QuestLogFrame then
			QuestLogFrame:Show()
			QuestLogFrame:Hide()
		end

		ImproveAny:Debug("xpbar.lua: #1")
		C_Timer.After(
			0.01,
			function()
				if GetRewardXP ~= nil then
					local qaf = CreateFrame("FRAME")
					qaf:RegisterEvent("QUEST_ACCEPTED")
					qaf:RegisterEvent("QUEST_COMPLETE")
					qaf:RegisterEvent("QUEST_TURNED_IN")
					qaf:RegisterEvent("LOOT_OPENED")
					qaf:RegisterEvent("LOOT_CLOSED")
					qaf:SetScript(
						"OnEvent",
						function(sel, event, ...)
							if event == "QUEST_ACCEPTED" then
								local _, questID = ...
								if questID then
									local xp = GetRewardXP()
									if xp > 0 then
										IATAB["QUESTS"] = IATAB["QUESTS"] or {}
										IATAB["QUESTS"][questID] = xp
									end
								end
							end

							ImproveAny:Debug("xpbar.lua: #2")
							C_Timer.After(
								0.05,
								function()
									if MainMenuBarExpText then
										MainMenuBarExpText:SetText(MainMenuBarExpText:GetText())
									end
								end
							)
						end
					)

					function ImproveAny:UpdateQAF()
						if MainMenuBarExpText then
							MainMenuBarExpText:SetText(MainMenuBarExpText:GetText())
						end

						ImproveAny:Debug("xpbar.lua: #3")
						C_Timer.After(1.1, ImproveAny.UpdateQAF)
					end

					ImproveAny:UpdateQAF()
					function ImproveAny:GetQuestLogRewardXP(questID)
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

				if ImproveAny:GetWoWBuild() == "CLASSIC" then
					hooksecurefunc(
						"QuestLog_Update",
						function()
							ImproveAny:UpdateQuestFrame()
						end
					)
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
					if not ImproveAny:IsAddOnLoaded("MoveAny") then
						MainMenuExpBar:SetHeight(15)
					end

					MainMenuExpBar:HookScript(
						"OnEnter",
						function(sel)
							if ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
								MainMenuExpBar.show = true
								MainMenuBarExpText:Show()
							else
								MainMenuExpBar.show = false
								MainMenuBarExpText:Hide()
							end
						end
					)

					MainMenuExpBar:HookScript(
						"OnLeave",
						function(sel)
							if ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
								MainMenuExpBar.show = false
								MainMenuBarExpText:Hide()
							else
								MainMenuExpBar.show = true
								MainMenuBarExpText:Show()
							end
						end
					)

					if not ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
						MainMenuExpBar.show = true
						MainMenuBarExpText:Show()
					else
						MainMenuExpBar.show = false
						MainMenuBarExpText:Hide()
					end

					for sec = 1, 3 do
						ImproveAny:Debug("xpbar.lua: #4")
						C_Timer.After(
							sec,
							function()
								if not ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
									MainMenuExpBar.show = true
									MainMenuBarExpText:Show()
								else
									MainMenuExpBar.show = false
									MainMenuBarExpText:Hide()
								end
							end
						)
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
					frame:SetScript(
						"OnEvent",
						function(sel, event, message, ...)
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
						end
					)
				end

				if MainMenuExpBar then
					MainMenuExpBar:SetStatusBarColor(0.34, 0.38, 1, 1)
					if ExhaustionLevelFillBar then
						ExhaustionLevelFillBar:SetVertexColor(0.21, 0.40, 0.64, 0.75)
						ExhaustionLevelFillBar:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
						ExhaustionLevelFillBar:SetDrawLayer("BACKGROUND", -1)
					end

					local _, sh = MainMenuExpBar:GetSize()
					MainMenuExpBar.qcx = MainMenuExpBar:CreateTexture(nil, "BACKGROUND")
					MainMenuExpBar.qcx:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
					MainMenuExpBar.qcx:SetVertexColor(1, 1, 0, 1)
					MainMenuExpBar.qcx:SetSize(1, sh)
					MainMenuExpBar.qcx:SetDrawLayer("BACKGROUND", -2)
				end

				if MainMenuExpBar and MainMenuBarExpText then
					local fontName, _, fontFlags = MainMenuBarExpText:GetFont()
					MainMenuBarExpText:SetFont(fontName, ImproveAny:Clamp(MainMenuExpBar:GetHeight() * 0.7, 8, 30), fontFlags)
					MainMenuBarExpText:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 1)
					hooksecurefunc(
						MainMenuBarExpText,
						"SetText",
						function(sel, text)
							if sel.iasettext then return end
							sel.iasettext = true
							local currXP = UnitXP("PLAYER")
							local maxBar = UnitXPMax("PLAYER")
							if maxBar == 0 then
								sel.iasettext = false

								return
							end

							local ff, _, fflags = sel:GetFont()
							sel:SetFont(ff, ImproveAny:Clamp(MainMenuExpBar:GetHeight() * 0.7, 8, 30), fflags)
							if GameLimitedMode_IsActive() then
								local rLevel = GetRestrictedAccountData()
								if UnitLevel("player") >= rLevel then
									currXP = UnitTrialXP("player")
								end
							end

							local missingXp = maxBar - currXP
							local questCompleteXP = ImproveAny:GetQuestCompleteXP()
							local text2 = ""
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

									if ImproveAny:IsEnabled("XPNUMBERQUESTCOMPLETE", false) or ImproveAny:IsEnabled("XPPERCENTQUESTCOMPLETE", false) then
										MainMenuExpBar.qcx:SetPoint("LEFT", MainMenuExpBar, "LEFT", px, 0)
										MainMenuExpBar.qcx:SetWidth(wi)
										MainMenuExpBar.qcx:Show()
									else
										MainMenuExpBar.qcx:Hide()
									end
								end
							end

							-- Level
							text2 = text2 .. AddText(text2, "XPNUMBERLEVEL", "XPPERCENTLEVEL", LEVEL, UnitLevel("PLAYER"), ImproveAny:GetMaxLevel())
							-- XP
							text2 = text2 .. AddText(text2, "XPNUMBER", "XPPERCENT", XP, currXP, maxBar)
							-- XP Missing
							text2 = text2 .. AddText(text2, "XPNUMBERMISSING", "XPPERCENTMISSING", ADDON_MISSING, missingXp, maxBar)
							-- XP Exhaustion
							if GetXPExhaustion() and GetXPExhaustion() >= 0 then
								text2 = text2 .. AddText(text2, "XPNUMBEREXHAUSTION", "XPPERCENTEXHAUSTION", TUTORIAL_TITLE26, GetXPExhaustion(), maxBar)
							end

							-- XP QuestComplete
							text2 = text2 .. AddText(text2, "XPNUMBERQUESTCOMPLETE", "XPPERCENTQUESTCOMPLETE", QUEST_COMPLETE, questCompleteXP, maxBar, nil, "|cFFFFFF00")
							-- XP KILLSTOLEVELUP
							text2 = text2 .. AddText(text2, "XPNUMBERKILLSTOLEVELUP", nil, QUICKBUTTON_NAME_KILLS, ImproveAny:GetKillsToLevelUp(), nil, true)
							-- XPBAR -> SetText
							if UnitExists("PET") and GetPetExperience ~= nil then
								local currXPPet, maxBarPet = GetPetExperience()
								print("cur: " .. currXPPet)
								print("max: " .. maxBarPet)
								text2 = text2 .. AddText(text2, "XPNUMBER", "XPPERCENT", PET, currXPPet, maxBarPet)
							end

							sel:SetText(text2)
							if MainMenuExpBar.show then
								sel:Show()
							end

							sel.iasettext = false
						end
					)

					hooksecurefunc(
						MainMenuBarExpText,
						"Hide",
						function(sel, text)
							if MainMenuExpBar.show then
								sel:Show()
							end
						end
					)

					hooksecurefunc(
						MainMenuBarExpText,
						"Show",
						function(sel, text)
							if not MainMenuExpBar.show then
								sel:Hide()
							end
						end
					)

					MainMenuBarExpText:SetText("LOADING")
				end
			end
		)
	end
end
