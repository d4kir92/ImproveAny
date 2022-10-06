
local AddOnName, ImproveAny = ...

function ImproveAny:InitRaidFrames()
	if IABUILD ~= "RETAIL" then
		local raidFrames = {}

		function ImproveAny:IsCompactRaidFrame( frame )
			if frame == nil then
				return false
			end
			if frame.buffFrames then
				if string.find( frame:GetName(), "CompactUnitFrame" ) then
					return true
				end
			end
			return false
		end

		function ImproveAny:RFModifySetSize( frame )
			if frame == nil then 
				return
			end

			if InCombatLockdown() then
				C_Timer.After( 0.1, function()
					if frame then 
						ImproveAny:RFModifySetSize( frame )
					end
				end )
			else
				local sw, sh = frame:GetSize()
				hooksecurefunc( frame, "SetSize", function( self, sw, sh )
					if self.iasetsize then return end
					self.iasetsize = true
					local options = DefaultCompactMiniFrameSetUpOptions
					if ImproveAny:IsEnabled( "OVERWRITERAIDFRAMESIZE", false ) and IAGV( "RAIDFRAMEW", options.width ) and IAGV( "RAIDFRAMEH", options.height ) then
						frame:SetSize( IAGV( "RAIDFRAMEW", options.width ), IAGV( "RAIDFRAMEH", options.height ) )
					end
					self.iasetsize = false
				end )
				frame:SetSize( sw, sh )
			end
		end

		if CompactUnitFrame_UpdateAll then
			hooksecurefunc( "CompactUnitFrame_UpdateAll", function( frame )
				if not ImproveAny:IsCompactRaidFrame( frame ) then
					return
				end

				if not ImproveAny:IsEnabled( "OVERWRITERAIDFRAMESIZE", false ) then
					return
				end

				if not tContains( raidFrames, frame ) then
					tinsert( raidFrames, frame )

					ImproveAny:RFModifySetSize( frame )
				end
			end )
		end

		function ImproveAny:RFAddBuffs( frame )
			if not ImproveAny:IsCompactRaidFrame( frame ) then
				return
			end

			if frame.GetName and frame:GetName() and frame.setup == nil then
				frame.setup = true

				hooksecurefunc( _G[frame:GetName() .. "Buff" .. 1], "SetSize", function( self, w, h )
					local sw, sh = _G[frame:GetName() .. "Buff" .. 1]:GetSize()
					for i = 4, 10 do
						if _G[frame:GetName() .. "Buff" .. i] ~= nil then
							_G[frame:GetName() .. "Buff" .. i]:SetSize( sw, sh )
						end
					end
				end )
				_G[frame:GetName() .. "Buff" .. 1]:SetSize(_G[frame:GetName() .. "Buff" .. 1]:GetSize())
				
				hooksecurefunc( _G[frame:GetName() .. "Debuff" .. 1], "SetSize", function( self, w, h )
					local sw, sh = _G[frame:GetName() .. "Debuff" .. 1]:GetSize()
					for i = 4, 10 do
						if _G[frame:GetName() .. "Debuff" .. i] ~= nil then
							_G[frame:GetName() .. "Debuff" .. i]:SetSize( sw, sh )
						end
					end
				end )
				_G[frame:GetName() .. "Debuff" .. 1]:SetSize(_G[frame:GetName() .. "Debuff" .. 1]:GetSize())
			end
			if frame.buffFrames then
				if _G[frame:GetName() .. "Buff" .. 1] then
					local sw, sh = _G[frame:GetName() .. "Buff" .. 1]:GetSize()
					for i = 4, 10 do
						if _G[frame:GetName() .. "Buff" .. i] == nil then
							_G[frame:GetName() .. "Buff" .. i] = CreateFrame( "Button", frame:GetName() .. "Buff" .. i, frame, "CompactBuffTemplate" )
							local buff = _G[frame:GetName() .. "Buff" .. i]
							buff:SetParent( frame )
							buff:SetSize( sw, sh )
							buff:SetPoint( "BOTTOMRIGHT", _G[frame:GetName() .. "Buff" .. (i-1)], "BOTTOMLEFT", 0, 0 )
							buff:Hide()
						end
					end
				end
			end
		end

		function ImproveAny:RFAddDebuffs( frame )
			if not ImproveAny:IsCompactRaidFrame( frame ) then
				return
			end

			if frame.debuffFrames then
				if _G[frame:GetName() .. "Debuff" .. 1] then
					local sw, sh = _G[frame:GetName() .. "Debuff" .. 1]:GetSize()
					for i = 4, 10 do
						if _G[frame:GetName() .. "Debuff" .. i] == nil then
							_G[frame:GetName() .. "Debuff" .. i] = CreateFrame( "Button", frame:GetName() .. "Debuff" .. i, frame, "CompactDebuffTemplate" )
							local debuff = _G[frame:GetName() .. "Debuff" .. i]
							debuff:SetParent( frame )
							debuff:SetSize( sw, sh )
							debuff:SetPoint( "BOTTOMLEFT", _G[frame:GetName() .. "Debuff" .. (i-1)], "BOTTOMRIGHT", 0, 0 )
							debuff:Hide()
						end
					end
				end
			end
		end

		if CompactUnitFrame_HideAllBuffs then
			hooksecurefunc( "CompactUnitFrame_HideAllBuffs", function( frame )
				if not ImproveAny:IsCompactRaidFrame( frame ) then
					return
				end

				if frame then
					ImproveAny:RFAddBuffs( frame )

					for i = 1, 10 do
						local buff = _G[frame:GetName() .. "Buff" .. i]
						if buff then
							buff:Hide()
						end
					end
				end
			end )
		end

		if CompactUnitFrame_HideAllDebuffs then
			hooksecurefunc( "CompactUnitFrame_HideAllDebuffs", function( frame )
				if not ImproveAny:IsCompactRaidFrame( frame ) then
					return
				end

				ImproveAny:RFAddDebuffs( frame )
				if frame then
					for i = 1, 10 do
						local debuff = _G[frame:GetName() .. "Debuff" .. i]
						if debuff then
							debuff:Hide()
						end
					end
				end
			end )
		end

		function IA_CompactUnitFrame_UpdateCooldownFrame( frame, expirationTime, duration )
			if GetClassicExpansionLevel() < LE_EXPANSION_BURNING_CRUSADE then
				return
			end

			local enabled = expirationTime and expirationTime ~= 0
			if enabled then
				local startTime = expirationTime - duration
				CooldownFrame_Set( frame.cooldown, startTime, duration, true )
			else
				CooldownFrame_Clear( frame.cooldown )
			end
		end

		function IA_CompactUnitFrame_UtilSetBuff( buffFrame, unit, index, filter )
			local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter)
			buffFrame.icon:SetTexture(icon)
			if ( count > 1 ) then
				local countText = count
				if ( count >= 100 ) then
					countText = BUFF_STACKS_OVERFLOW
				end
				buffFrame.count:Show()
				buffFrame.count:SetText(countText)
			else
				buffFrame.count:Hide()
			end
			buffFrame:SetID(index)
			IA_CompactUnitFrame_UpdateCooldownFrame(buffFrame, expirationTime, duration)
			buffFrame:Show()
		end

		function IA_CompactUnitFrame_UtilSetDebuff( debuffFrame, unit, index, filter, isBossAura, isBossBuff )
			-- make sure you are using the correct index here!
			--isBossAura says make this look large.
			--isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
			local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId
			if (isBossBuff) then
				name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitBuff(unit, index, filter)
			else
				name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(unit, index, filter)
			end
			debuffFrame.filter = filter
			debuffFrame.icon:SetTexture(icon)
			if ( count > 1 ) then
				local countText = count
				if ( count >= 100 ) then
					countText = BUFF_STACKS_OVERFLOW
				end
				debuffFrame.count:Show()
				debuffFrame.count:SetText(countText)
			else
				debuffFrame.count:Hide()
			end
			debuffFrame:SetID(index)
			IA_CompactUnitFrame_UpdateCooldownFrame(debuffFrame, expirationTime, duration)

			local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"]
			debuffFrame.border:SetVertexColor(color.r, color.g, color.b)

			debuffFrame.isBossBuff = isBossBuff
			if ( isBossAura ) then
				local size = min(debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE, debuffFrame.maxHeight)
				debuffFrame:SetSize(size, size)
			else
				debuffFrame:SetSize(debuffFrame.baseSize, debuffFrame.baseSize)
			end

			debuffFrame:Show()
		end

		if CompactUnitFrame_UpdateBuffs then
			hooksecurefunc( "CompactUnitFrame_UpdateBuffs", function( frame )
				if not ImproveAny:IsCompactRaidFrame( frame ) then
					return
				end

				if ImproveAny:IsEnabled( "RAIDFRAMEMOREBUFFS", true ) then
					ImproveAny:RFAddBuffs( frame )

					local index = 1
					local frameNum = 1
					local filter = nil
					while ( frameNum <= 10 ) do
						if frame.displayedUnit then
							local buffName = UnitBuff(frame.displayedUnit, index, filter)
							if ( buffName ) then
								if ( CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
									local buffFrame =  _G[frame:GetName() .. "Buff" .. frameNum]
									if buffFrame then
										IA_CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter)
									end
									frameNum = frameNum + 1
								end
							else
								break
							end
						else
							break
						end
						index = index + 1
					end

					for i = frameNum, 10 do
						local buffFrame = _G[frame:GetName() .. "Buff" .. i]
						if buffFrame then
							buffFrame:Hide()
						end
					end
				end
			end )
		end

		if CompactUnitFrame_UpdateDebuffs then
			hooksecurefunc( "CompactUnitFrame_UpdateDebuffs", function( frame )
				if not ImproveAny:IsCompactRaidFrame( frame ) then
					return
				end

				if ImproveAny:IsEnabled( "RAIDFRAMEMOREBUFFS", true ) then
					ImproveAny:RFAddDebuffs( frame )
					
					local index = 1
					local frameNum = 1
					local filter = nil

					while ( frameNum <= 10 ) do
						if frame.displayedUnit then
							local debuffName = UnitDebuff(frame.displayedUnit, index, filter)
							if ( debuffName ) then
								if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) ) then
									local debuffFrame = _G[frame:GetName() .. "Debuff" .. frameNum]
									if debuffFrame then
										IA_CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, false)
									end
									frameNum = frameNum + 1
									--Boss debuffs are about twice as big as normal debuffs, so display one less.
									local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
									maxDebuffs = maxDebuffs - (bossDebuffScale - 1)
								else
									break
								end
							else
								break
							end
						else
							break
						end
						index = index + 1
					end

					--Then we go through all the buffs looking for any boss flagged ones.
					index = 1
					while ( frameNum <= 10 ) do
						if frame.displayedUnit then
							local debuffName = UnitBuff(frame.displayedUnit, index, filter)
							if ( debuffName ) then
								if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
									local debuffFrame = _G[frame:GetName() .. "Debuff" .. frameNum]
									if debuffFrame then
										IA_CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, true)
									end
									frameNum = frameNum + 1
									--Boss debuffs are about twice as big as normal debuffs, so display one less.
									local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
									maxDebuffs = maxDebuffs - (bossDebuffScale - 1)
								else
									break
								end
							else
								break
							end
						else
							break
						end
						index = index + 1
					end

					--Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
					index = 1
					while ( frameNum <= 10 ) do
						if frame.displayedUnit then
							local debuffName = UnitDebuff(frame.displayedUnit, index, filter)
							if ( debuffName ) then
								if ( CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) ) then
									local debuffFrame = _G[frame:GetName() .. "Debuff" .. frameNum]
									if debuffFrame then
										IA_CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false)
									end
									frameNum = frameNum + 1
								else
									break
								end
							else
								break
							end
						else
							break
						end
						index = index + 1
					end

					if ( frame.optionTable.displayOnlyDispellableDebuffs ) then
						filter = "RAID"
					end

					index = 1
					--Now, we display all normal debuffs.
					if ( frame.optionTable.displayNonBossDebuffs ) then
						while ( frameNum <= 10 ) do
							if frame.displayedUnit then
								local debuffName = UnitDebuff(frame.displayedUnit, index, filter)
								if ( debuffName ) then
									if ( CompactUnitFrame_UtilShouldDisplayDebuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) and
										not CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter)) then
										local debuffFrame = _G[frame:GetName() .. "Debuff" .. frameNum]
										if debuffFrame then
											IA_CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false)
										end
										frameNum = frameNum + 1
									else
										break
									end
								else
									break
								end
							else
								break
							end
							index = index + 1
						end
					end

					for i = frameNum, 10 do
						local debuffFrame = _G[frame:GetName() .. "Debuff" .. i]
						if debuffFrame then
							debuffFrame:Hide()
						end
					end
				end
			end )
		end

		local old1 = ""
		local old2 = ""
		function ImproveAny:ShowMsgForBuffs()
			if old1 ~= IAGV( "RFHIDEBUFFIDSINCOMBAT", "" ) then
				old1 = IAGV( "RFHIDEBUFFIDSINCOMBAT", "" )
				local text = string.gsub( old1, ",", "\n" )
				ImproveAny:MSG( "[HIDE-BUFFS] Hide Buffs In Combat changed to: \n" .. text )
			end

			if old2 ~= IAGV( "RFHIDEBUFFIDSINNOTCOMBAT", "" ) then
				old2 = IAGV( "RFHIDEBUFFIDSINNOTCOMBAT", "" )
				local text = string.gsub( old1, ",", "\n" )
				ImproveAny:MSG( "[HIDE-BUFFS] Hide Buffs Outside of Combat changed to: " .. text )
			end
		end

		if CompactUnitFrame_UtilShouldDisplayBuff then
			local oldInCombatIds = ""
			local inCombatIds = {}
		
			local oldInNotCombatIds = ""
			local inNotCombatIds = {}
			
			function CompactUnitFrame_UtilShouldDisplayBuff( unit, index, filter )
				local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter)

				local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT")

				if oldInCombatIds ~= IAGV( "RFHIDEBUFFIDSINCOMBAT", "" ) then
					oldInCombatIds = IAGV( "RFHIDEBUFFIDSINCOMBAT", "" )
					inCombatIds = {strsplit(",", oldInCombatIds)}
				end
		
				if oldInNotCombatIds ~= IAGV( "RFHIDEBUFFIDSINNOTCOMBAT", "" ) then
					oldInNotCombatIds = IAGV( "RFHIDEBUFFIDSINNOTCOMBAT", "" )
					inNotCombatIds = {strsplit(",", oldInNotCombatIds)}
				end
		
				if InCombatLockdown() and tContains( inCombatIds, spellId .. "" ) then
					return false
				end

				if not InCombatLockdown() and tContains( inNotCombatIds, spellId .. "" ) then
					return false
				end

				if ( hasCustom ) then
					return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"))
				else
					return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellId)
				end
			end
		end
	end
end