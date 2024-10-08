local _, ImproveAny = ...
local XPPREFIX = "ImproveAnyXP"
local XPAPIPREFIX = "ImproveAnyXPAPI"
local iaxpready = false
function ImproveAny:UnitName(unit)
	if UnitExists(unit) then
		local name, realm = UnitName(unit)
		if realm and realm ~= "" then
			name = name .. "-" .. realm
		else
			name = name .. "-" .. GetRealmName()
		end

		return name
	else
		return "NOT EXISTS"
	end
end

function ImproveAny:UnitXP(unit)
	local target = ImproveAny:UnitName(unit)
	if UnitIsUnit(unit, "player") then return UnitXP("player") end
	if ImproveAny:IAGV("XPTAB") and ImproveAny:IAGV("XPTAB")[target] and ImproveAny:IAGV("XPTAB")[target]["XP"] then return tonumber(ImproveAny:IAGV("XPTAB")[target]["XP"]) end

	return 0
end

function ImproveAny:UnitXPMax(unit)
	local target = ImproveAny:UnitName(unit)
	if UnitIsUnit(unit, "player") then return UnitXPMax("player") end
	if ImproveAny:IAGV("XPTAB") and ImproveAny:IAGV("XPTAB")[target] and ImproveAny:IAGV("XPTAB")[target]["XPMAX"] then return tonumber(ImproveAny:IAGV("XPTAB")[target]["XPMAX"]) end

	return 1
end

function ImproveAny:InitPartyFrames()
	IATAB.UnitXP = ImproveAny.UnitXP
	IATAB.UnitXPMax = ImproveAny.UnitXPMax
end

function ImproveAny:UpdatePartyXPAPI()
	for i = 1, 4 do
		local target = ImproveAny:UnitName("PARTY" .. i)
		if target and ImproveAny:IAGV("XPTAB")[target] == nil then
			ImproveAny:IAGV("XPTAB")[target] = {}
		end
	end

	local message = "Ping"
	if IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		C_ChatInfo.SendAddonMessage(XPAPIPREFIX, message, "INSTANCE_CHAT")
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		C_ChatInfo.SendAddonMessage(XPAPIPREFIX, message, "PARTY")
	end
end

local function OnEventXP(self, event, prefix, ...)
	if event == "CHAT_MSG_ADDON" then
		-- new xp values
		if prefix == XPPREFIX and ImproveAny:IAGV("XPTAB") then
			local values, _, target = ...
			local xp, xpmax = string.split(";", values)
			if ImproveAny:IAGV("XPTAB")[target] == nil then
				ImproveAny:IAGV("XPTAB")[target] = {}
			end

			ImproveAny:IAGV("XPTAB")[target]["XP"] = xp
			ImproveAny:IAGV("XPTAB")[target]["XPMAX"] = xpmax
			ImproveAny:IAGV("XPTAB")[target]["useapi"] = true -- it uses the api
		elseif prefix == XPAPIPREFIX then
			local values, _, target = ...
			-- PING
			if values == "Ping" then
				local message = "Pong" -- "answer to ping"
				if IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
					C_ChatInfo.SendAddonMessage(XPAPIPREFIX, message, "INSTANCE_CHAT")
				elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
					C_ChatInfo.SendAddonMessage(XPAPIPREFIX, message, "PARTY")
				end
			else -- PONG
				if ImproveAny:IAGV("XPTAB")[target] == nil then
					ImproveAny:IAGV("XPTAB")[target] = {}
				end

				ImproveAny:IAGV("XPTAB")[target]["useapi"] = true -- received answer
			end
		end
	end
end

