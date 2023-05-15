local _, ImproveAny = ...
local textc = "|cFF00FF00" -- Colored
local textw = "|r" -- "WHITE"
local maxlevel = 60

function ImproveAny:GetMaxLevel()
	return maxlevel
end

function ImproveAny:GetQuestCompleteXP()
	local totalXP = 0

	for i = 1, GetNumQuestLogEntries() do
		local questID = select(8, GetQuestLogTitle(i))

		if IsQuestComplete(questID) then
			local xp = GetQuestLogRewardXP(i)
			totalXP = totalXP + xp
		end
	end

	return math.floor(totalXP)
end

function ImproveAny:InitXPBar()
	if ImproveAny:IsEnabled("XPBAR", true) then
		if QuestLogFrame then
			QuestLogFrame:Show()
			QuestLogFrame:Hide()
		end

		C_Timer.After(0.01, function()
			if GetQuestLogRewardXP == nil then
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

					if MainMenuBarExpText then
						MainMenuBarExpText:SetText(MainMenuBarExpText:GetText())
					end
				end)

				function GetQuestLogRewardXP(i)
					local questID = select(8, GetQuestLogTitle(i))
					IATAB["QUESTS"] = IATAB["QUESTS"] or {}
					if IATAB["QUESTS"][questID] ~= nil then return IATAB["QUESTS"][questID] end
					local level = select(2, GetQuestLogTitle(i))
					local gold = GetQuestLogRewardMoney(i)

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

							if ImproveAny:IsEnabled("XPQUESTCOMPLETE", true) then
								MainMenuExpBar.qcx:SetPoint("LEFT", MainMenuExpBar, "LEFT", px, 0)
								MainMenuExpBar.qcx:SetWidth(wi)
								MainMenuExpBar.qcx:Show()
							else
								MainMenuExpBar.qcx:Hide()
							end
						end
					end

					if ImproveAny:IsEnabled("XPQUESTCOMPLETE", true) and questCompleteXP > 0 then
						if text2 ~= "" then
							text2 = text2 .. "    "
						end

						text2 = text2 .. QUEST_COMPLETE .. "-" .. XP .. ": " .. textc .. questCompleteXP .. textw
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