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
	if QuestLogFrame == nil then return lastTotalXp end
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
			else
				xp = IATAB["QUESTS"][questID] or 0
			end

			if IsQuestComplete(questID) then
				totalXP = totalXP + xp
			end
		end
	end

	lastTotalXp = totalXP
	SelectQuestLogEntry(oldQuestId)

	return math.floor(totalXP)
end

local xpIcons = {
	LEVEL = {
		{
			atlas = "bags-greenarrow"
		},
		{
			file = "Interface\\Buttons\\Arrow-Up-Up"
		},
	},
	XP = {
		{
			file = "Interface\\Icons\\XP_Icon",
			size = 64,
			coords = {5, 59, 5, 59}
		},
	},
	RESTED = {
		{
			file = "Interface\\HUD\\UIUnitFrameRestingFlipbook",
			size = 512,
			coords = {4, 56, 244, 296}
		},
		{
			atlas = "UI-HUD-UnitFrame-Player-Rest-Flipbook",
			cols = 6,
			rows = 7,
			col = 0,
			row = 4
		},
		{
			file = "Interface\\AddOns\\ImproveAny\\media\\rested",
			size = 64,
			coords = {6, 58, 6, 58},
			addon = true
		},
	},
	QUESTCOMPLETE = {
		{
			file = "Interface\\GossipFrame\\ActiveQuestIcon"
		},
	},
	KILLS = {
		{
			file = "Interface\\CharacterFrame\\UI-StateIcon",
			size = 64,
			coords = {32, 64, 0, 32}
		},
		{
			atlas = "UI-HUD-UnitFrame-Player-CombatIcon"
		},
	},
}

local xpIconCache = {}
local function GetXPIcon(key)
	if key == nil or xpIcons[key] == nil then return nil end
	if xpIconCache[key] ~= nil then return xpIconCache[key] or nil end
	local markup = false
	for _, icon in ipairs(xpIcons[key]) do
		if icon.atlas then
			local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(icon.atlas)
			local file = info and (info.file or info.filename)
			if file then
				local l, r, t, b = info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
				if icon.cols and icon.rows then
					local w = (r - l) / icon.cols
					local h = (b - t) / icon.rows
					l = l + w * (icon.col or 0)
					t = t + h * (icon.row or 0)
					r = l + w
					b = t + h
				end

				markup = format("|T%s:0:0:0:0:4096:4096:%d:%d:%d:%d|t", file, l * 4096, r * 4096, t * 4096, b * 4096)
				break
			end
		elseif icon.addon or GetFileIDFromPath == nil or GetFileIDFromPath(icon.file) then
			if icon.coords then
				local c = icon.coords
				markup = format("|T%s:0:0:0:0:%d:%d:%d:%d:%d:%d|t", icon.file, icon.size, icon.size, c[1], c[2], c[3], c[4])
			else
				markup = format("|T%s:0|t", icon.file)
			end

			break
		end
	end

	xpIconCache[key] = markup

	return markup or nil
end

function ImproveAny:SizeXPTextIcons(text, fontString)
	local _, size = fontString:GetFont()
	if size == nil then return text end
	size = size * 2

	return (text:gsub("(|T[^:|]+):0:0:", function(texture) return format("%s:%g:%g:", texture, size, size) end):gsub("(|T[^:|]+):0|t", function(texture) return format("%s:%g:%g|t", texture, size, size) end))
end

