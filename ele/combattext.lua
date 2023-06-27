local _, ImproveAny = ...
local IATabTalents = {}

if GetNumTalentTabs and GetNumTalents and GetTalentInfo then
	for tab = 1, GetNumTalentTabs() do
		for talent = 1, GetNumTalents(tab) do
			local name, icon = GetTalentInfo(tab, talent)

			if name then
				IATabTalents[name] = icon
			end
		end
	end
elseif MAX_TALENT_TIERS and NUM_TALENT_COLUMNS then
	for tier = 1, MAX_TALENT_TIERS do
		for column = 1, NUM_TALENT_COLUMNS do
			local name, icon = GetTalentInfo(tier, column, GetActiveSpecGroup())

			if name then
				IATabTalents[name] = icon
			end
		end
	end
end

local setup = true

function ImproveAny:UpdateCombatTextPos()
	if ImproveAny.Setup and ImproveAny:IsEnabled("COMBATTEXTPOSITION", false) and COMBAT_TEXT_LOCATIONS then
		if setup then
			setup = false
			osx = COMBAT_TEXT_LOCATIONS.startX
			osy = COMBAT_TEXT_LOCATIONS.startY
			oex = COMBAT_TEXT_LOCATIONS.endX
			oey = COMBAT_TEXT_LOCATIONS.endY
		end

		local x = ImproveAny:GV("COMBATTEXTX", 0)
		local y = ImproveAny:GV("COMBATTEXTY", 0)

		if x ~= 0 or y ~= 0 then
			COMBAT_TEXT_LOCATIONS.startX = x
			COMBAT_TEXT_LOCATIONS.startY = y + 384
			COMBAT_TEXT_LOCATIONS.endX = x
			COMBAT_TEXT_LOCATIONS.endY = y + 609
		end
	end
end

local cle = CreateFrame("Frame")
cle:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

cle:SetScript("OnEvent", function(eventName)
	ImproveAny:UpdateCombatTextPos()
	cle.tabhot = cle.tabhot or {}
	cle.tabdot = cle.tabdot or {}
	local _, subevent, _, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo()
	local amount = nil

	if subevent == "SPELL_PERIODIC_HEAL" then
		spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())

		if amount then
			cle.tabhot[tonumber(amount)] = select(3, GetSpellInfo(spellId))
		end
	elseif subevent == "SPELL_PERIODIC_DAMAGE" then
		spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())

		if amount then
			cle.tabdot[tonumber(amount)] = select(3, GetSpellInfo(spellId))
		end
	elseif subevent == "SPELL_HEAL" then
		spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())

		if amount then
			cle.tabhot[tonumber(amount)] = select(3, GetSpellInfo(spellId))
		end
	end
end)

local IATabBuffs = {}

function ImproveAny:InitCombatText()
	local max = NUM_COMBAT_TEXT_LINES or 1
	local found = false

	for i = 1, max do
		local str = _G["CombatText" .. i]

		if str and str.initsettext == nil then
			str.initsettext = true

			hooksecurefunc(str, "SetText", function(sel, text)
				if sel.iasettext then return end
				sel.iasettext = true
				local hasT = strfind(text, "|T", 1)
				local s1 = strfind(text, "<", 1)
				local s2 = strfind(text, ">", 1)
				local done = false

				if not hasT and s1 and s2 then
					local msg = strsub(text, s1 + 1, s2 - 1)
					local _, _, spellIcon = GetSpellInfo(msg)
					local talentIcon = IATabTalents[msg]
					local icon = spellIcon or talentIcon or IATabBuffs[msg]

					if icon == nil then
						for id = 1, 32 do
							name, ico, rank, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("PLAYER", id)

							if name then
								if name == msg then
									IATabBuffs[msg] = ico
									icon = ico
									break
								end
							else
								break
							end
						end
					end

					if icon and ImproveAny:IsEnabled("COMBATTEXTICONS", true) then
						local t = "|T" .. icon .. ":16:16:-8:-8|t" .. " " .. text
						sel:SetText(t)
						done = true
					end
				end

				if not done then
					local amount = nil
					local s3 = strfind(text, "+", 1)

					if s3 then
						local val = strsub(text, s3 + 1)
						val = gsub(val, "%.", "")
						amount = tonumber(val)
					end

					if cle.tabhot then
						local icon = cle.tabhot[amount]

						if icon and ImproveAny:IsEnabled("COMBATTEXTICONS", true) then
							local t = "|T" .. icon .. ":16:16:-8:-8|t" .. " " .. text
							sel:SetText(t)
						else
							sel:SetText(text)
						end
					else
						sel:SetText(text)
					end
				end

				sel.iasettext = false
			end)

			found = true
		end
	end

	ImproveAny:UpdateCombatTextPos()

	if found then
		C_Timer.After(0.1, ImproveAny.InitCombatText)
	else
		C_Timer.After(1, ImproveAny.InitCombatText)
	end
end

ImproveAny:InitCombatText()