local frameXP = CreateFrame("Frame")
frameXP:RegisterEvent("CHAT_MSG_ADDON")
frameXP:SetScript("OnEvent", OnEventXP)
local function OnEventXPInit(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local isInitialLogin, isReloadingUi = ...
		if isInitialLogin or isReloadingUi then
			C_ChatInfo.RegisterAddonMessagePrefix(XPPREFIX)
			C_ChatInfo.RegisterAddonMessagePrefix(XPAPIPREFIX)
			ImproveAny:IASV("XPTAB", {})
			for i = 1, 4 do
				local PartyFrame = _G["PartyMemberFrame" .. i]
				local PartyPortrait = _G["PartyMemberFrame" .. i .. "Portrait"]
				local ManaBar = _G["PartyMemberFrame" .. i .. "ManaBar"]
				for id = 1, 4 do
					local parent = _G["PartyMemberFrame" .. i .. "Debuff" .. id - 1]
					if parent == nil then
						parent = PartyFrame
					end
				end

				if PartyFrame then
					local sw = ManaBar:GetWidth() - 1
					local sh = ManaBar:GetHeight()
					local PartyFrameXPBar = CreateFrame("Frame", "PartyFrameXPBar" .. i)
					PartyFrameXPBar:SetParent(PartyFrame)
					PartyFrameXPBar:SetSize(sw, sh)
					PartyFrameXPBar:SetPoint("TOP", ManaBar, "BOTTOM", 0, -2)
					PartyFrameXPBar:SetFrameStrata("HIGH")
					PartyFrameXPBar.textureBar = PartyFrameXPBar:CreateTexture(nil, "BACKGROUND")
					PartyFrameXPBar.textureBar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
					PartyFrameXPBar.textureBar:SetSize(10, sh)
					PartyFrameXPBar.textureBar:SetPoint("LEFT", PartyFrameXPBar, "LEFT", 0, 0)
					PartyFrameXPBar.textureBar:SetColorTexture(0.25, 0.5, 1.0, 1.0)
					PartyFrameXPBar.textureBorder = PartyFrameXPBar:CreateTexture(nil, "BORDER")
					PartyFrameXPBar.textureBorder:SetTexture("Interface\\Tooltips\\UI-StatusBar-Border")
					PartyFrameXPBar.textureBorder:SetSize(sw + 5, sh + 5)
					PartyFrameXPBar.textureBorder:SetPoint("CENTER", PartyFrameXPBar, "CENTER", 0, 0)
					PartyFrameXPBar.XPC = PartyFrameXPBar:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
					PartyFrameXPBar.XPC:SetFont(STANDARD_TEXT_FONT, 8, "")
					PartyFrameXPBar.XPC:SetShadowOffset(1, -1)
					PartyFrameXPBar.XPC:SetAlpha(0.5)
					PartyFrameXPBar.XPC:SetPoint("CENTER", PartyFrameXPBar, "CENTER", 2, 0)
					PartyFrameXPBar.XPC:SetText(string.format("%0.1f", math.random(0, 1000) / 1000 * 100) .. "%")
					PartyFrameXPBar.XPL = PartyFrameXPBar:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
					PartyFrameXPBar.XPL:SetFont(STANDARD_TEXT_FONT, 8, "")
					PartyFrameXPBar.XPL:SetShadowOffset(1, -1)
					PartyFrameXPBar.XPL:SetAlpha(0.5)
					PartyFrameXPBar.XPL:SetPoint("LEFT", PartyFrameXPBar, "LEFT", 2, 0)
					PartyFrameXPBar.XPL:SetText(string.format("%0.1f", math.random(0, 1000) / 1000 * 100) .. "%")
					PartyFrameXPBar.XPR = PartyFrameXPBar:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
					PartyFrameXPBar.XPR:SetFont(STANDARD_TEXT_FONT, 8, "")
					PartyFrameXPBar.XPR:SetShadowOffset(1, -1)
					PartyFrameXPBar.XPR:SetAlpha(0.5)
					PartyFrameXPBar.XPR:SetPoint("RIGHT", PartyFrameXPBar, "RIGHT", 2, 0)
					PartyFrameXPBar.XPR:SetText(string.format("%0.1f", math.random(0, 1000) / 1000 * 100) .. "%")
					PartyFrameXPBar.textureLvlBg = PartyFrameXPBar:CreateTexture(nil, "OVERLAY")
					PartyFrameXPBar.textureLvlBg:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
					PartyFrameXPBar.textureLvlBg:SetSize(42, 42)
					PartyFrameXPBar.textureLvlBg:SetPoint("CENTER", PartyPortrait, "BOTTOMLEFT", 8, -8)
					PartyFrameXPBar.levelText = PartyFrameXPBar:CreateFontString(nil, "OVERLAY")
					PartyFrameXPBar.levelText:SetFont(STANDARD_TEXT_FONT, 8, "")
					PartyFrameXPBar.levelText:SetShadowOffset(1, -1)
					PartyFrameXPBar.levelText:SetPoint("CENTER", PartyFrameXPBar.textureLvlBg, "CENTER", -9, 9)
					PartyFrameXPBar.levelText:SetText("" .. math.random(1, 59))
					local c = GetQuestDifficultyColor(PartyFrameXPBar.levelText:GetText())
					PartyFrameXPBar.levelText:SetTextColor(c.r, c.g, c.b, 1)
					if ImproveAny:IAGV("nochanges") == nil then
						ImproveAny:IASV("nochanges", false)
					end

					function PartyFrameXPBar.think()
						local co = GetQuestDifficultyColor(UnitLevel("PARTY" .. i))
						PartyFrameXPBar.levelText:SetText(UnitLevel("PARTY" .. i))
						PartyFrameXPBar.levelText:SetTextColor(co.r, co.g, co.b, 1)
						if UnitExists("PARTY" .. i) then
							PartyFrameXPBar:SetAlpha(1)
							local xp = ImproveAny:UnitXP("PARTY" .. i, 0)
							local xpmax = ImproveAny:UnitXPMax("PARTY" .. i, 1)
							if (xp > 0 or xpmax > 1) and not ImproveAny:IAGV("nochanges") then
								local per = xp / xpmax
								PartyFrameXPBar.textureBar:SetWidth(per * PartyFrameXPBar:GetWidth() - 4)
								if GetCVar("statusTextDisplay") == "PERCENT" then
									PartyFrameXPBar.XPC:SetText(string.format("%.0f", xp / xpmax * 100) .. "%")
									PartyFrameXPBar.XPL:SetText("")
									PartyFrameXPBar.XPR:SetText("")
								elseif GetCVar("statusTextDisplay") == "NUMERIC" then
									PartyFrameXPBar.XPC:SetText(string.format("%s/%s", ImproveAny:MathR(xp), ImproveAny:MathR(xpmax)))
									PartyFrameXPBar.XPL:SetText("")
									PartyFrameXPBar.XPR:SetText("")
								elseif GetCVar("statusTextDisplay") == "BOTH" then
									PartyFrameXPBar.XPC:SetText("")
									PartyFrameXPBar.XPL:SetText(string.format("%.0f", xp / xpmax * 100) .. "%")
									PartyFrameXPBar.XPR:SetText(string.format("%s", ImproveAny:MathR(xp)))
								else
									PartyFrameXPBar.XPC:SetText("")
									PartyFrameXPBar.XPL:SetText("")
									PartyFrameXPBar.XPR:SetText("")
								end

								PartyFrameXPBar.textureBar:SetAlpha(1)
								PartyFrameXPBar.textureBorder:SetAlpha(1)
							else
								PartyFrameXPBar.XPC:SetText("")
								PartyFrameXPBar.XPL:SetText("")
								PartyFrameXPBar.XPR:SetText("")
								--PartyFrameXPBar.XPValue:SetText( "" )
								PartyFrameXPBar.textureBar:SetAlpha(0)
								PartyFrameXPBar.textureBorder:SetAlpha(0)
							end
						end

						_G["PartyMemberFrame" .. i .. "Debuff" .. 1]:SetPoint(_G["PartyMemberFrame" .. i .. "Debuff" .. 1]:GetPoint())
						ImproveAny:Debug("partymember.lua: PartyFrameXPBar", "think")
						C_Timer.After(1, PartyFrameXPBar.think)
					end

					PartyFrameXPBar.think()
				end
			end

			iaxpready = true
		end
	end

	if (event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_XP_UPDATE") and iaxpready then
		if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" then
			ImproveAny:UpdatePartyXPAPI() -- "connect to the party members"
		end

		local message = UnitXP("PLAYER") .. ";" .. UnitXPMax("PLAYER") -- send xp
		if IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			C_ChatInfo.SendAddonMessage(XPPREFIX, message, "INSTANCE_CHAT")
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			C_ChatInfo.SendAddonMessage(XPPREFIX, message, "PARTY")
		end
	end
end

local frameXPInit = CreateFrame("Frame")
frameXPInit:RegisterEvent("GROUP_ROSTER_UPDATE")
frameXPInit:RegisterEvent("PLAYER_XP_UPDATE")
frameXPInit:RegisterEvent("PLAYER_ENTERING_WORLD")
frameXPInit:SetScript("OnEvent", OnEventXPInit)
