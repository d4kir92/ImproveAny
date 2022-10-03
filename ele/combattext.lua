
local AddOnName, ImproveAny = ...

local IATabTalents = {}
if GetNumTalentTabs and GetNumTalents and GetTalentInfo then
	for tab = 1, GetNumTalentTabs() do
		for talent = 1, GetNumTalents( tab ) do
			local name, icon = GetTalentInfo( tab, talent )
			if name then
				IATabTalents[name] = icon
			end
		end
	end
elseif MAX_TALENT_TIERS and NUM_TALENT_COLUMNS then
	for tier = 1, MAX_TALENT_TIERS do
		for column = 1, NUM_TALENT_COLUMNS do
			local name, icon = GetTalentInfo( tier, column, GetActiveSpecGroup() )
			if name then
				IATabTalents[name] = icon
			end
		end
	end
end

local cle = CreateFrame( "Frame" )
cle:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
cle:SetScript( "OnEvent", function( eventName)
	cle.tabhot = cle.tabhot or {}
	cle.tabdot = cle.tabdot or {}
	
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
	if subevent == "SPELL_PERIODIC_HEAL" then
		spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())
		if amount then
			cle.tabhot[tonumber( amount )] = select( 3, GetSpellInfo( spellId ) )
		end
	elseif subevent == "SPELL_PERIODIC_DAMAGE" then
		spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())
		if amount then
			cle.tabdot[tonumber( amount )] = select( 3, GetSpellInfo( spellId ) )
		end
	elseif subevent == "SPELL_HEAL" then
		spellId, spellName, spellSchool, amount = select(12, CombatLogGetCurrentEventInfo())
		if amount then
			cle.tabhot[tonumber( amount )] = select( 3, GetSpellInfo( spellId ) )
		end
	else
		--print(subevent) -- DEBUG
	end
end )

local IATabBuffs = {}
function IAInitCombatText()
	local max = NUM_COMBAT_TEXT_LINES or 1
	for i = 1, max do
		str = _G["CombatText" .. i]
		if str and str.initsettext == nil then
			str.initsettext = true

			hooksecurefunc( str, "SetText", function( self, text )
				if self.iasettext then return end
				self.iasettext = true
				local hasT = strfind( text, "|T", 1 )
				local s1 = strfind( text, "<", 1 )
				local s2 = strfind( text, ">", 1 )
				local done = false
				if not hasT and s1 and s2 then
					local msg = strsub( text, s1 + 1, s2 - 1 )
					local _, _, spellIcon = GetSpellInfo( msg )
					local talentIcon = IATabTalents[msg]
					local icon = spellIcon or talentIcon or IATabBuffs[msg]
					if icon == nil then
						for i = 1, 32 do
							name, ico, rank, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff( "PLAYER", i )
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
					if icon and ImproveAny:IsEnabled( "COMBATTEXTICONS", true ) then
						local t = "|T" .. icon .. ":16:16:-8:-8|t" .. " " .. text
						self:SetText( t )
						done = true
					end
				end
				if not done then
					local amount = nil
					local s1 = strfind( text, "+", 1 )
					if s1 then
						local val = strsub( text, s1 + 1 )
						val = gsub( val, "%.", "" )
						amount = tonumber( val )
					end
					if cle.tabhot then
						local icon = cle.tabhot[amount]
						if icon and ImproveAny:IsEnabled( "COMBATTEXTICONS", true ) then
							local t = "|T" .. icon .. ":16:16:-8:-8|t" .. " " .. text
							self:SetText( t )
						else
							self:SetText( text )
						end
					else
						self:SetText( text )
					end
				end
				self.iasettext = false
			end )
		end
	end

	C_Timer.After( 0.1, IAInitCombatText )
end
IAInitCombatText()
