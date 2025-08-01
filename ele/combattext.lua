local _, ImproveAny = ...
local IATabTalents = {}
function ImproveAny:UpdateCombatTextPos()
	if ImproveAny.Setup and ImproveAny:IsEnabled("COMBATTEXTPOSITION", false) and COMBAT_TEXT_LOCATIONS then
		local x = ImproveAny:IAGV("COMBATTEXTX", 0)
		local y = ImproveAny:IAGV("COMBATTEXTY", 0)
		if x ~= 0 or y ~= 0 then
			COMBAT_TEXT_LOCATIONS.startX = x
			COMBAT_TEXT_LOCATIONS.startY = y + 384
			COMBAT_TEXT_LOCATIONS.endX = x
			COMBAT_TEXT_LOCATIONS.endY = y + 609
		end
	end
end

local once = true
function ImproveAny:InitCombatText()
	if ImproveAny:IsEnabled("COMBATTEXTPOSITION", false) or ImproveAny:IsEnabled("COMBATTEXTICONS", false) then
		if once then
			once = false
			IATabBuffs = ImproveAny:GetTalentIcons()
			local cle = CreateFrame("Frame")
			cle:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			cle:SetScript(
				"OnEvent",
				function(sel, eventName, ...)
					if ImproveAny:IsEnabled("COMBATTEXTPOSITION", false) then
						ImproveAny:UpdateCombatTextPos()
					end

					if ImproveAny:IsEnabled("COMBATTEXTICONS", false) then
						cle.tabhot = cle.tabhot or {}
						cle.tabdot = cle.tabdot or {}
						local _, subevent, _, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo()
						local amount = nil
						if subevent == "SPELL_PERIODIC_HEAL" then
							spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())
							if amount then
								cle.tabhot[tonumber(amount)] = select(3, ImproveAny:GetSpellInfo(spellId))
							end
						elseif subevent == "SPELL_PERIODIC_DAMAGE" then
							spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())
							if amount then
								cle.tabdot[tonumber(amount)] = select(3, ImproveAny:GetSpellInfo(spellId))
							end
						elseif subevent == "SPELL_HEAL" then
							spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())
							if amount then
								cle.tabhot[tonumber(amount)] = select(3, ImproveAny:GetSpellInfo(spellId))
							end
						end
					end
				end
			)
		end

		local max = NUM_COMBAT_TEXT_LINES or 0
		for i = 1, max do
			local str = _G["CombatText" .. i]
			if str and str.initsettext == nil then
				str.initsettext = true
				hooksecurefunc(
					str,
					"SetText",
					function(sel, text)
						if sel.iasettext then return end
						sel.iasettext = true
						local hasT = strfind(text, "|T", 1)
						local s1 = strfind(text, "<", 1)
						local s2 = strfind(text, ">", 1)
						local done = false
						if not hasT and s1 and s2 then
							local msg = strsub(text, s1 + 1, s2 - 1)
							local _, _, spellIcon = ImproveAny:GetSpellInfo(msg)
							local talentIcon = IATabTalents[msg]
							local icon = spellIcon or talentIcon or IATabBuffs[msg]
							if icon == nil then
								for id = 1, 32 do
									name, ico, rank, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = ImproveAny:UnitAura("PLAYER", id)
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

							if icon and ImproveAny:IsEnabled("COMBATTEXTICONS", false) then
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

							if cle and cle.tabhot then
								local icon = cle.tabhot[amount]
								if icon and ImproveAny:IsEnabled("COMBATTEXTICONS", false) then
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
					end
				)
			end
		end

		if ImproveAny:IsEnabled("COMBATTEXTPOSITION", false) then
			ImproveAny:UpdateCombatTextPos()
		end

		if max > 1 then
			ImproveAny:Debug("combattext.lua: found")
		else
			ImproveAny:Debug("combattext.lua: not found", "retry")
			C_Timer.After(1, ImproveAny.InitCombatText)
		end
	end
end