local function AddText(text, bNum, bPer, str, vNum, vNumMax, bDecimals, color, iconKey)
	local res = ""
	if ImproveAny:IsEnabled(bNum, false) or (bPer and ImproveAny:IsEnabled(bPer, false)) then
		if text ~= "" then
			res = res .. "    "
		end

		str = GetXPIcon(iconKey) or (str .. ":")

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

		if (vNum and vNum ~= 0) or (bNum == "XPNUMBER") then
			if vNumMax and vNumMax > 0 then
				if ImproveAny:IsEnabled(bNum, false) and (bPer and ImproveAny:IsEnabled(bPer, false)) then
					res = res .. format("%s%s %s%d%s/%s%d%s (%s%0.1f%s%%)", col1, str, col2, vNum, textw, textc, vNumMax, textw, textc, vNum / vNumMax * 100, textw)
				elseif bPer and ImproveAny:IsEnabled(bPer, false) then
					res = res .. format("%s%s %s%0.1f%s%%", col1, str, col2, vNum / vNumMax * 100, textw)
				elseif ImproveAny:IsEnabled(bNum, false) then
					res = res .. format("%s%s %s%d%s/%s%d", col1, str, col2, vNum, textw, textc, vNumMax, textw)
				end
			else
				if ImproveAny:IsEnabled(bNum, false) then
					res = res .. format("%s%s %s" .. num .. "%s", col1, str, col2, vNum, textw)
				end
			end
		elseif ImproveAny:IsEnabled("XPHIDEUNKNOWNVALUES", false) == false then
			res = res .. format("%s%s %s%s", col1, str, col2, UNKNOWN, textw)
		end
	end

	return res
end

local questlogWarning = false
local once = {}
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
					questNormalText:SetPoint("LEFT", _G["QuestLogTitle" .. i], "LEFT", 16, 0)
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
						if once[questNormalText] == nil then
							once[questNormalText] = true
							hooksecurefunc(
								questNormalText,
								"SetText",
								function(sel, text)
									if sel.ia_settext then return end
									sel.ia_settext = true
									if text then
										sel:SetText(
											string.gsub(
												text,
												"%[([%da-zA-Z]+)%] (%[([%da-zA-Z]+)%])",
												function(id1, id2_full, id2)
													local num1 = tonumber(id1)
													local num2 = tonumber(id2)
													if num1 and num2 and num1 == num2 then
														return "[" .. id1 .. "]"
													else
														return "[" .. id1 .. "] " .. id2_full
													end
												end
											)
										)
									end

									sel.ia_settext = false
								end
							)
						end

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

			if questTag and QuestLogDummyText then
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
			elseif questNormalText and questNormalText:GetWidth() > 274 then
				questNormalText:SetWidth(260)
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

function ImproveAny:FindXpTextFrame(frame, str)
	local test = nil
	ImproveAny:ForeachChildren(
		frame,
		function(child, x)
			if child.OverlayFrame then
				ImproveAny:ForeachRegions(
					child.OverlayFrame,
					function(cchild, cx)
						if cchild.SetText then
							test = cchild
						end
					end
				)
			end
		end
	)

	return test
end

local killXPRegistered = false
function ImproveAny:RegisterKillXP()
	if killXPRegistered then return end
	killXPRegistered = true
	local frame = CreateFrame("Frame")
	ImproveAny:RegisterEvent(frame, "CHAT_MSG_COMBAT_XP_GAIN")
	local xpGainText = COMBATLOG_XPGAIN_FIRSTPERSON
	if strfind(xpGainText, "%1$s", 1, true) then
		xpGainText = ImproveAny:ReplaceStr(xpGainText, "%1$s", "%s")
	end

	if strfind(xpGainText, "%2$d", 1, true) then
		xpGainText = ImproveAny:ReplaceStr(xpGainText, "%2$d", "%d")
	end

	local xpKillText = ImproveAny:ReplaceStr(ImproveAny:ReplaceStr(xpGainText, "%s", "(.-)"), "%d", "(%d+)")
	ImproveAny:OnEvent(
		frame,
		function(sel, event, message, ...)
			pcall(
				function()
					if strfind(message, xpKillText) then
						local xpGained = tonumber(message:match("(%d+)"))
						if xpGained then
							ImproveAny:AddXPPerMob(xpGained)
						end
					end
				end
			)
		end, "xpKillText"
	)
end

function ImproveAny:HasTrackingBars()
	return StatusTrackingBarManager ~= nil and StatusTrackingBarManager.barContainers ~= nil and StatusTrackingBarInfo ~= nil
