
local AddOnName, ImproveAny = ...

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
	C_UI.Reload()
end

IABUILDNR = select(4, GetBuildInfo())
IABUILD = "CLASSIC"
if IABUILDNR > 90000 then
	IABUILD = "RETAIL"
elseif IABUILDNR > 29999 then
	IABUILD = "WRATH"
elseif IABUILDNR > 19999 then
	IABUILD = "TBC"
end

function IAMathC( val, vmin, vmax )
	if val == nil then
		return 0
	end
	if vmin == nil then
		return 0
	end
	if vmax == nil then
		return 1
	end
	if val < vmin then
		return vmin
	elseif val > vmax then
		return vmax
	else
		return val
	end
end



SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
	C_UI.Reload()
end

SLASH_IMAN1, SLASH_IMAN2 = "/iman", "/improveany"
SlashCmdList["IMAN"] = function(msg)
	ImproveAny:ToggleSettings()
end



IAHIDDEN = CreateFrame( "FRAME", "IAHIDDEN" )
IAHIDDEN:Hide()

hooksecurefunc( "CompactUnitFrame_UtilShouldDisplayBuff", function( unit, index, filter )
	if unit then
		local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);

		local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
		
		if ( name == "Dornen" or name == "Thorns" ) and InCombatLockdown() then
			return false
		end

		if ( hasCustom ) then
			return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
		else
			return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellId);
		end
	end
end )

hooksecurefunc( "CompactUnitFrame_SetMaxBuffs", function( frame, numBuffs )
	if frame.initbuffs == nil then
		frame.initbuffs = true

		hooksecurefunc( frame, "SetSize", function( self, sw, sh )
			if self.iasetsize then return end
			self.iasetsize = true
			local options = DefaultCompactMiniFrameSetUpOptions;
			if ImproveAny:IsEnabled( "OVERWRITERAIDFRAMESIZE", false ) and IAGV( "RAIDFRAMEW", options.width ) and IAGV( "RAIDFRAMEH", options.height ) then
				frame:SetSize( IAGV( "RAIDFRAMEW", options.width ), IAGV( "RAIDFRAMEH", options.height ) );
			end
			self.iasetsize = false
		end )

		local sw, sh = frame.buffFrames[1]:GetSize()
		for i = 4, 10 do
			frame.buffFrames[i] = CreateFrame( "Button", frame:GetName() .. "Buff" .. i, frame, "CompactBuffTemplate" )
		end
	end

	frame.maxBuffs = 10;
end )

hooksecurefunc( "CompactUnitFrame_SetMaxDebuffs", function( frame, numBuffs )
	
	if frame.initdebuffs == nil then
		frame.initdebuffs = true

		local sw, sh = frame.debuffFrames[1]:GetSize()
		for i = 4, 10 do
			frame.debuffFrames[i] = CreateFrame( "Button", frame:GetName() .. "Debuff" .. i, frame, "CompactDebuffTemplate" )
		end
	end

	frame.maxDebuffs = 10;
end )

function ImproveAny:Event( event, ... )
	if ImproveAny.Setup == nil then
		ImproveAny.Setup = true

		if IsAddOnLoaded("D4KiR MoveAndImprove") then
			ImproveAny:MSG( "DON'T use MoveAndImprove, when you use ImproveAny" )
		end

		ImproveAny:InitDB()

		if ImproveAny:IsEnabled( "CASTBAR", true ) then
			ImproveAny:InitCastBar()
		end
		if ImproveAny:IsEnabled( "DURABILITY", true ) then
			ImproveAny:InitDurabilityFrame()
		end
		ImproveAny:InitItemLevel()
		ImproveAny:InitMinimap()
		ImproveAny:InitMoneyBar()
		ImproveAny:InitTokenBar()
		ImproveAny:InitSkillBars()
		if ImproveAny:IsEnabled( "BAGS", true ) then
			ImproveAny:InitBags()
		end
		if ImproveAny:IsEnabled( "WORLDMAP", true ) then
			ImproveAny:InitWorldMapFrame()
		end
		ImproveAny:InitXPBar()
		
		ImproveAny:InitIASettings()

		if ImproveAny:IsEnabled( "CHAT", true ) then
			ImproveAny:InitChat()
			IAUpdateChatChannels()
		end

		C_Timer.After( 1, function()
			for i = 2.6, 4.1, 0.1 do
				ConsoleExec( "cameraDistanceMaxZoomFactor " .. i )
			end
			ConsoleExec( "WorldTextScale " .. 1.2 )
		end )

		function ImproveAny:UpdateMinimapButton()
			if IAMMBTN then
				if ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
					IAMMBTN:Show("ImproveAnyMinimapIcon")
				else
					IAMMBTN:Hide("ImproveAnyMinimapIcon")
				end
			end
		end

		function ImproveAny:ToggleMinimapButton()
			ImproveAny:SetEnabled( "SHOWMINIMAPBUTTON", not ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) )
			if IAMMBTN then
				if ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
					IAMMBTN:Show("ImproveAnyMinimapIcon")
				else
					IAMMBTN:Hide("ImproveAnyMinimapIcon")
				end
			end
		end
		
		function ImproveAny:HideMinimapButton()
			ImproveAny:SetEnabled( "SHOWMINIMAPBUTTON", false )
			if IAMMBTN then
				IAMMBTN:Hide("ImproveAnyMinimapIcon")
			end
		end
		
		function ImproveAny:ShowMinimapButton()
			ImproveAny:SetEnabled( "SHOWMINIMAPBUTTON", true )
			if IAMMBTN then
				IAMMBTN:Show("ImproveAnyMinimapIcon")
			end
		end

		local ImproveAnyMinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("ImproveAnyMinimapIcon", {
			type = "data source",
			text = "ImproveAnyMinimapIcon",
			icon = 136033,
			OnClick = function(self, btn)
				if btn == "LeftButton" then
					ImproveAny:ToggleSettings()
				elseif btn == "RightButton" then
					ImproveAny:HideMinimapButton()
				end
			end,
			OnTooltipShow = function(tooltip)
				if not tooltip or not tooltip.AddLine then return end
				tooltip:AddLine( "ImproveAny")
				tooltip:AddLine( IAGT( "MMBTNLEFT" ) )
				tooltip:AddLine( IAGT( "MMBTNRIGHT" ) )
			end,
		})
		if ImproveAnyMinimapIcon then
			IAMMBTN = LibStub("LibDBIcon-1.0", true)
			if IAMMBTN then
				IAMMBTN:Register( "ImproveAnyMinimapIcon", ImproveAnyMinimapIcon, ImproveAny:GetMinimapTable() )
			end
		end

		if IAMMBTN then
			if ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
				IAMMBTN:Show("ImproveAnyMinimapIcon")
			else
				IAMMBTN:Hide("ImproveAnyMinimapIcon")
			end
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript( "OnEvent", ImproveAny.Event )
f:RegisterEvent( "PLAYER_LOGIN" )
f.incombat = false 



local ts = 0
function FastLooting()
    if GetTime() - ts >= 0.2 and ImproveAny:IsEnabled( "FASTLOOTING", true ) then
        ts = GetTime()
        if GetCVarBool( "autoLootDefault" ) ~= IsModifiedClick( "AUTOLOOTTOGGLE" ) then
            for i = GetNumLootItems(), 1, -1 do
                LootSlot( i )
            end
            ts = GetTime()
        end
    end
end

local f = CreateFrame( "Frame" )
f:RegisterEvent( "LOOT_READY" )
f:SetScript( "OnEvent", FastLooting )




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
						if icon then
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