end

function ImproveAny:ForeachTrackingBar(barIndex, callback)
	if not ImproveAny:HasTrackingBars() then return end
	for _, container in ipairs(StatusTrackingBarManager.barContainers) do
		local bar = container.bars and container.bars[barIndex]
		if bar then
			callback(bar, container)
		end
	end
end

function ImproveAny:UpdateTrackingBarTextShown(bar, inverted)
	local text = bar.OverlayFrame and bar.OverlayFrame.Text
	if text == nil then return end
	local hovered = bar.textLocked == true
	if inverted then
		text:SetShown(hovered)
	else
		text:SetShown(not hovered)
	end
end

local trackingArtworkHooked = false
function ImproveAny:UpdateTrackingBarArtwork(container)
	local bar = container:GetShownBar()
	local hide = false
	if bar and bar.barIndex == StatusTrackingBarInfo.BarsEnum.Experience then
		hide = ImproveAny:IsEnabled("XPBAR", false) and ImproveAny:IsEnabled("XPHIDEARTWORK", false)
	elseif bar and bar.barIndex == StatusTrackingBarInfo.BarsEnum.Reputation then
		hide = ImproveAny:IsEnabled("REPBAR", false) and ImproveAny:IsEnabled("REPHIDEARTWORK", false)
	end

	local alpha = hide and 0 or 1
	if container.BarFrameTexture then
		container.BarFrameTexture:SetAlpha(alpha)
	end

	if container.HorizontalDividersPool then
		for divider in container.HorizontalDividersPool:EnumerateActive() do
			divider:SetAlpha(alpha)
		end
	end
end

function ImproveAny:InitTrackingBarArtwork()
	if trackingArtworkHooked then return end
	if not ImproveAny:HasTrackingBars() then return end
	trackingArtworkHooked = true
	for _, container in ipairs(StatusTrackingBarManager.barContainers) do
		local function update()
			ImproveAny:UpdateTrackingBarArtwork(container)
		end

		hooksecurefunc(container, "ApplyPendingBarToShow", update)
		if container.UpdateDividers then
			hooksecurefunc(container, "UpdateDividers", update)
		end
		update()
	end
end

local trackingQcx = {}
local trackingFonts = {}
local trackingTextMoved = {}
local function GetTrackingQuestCompleteXP()
	if C_QuestLog == nil or C_QuestLog.GetNumQuestLogEntries == nil or GetQuestLogRewardXP == nil then return 0 end
	local totalXP = 0
	for i = 1, C_QuestLog.GetNumQuestLogEntries() do
		local info = C_QuestLog.GetInfo(i)
		if info and not info.isHeader and info.questID and C_QuestLog.IsComplete(info.questID) then
			totalXP = totalXP + (GetQuestLogRewardXP(info.questID) or 0)
		end
	end

	return totalXP
end

function ImproveAny:UpdateTrackingXPBarText(bar)
	local text = bar.OverlayFrame and bar.OverlayFrame.Text
	if text == nil then return end
	local currXP, maxBar, level = bar:GetLevelData()
	if maxBar == nil or maxBar == 0 then return end
	maxlevel = bar:GetMaxLevel() or maxlevel
	local showQuestComplete = ImproveAny:IsEnabled("XPNUMBERQUESTCOMPLETE", false) or ImproveAny:IsEnabled("XPPERCENTQUESTCOMPLETE", false)
	local questCompleteXP = 0
	if showQuestComplete then
		questCompleteXP = GetTrackingQuestCompleteXP()
	end

	local qcx = trackingQcx[bar]
	if qcx == nil and showQuestComplete then
		qcx = bar.StatusBar:CreateTexture(nil, "BACKGROUND", nil, 2)
		qcx:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
		qcx:SetVertexColor(1, 1, 0, 0.6)
		trackingQcx[bar] = qcx
	end

	if qcx then
		local sw = bar.StatusBar:GetWidth()
		local px = math.min(currXP / maxBar, 1) * sw
		local wi = questCompleteXP / maxBar * sw
		if px + wi > sw then
			wi = sw - px
		end

		if showQuestComplete and wi > 1 then
			qcx:ClearAllPoints()
			qcx:SetPoint("LEFT", bar.StatusBar, "LEFT", px, 0)
			qcx:SetSize(wi, bar.StatusBar:GetHeight())
			qcx:Show()
		else
			qcx:Hide()
		end
	end

	local text2 = ""
	text2 = text2 .. AddText(text2, "XPNUMBERLEVEL", "XPPERCENTLEVEL", LEVEL, level, ImproveAny:GetMaxLevel(), nil, nil, "LEVEL")
	text2 = text2 .. AddText(text2, "XPNUMBER", "XPPERCENT", XP, currXP, maxBar, nil, nil, "XP")
	text2 = text2 .. AddText(text2, "XPNUMBERMISSING", "XPPERCENTMISSING", ADDON_MISSING, maxBar - currXP, maxBar)
	local exhaustion = GetXPExhaustion()
	if exhaustion and exhaustion >= 0 then
		text2 = text2 .. AddText(text2, "XPNUMBEREXHAUSTION", "XPPERCENTEXHAUSTION", TUTORIAL_TITLE26, exhaustion, maxBar, nil, nil, "RESTED")
	end

	text2 = text2 .. AddText(text2, "XPNUMBERQUESTCOMPLETE", "XPPERCENTQUESTCOMPLETE", QUEST_COMPLETE, questCompleteXP, maxBar, nil, "|cFFFFFF00", "QUESTCOMPLETE")
	text2 = text2 .. AddText(text2, "XPNUMBERKILLSTOLEVELUP", nil, QUICKBUTTON_NAME_KILLS, ImproveAny:GetKillsToLevelUp(), nil, true, nil, "KILLS")
	if UnitExists("PET") and GetPetExperience ~= nil then
		local currXPPet, maxBarPet = GetPetExperience()
		text2 = text2 .. AddText(text2, "XPNUMBER", "XPPERCENT", PET, currXPPet, maxBarPet)
	end

	text2 = string.gsub(text2, "%s+$", "")
	if text2 ~= "" then
		local font = trackingFonts[text]
		if font == nil then
			font = {text:GetFont()}
			trackingFonts[text] = font
		end

		if font[1] and font[2] then
			text:SetFont(font[1], font[2] - 2, font[3])
		end

		if ImproveAny:IsForever() and not trackingTextMoved[text] then
			local point, relativeTo, relativePoint, x, y = text:GetPoint(1)
			if point then
				text:ClearAllPoints()
				text:SetPoint(point, relativeTo, relativePoint, x, y - 2)
				trackingTextMoved[text] = true
			end
		end

		text:SetText(ImproveAny:SizeXPTextIcons(text2, text))
	end

	ImproveAny:UpdateTrackingBarTextShown(bar, ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false))
end

function ImproveAny:UpdateTrackingXPBars()
	ImproveAny:ForeachTrackingBar(
		StatusTrackingBarInfo.BarsEnum.Experience,
		function(bar)
			if bar:IsShown() then
				ImproveAny:UpdateTrackingXPBarText(bar)
			end
		end
	)
end

function ImproveAny:InitTrackingXPBar()
	if StatusTrackingBarInfo == nil then return end
	ImproveAny:RegisterKillXP()
	ImproveAny:InitTrackingBarArtwork()
	ImproveAny:ForeachTrackingBar(
		StatusTrackingBarInfo.BarsEnum.Experience,
		function(bar)
			hooksecurefunc(
				bar,
				"UpdateCurrentText",
				function(sel)
					ImproveAny:UpdateTrackingXPBarText(sel)
				end
			)

			hooksecurefunc(
				bar,
				"UpdateTextVisibility",
				function(sel)
					ImproveAny:UpdateTrackingBarTextShown(sel, ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false))
				end
			)

			ImproveAny:UpdateTrackingBarTextShown(bar, ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false))
		end
	)

	local frame = CreateFrame("Frame")
	ImproveAny:RegisterEvent(frame, "QUEST_LOG_UPDATE")
	ImproveAny:RegisterEvent(frame, "UNIT_PET_EXPERIENCE")
	ImproveAny:OnEvent(
		frame,
		function()
			ImproveAny:UpdateTrackingXPBars()
		end, "TrackingXPBar"
	)

	ImproveAny:UpdateTrackingXPBars()
end

function ImproveAny:InitXPBar()
	if ImproveAny:IsEnabled("XPBAR", false) then
		if ImproveAny:HasTrackingBars() then
			ImproveAny:InitTrackingXPBar()

			return
		end

		if QuestLogFrame then
			QuestLogFrame:Show()
			QuestLogFrame:Hide()
		end

		ImproveAny:Debug("xpbar.lua: #1")
		ImproveAny:After(
			0.01,
			function()
				local xpBarText = MainMenuBarExpText
				local xpBar = MainMenuExpBar
				if DragonflightUIXPBar and DragonflightUIXPBar.Bar then
					xpBar = DragonflightUIXPBar.Bar
					xpBarText = XPBarText
					ImproveAny:ForeachRegions(
						DragonflightUIXPBar.Bar,
						function(region)
							if ImproveAny:GetName(region) == "Text" then
								region:HookScript(
									"OnShow",
									function(sel)
										sel:Hide()
									end
								)

								region:Hide()
							end
						end
					)
				elseif xpBar == nil then
					xpBar = MainStatusTrackingBarContainer
					xpBarText = ImproveAny:FindXpTextFrame(MainStatusTrackingBarContainer, "Text")
				end

				if GetRewardXP ~= nil then
					local qaf = CreateFrame("FRAME")
					ImproveAny:RegisterEvent(qaf, "QUEST_ACCEPTED")
					ImproveAny:RegisterEvent(qaf, "QUEST_COMPLETE")
					ImproveAny:RegisterEvent(qaf, "QUEST_TURNED_IN")
					ImproveAny:RegisterEvent(qaf, "LOOT_OPENED")
					ImproveAny:RegisterEvent(qaf, "LOOT_CLOSED")
					ImproveAny:OnEvent(
						qaf,
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
							ImproveAny:After(
								0.1,
								function()
									if xpBarText then
										xpBarText:SetText(xpBarText:GetText())
									end
								end, "qaf"
							)
						end, "qaf"
					)

					function ImproveAny:UpdateQAF()
						if xpBarText then
							xpBarText:SetText(xpBarText:GetText())
						end

						ImproveAny:Debug("xpbar.lua: #3")
						ImproveAny:After(1.1, ImproveAny.UpdateQAF, "UpdateQAF")
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

				if ImproveAny:GetWoWBuild() ~= "CLASSIC" and QuestLog_Update then
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

				if ImproveAny:GetWoWBuild() == "CATA" then
					maxlevel = 85
				end

				if ImproveAny:GetWoWBuild() == "MISTS" then
					maxlevel = 90
				end

				if GetMaxLevelForPlayerExpansion then
					maxlevel = GetMaxLevelForPlayerExpansion()
				end

				if xpBar then
					if not ImproveAny:IsAddOnLoaded("MoveAny") then
						xpBar:SetHeight(15)
					end

					xpBar:HookScript(
						"OnEnter",
						function(sel)
							if ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
								xpBar.show = true
								if xpBarText then
									xpBarText:Show()
								end
							else
								xpBar.show = false
								if xpBarText then
									xpBarText:Hide()
								end
							end
						end
					)

					xpBar:HookScript(
						"OnLeave",
						function(sel)
							if ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
								xpBar.show = false
								if xpBarText then
									xpBarText:Hide()
								end
							else
								xpBar.show = true
								if xpBarText then
									xpBarText:Show()
								end
							end
						end
					)

					if not ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
						xpBar.show = true
						if xpBarText then
							xpBarText:Show()
						end
					else
						xpBar.show = false
						if xpBarText then
							xpBarText:Hide()
						end
					end

					for sec = 1, 3 do
						ImproveAny:Debug("xpbar.lua: #4")
						ImproveAny:After(
							sec,
							function()
								if not ImproveAny:IsEnabled("XPBARTEXTSHOWINVERTED", false) then
									xpBar.show = true
									if xpBarText then
										xpBarText:Show()
									end
								else
									xpBar.show = false
									if xpBarText then
										xpBarText:Hide()
									end
								end
							end, "xpbar.lua: #4"
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

					local editFrames = {"MainStatusTrackingBarContainer", "SecondaryStatusTrackingBarContainer"}
					local endCaps = {"StandaloneFrameTextureLeftCapTop", "StandaloneFrameTextureLeftCapBottom", "StandaloneFrameTextureRightCapTop", "StandaloneFrameTextureRightCapBottom"}
					for x, editFrame in pairs(editFrames) do
						local frame = _G[editFrame]
						if frame then
							for i = 1, 5 do
								if frame["StandaloneFrameTexture" .. i] then
									local ia_hide = false
									hooksecurefunc(
										frame["StandaloneFrameTexture" .. i],
										"SetTexture",
										function(sel)
											if ia_hide then return end
											ia_hide = true
											sel:SetTexture("")
											ia_hide = false
										end
									)

									frame["StandaloneFrameTexture" .. i]:SetTexture("")
								end
							end

							for w, cap in pairs(endCaps) do
								if frame[cap] then
									local ia_hide = false
									hooksecurefunc(
										frame[cap],
										"SetTexture",
										function(sel)
											if ia_hide then return end
											ia_hide = true
											sel:SetTexture("")
											ia_hide = false
										end
									)

									frame[cap]:SetTexture("")
								end
							end
						end
					end

					ImproveAny:RegisterKillXP()

					if xpBar then
						if xpBar.SetStatusBarColor then
							xpBar:SetStatusBarColor(0.34, 0.38, 1, 1)
						end

						if ExhaustionLevelFillBar then
							ExhaustionLevelFillBar:SetVertexColor(0.21, 0.40, 0.64, 0.75)
							ExhaustionLevelFillBar:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
							ExhaustionLevelFillBar:SetDrawLayer("BACKGROUND", -1)
						end

						local _, sh = xpBar:GetSize()
						xpBar.qcx = xpBar:CreateTexture(nil, "BACKGROUND")
						xpBar.qcx:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
						xpBar.qcx:SetVertexColor(1, 1, 0, 1)
						if xpBar == MainMenuExpBar then
							xpBar.qcx:SetSize(1, sh)
						else
							xpBar.qcx:SetSize(1, 13)
						end

						xpBar.qcx:SetDrawLayer("BACKGROUND", -2)
					end

					if xpBar and xpBarText then
						local fontName, _, fontFlags = xpBarText:GetFont()
						xpBarText:SetFont(fontName, ImproveAny:Clamp(xpBar:GetHeight() * 0.7, 8, 30) - 2, fontFlags)
						if DragonflightUIXPBar and DragonflightUIXPBar.Bar then
							local xpBarSetPoint
							hooksecurefunc(
								xpBarText,
								"SetPoint",
								function()
									if xpBarSetPoint then return end
									xpBarSetPoint = true
									xpBarText:ClearAllPoints()
									xpBarText:SetPoint("CENTER", DragonflightUIXPBar.Bar, "CENTER", 0, 1)
									xpBarSetPoint = false
								end
							)

							xpBarText:ClearAllPoints()
							xpBarText:SetPoint("CENTER", DragonflightUIXPBar.Bar, "CENTER", 0, 1)
						elseif xpBarText == MainMenuBarExpText then
							xpBarText:SetPoint("CENTER", xpBar, "CENTER", 0, 1)
						end

						hooksecurefunc(
							xpBarText,
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
								sel:SetFont(ff, ImproveAny:Clamp(xpBar:GetHeight() * 0.7, 8, 30) - 2, fflags)
								if GameLimitedMode_IsActive() then
									local rLevel = GetRestrictedAccountData()
									if UnitLevel("player") >= rLevel then
										currXP = UnitTrialXP("player")
									end
								end

								local missingXp = maxBar - currXP
								local questCompleteXP = 0
								if ImproveAny:IsEnabled("XPNUMBERQUESTCOMPLETE", false) or ImproveAny:IsEnabled("XPPERCENTQUESTCOMPLETE", false) then
									questCompleteXP = ImproveAny:GetQuestCompleteXP()
								end
								local text2 = ""
								if xpBar and xpBar.qcx then
									local sw, _ = xpBar:GetSize()
									local px = currXP / maxBar * sw
									local wi = questCompleteXP / maxBar * sw
									if wi <= 1 then
										xpBar.qcx:Hide()
									else
										if px + wi > sw then
											wi = sw - px
										end

										if ImproveAny:IsEnabled("XPNUMBERQUESTCOMPLETE", false) or ImproveAny:IsEnabled("XPPERCENTQUESTCOMPLETE", false) then
											xpBar.qcx:SetPoint("LEFT", xpBar, "LEFT", px, 0)
											xpBar.qcx:SetWidth(wi)
											xpBar.qcx:Show()
										else
											xpBar.qcx:Hide()
										end
									end
								end

								-- Level
								text2 = text2 .. AddText(text2, "XPNUMBERLEVEL", "XPPERCENTLEVEL", LEVEL, UnitLevel("PLAYER"), ImproveAny:GetMaxLevel(), nil, nil, "LEVEL")
								-- XP
								text2 = text2 .. AddText(text2, "XPNUMBER", "XPPERCENT", XP, currXP, maxBar, nil, nil, "XP")
								-- XP Missing
								text2 = text2 .. AddText(text2, "XPNUMBERMISSING", "XPPERCENTMISSING", ADDON_MISSING, missingXp, maxBar)
								-- XP Exhaustion
								if GetXPExhaustion() and GetXPExhaustion() >= 0 then
									text2 = text2 .. AddText(text2, "XPNUMBEREXHAUSTION", "XPPERCENTEXHAUSTION", TUTORIAL_TITLE26, GetXPExhaustion(), maxBar, nil, nil, "RESTED")
								end

								-- XP QuestComplete
								text2 = text2 .. AddText(text2, "XPNUMBERQUESTCOMPLETE", "XPPERCENTQUESTCOMPLETE", QUEST_COMPLETE, questCompleteXP, maxBar, nil, "|cFFFFFF00", "QUESTCOMPLETE")
								-- XP KILLSTOLEVELUP
								text2 = text2 .. AddText(text2, "XPNUMBERKILLSTOLEVELUP", nil, QUICKBUTTON_NAME_KILLS, ImproveAny:GetKillsToLevelUp(), nil, true, nil, "KILLS")
								-- XPBAR -> SetText
								if UnitExists("PET") and GetPetExperience ~= nil then
									local currXPPet, maxBarPet = GetPetExperience()
									text2 = text2 .. AddText(text2, "XPNUMBER", "XPPERCENT", PET, currXPPet, maxBarPet)
								end

								text2 = string.gsub(text2, "%s+$", "")
								sel:SetText(ImproveAny:SizeXPTextIcons(text2, sel))
								if xpBar.show then
									sel:Show()
								end

								sel.iasettext = false
							end
						)

						hooksecurefunc(
							xpBarText,
							"Hide",
							function(sel, text)
								if xpBar.show then
									sel:Show()
								end
							end
						)

						hooksecurefunc(
							xpBarText,
							"Show",
							function(sel, text)
								if not xpBar.show then
									sel:Hide()
								end
							end
						)

						xpBarText:SetText("LOADING")
					end
				end
			end, "XPBar"
		)
	end
end
