local _, ImproveAny = ...
function ImproveAny:InitRaidFrames()
	if ImproveAny:GetWoWBuild() ~= "RETAIL" then
		local raidFrames = {}
		function ImproveAny:IsCompactRaidFrame(frame)
			if frame == nil then return false end
			if frame.buffFrames and string.find(ImproveAny:GetName(frame), "CompactUnitFrame") then return true end

			return false
		end

		function ImproveAny:RFModifySetSize(frame)
			if frame == nil then return end
			if InCombatLockdown() then
				ImproveAny:Debug("raidframe.lua: RFModifySetSize")
				ImproveAny:After(
					0.1,
					function()
						if frame then
							ImproveAny:RFModifySetSize(frame)
						end
					end, "ImproveAny:RFModifySetSize(frame)"
				)
			else
				local sw, sh = frame:GetSize()
				hooksecurefunc(
					frame,
					"SetSize",
					function(sel, sw1, sh1)
						if sel.iasetsize then return end
						sel.iasetsize = true
						local options = DefaultCompactMiniFrameSetUpOptions
						if ImproveAny:IsEnabled("OVERWRITERAIDFRAMESIZE", false) and ImproveAny:IAGV("RAIDFRAMEW", options.width) and ImproveAny:IAGV("RAIDFRAMEH", options.height) then
							frame:SetSize(ImproveAny:IAGV("RAIDFRAMEW", options.width or 30), ImproveAny:IAGV("RAIDFRAMEH", options.height or 30))
						end

						sel.iasetsize = false
					end
				)

				frame:SetSize(sw, sh)
			end
		end

		if CompactUnitFrame_UpdateAll and ImproveAny:IsEnabled("OVERWRITERAIDFRAMESIZE", false) then
			hooksecurefunc(
				"CompactUnitFrame_UpdateAll",
				function(frame)
					if not ImproveAny:IsCompactRaidFrame(frame) then return end
					if not ImproveAny:IsEnabled("OVERWRITERAIDFRAMESIZE", false) then return end
					if not tContains(raidFrames, frame) then
						tinsert(raidFrames, frame)
						ImproveAny:RFModifySetSize(frame)
					end
				end
			)
		end

		function ImproveAny:RFAddBuffs(frame)
			if not ImproveAny:IsCompactRaidFrame(frame) then return end
			if ImproveAny:GetName(frame) and frame.setup == nil then
				frame.setup = true
				hooksecurefunc(
					_G[ImproveAny:GetName(frame) .. "Buff" .. 1],
					"SetSize",
					function(sel, w, h)
						local sw, sh = _G[ImproveAny:GetName(frame) .. "Buff" .. 1]:GetSize()
						for i = 4, 10 do
							if _G[ImproveAny:GetName(frame) .. "Buff" .. i] ~= nil then
								_G[ImproveAny:GetName(frame) .. "Buff" .. i]:SetSize(sw, sh)
							end
						end
					end
				)

				_G[ImproveAny:GetName(frame) .. "Buff" .. 1]:SetSize(_G[ImproveAny:GetName(frame) .. "Buff" .. 1]:GetSize())
				hooksecurefunc(
					_G[ImproveAny:GetName(frame) .. "Debuff" .. 1],
					"SetSize",
					function(sel, w, h)
						local sw, sh = _G[ImproveAny:GetName(frame) .. "Debuff" .. 1]:GetSize()
						for i = 4, 10 do
							if _G[ImproveAny:GetName(frame) .. "Debuff" .. i] ~= nil then
								_G[ImproveAny:GetName(frame) .. "Debuff" .. i]:SetSize(sw, sh)
							end
						end
					end
				)

				_G[ImproveAny:GetName(frame) .. "Debuff" .. 1]:SetSize(_G[ImproveAny:GetName(frame) .. "Debuff" .. 1]:GetSize())
			end

			if frame.buffFrames and _G[ImproveAny:GetName(frame) .. "Buff" .. 1] then
				local sw, sh = _G[ImproveAny:GetName(frame) .. "Buff" .. 1]:GetSize()
				for i = 4, 10 do
					if _G[ImproveAny:GetName(frame) .. "Buff" .. i] == nil then
						_G[ImproveAny:GetName(frame) .. "Buff" .. i] = CreateFrame("Button", ImproveAny:GetName(frame) .. "Buff" .. i, frame, "CompactBuffTemplate")
						local buff = _G[ImproveAny:GetName(frame) .. "Buff" .. i]
						buff:SetParent(frame)
						buff:SetSize(sw, sh)
						buff:SetPoint("BOTTOMRIGHT", _G[ImproveAny:GetName(frame) .. "Buff" .. (i - 1)], "BOTTOMLEFT", 0, 0)
						buff:Hide()
					end
				end
			end
		end

		function ImproveAny:RFAddDebuffs(frame)
			if not ImproveAny:IsCompactRaidFrame(frame) then return end
			if frame.debuffFrames and _G[ImproveAny:GetName(frame) .. "Debuff" .. 1] then
				local sw, sh = _G[ImproveAny:GetName(frame) .. "Debuff" .. 1]:GetSize()
				for i = 4, 10 do
					if _G[ImproveAny:GetName(frame) .. "Debuff" .. i] == nil then
						_G[ImproveAny:GetName(frame) .. "Debuff" .. i] = CreateFrame("Button", ImproveAny:GetName(frame) .. "Debuff" .. i, frame, "CompactDebuffTemplate")
						local debuff = _G[ImproveAny:GetName(frame) .. "Debuff" .. i]
						debuff:SetParent(frame)
						debuff:SetSize(sw, sh)
						debuff:SetPoint("BOTTOMLEFT", _G[ImproveAny:GetName(frame) .. "Debuff" .. (i - 1)], "BOTTOMRIGHT", 0, 0)
						debuff:Hide()
					end
				end
			end
		end

		if CompactUnitFrame_HideAllBuffs then
			hooksecurefunc(
				"CompactUnitFrame_HideAllBuffs",
				function(frame)
					if not ImproveAny:IsCompactRaidFrame(frame) then return end
					if frame then
						ImproveAny:RFAddBuffs(frame)
						for i = 1, 10 do
							local buff = _G[ImproveAny:GetName(frame) .. "Buff" .. i]
							if buff then
								buff:Hide()
							end
						end
					end
				end
			)
		end

		if CompactUnitFrame_HideAllDebuffs then
			hooksecurefunc(
				"CompactUnitFrame_HideAllDebuffs",
				function(frame)
					if not ImproveAny:IsCompactRaidFrame(frame) then return end
					if frame then
						ImproveAny:RFAddDebuffs(frame)
						for i = 1, 10 do
							local debuff = _G[ImproveAny:GetName(frame) .. "Debuff" .. i]
							if debuff then
								debuff:Hide()
							end
						end
					end
				end
			)
		end

		function ImproveAny:_CompactUnitFrame_UpdateCooldownFrame(frame, expirationTime, duration)
			if GetClassicExpansionLevel() < LE_EXPANSION_BURNING_CRUSADE then return end
			local enabled = expirationTime and expirationTime ~= 0
			if enabled then
				local startTime = expirationTime - duration
				CooldownFrame_Set(frame.cooldown, startTime, duration, true)
			else
				CooldownFrame_Clear(frame.cooldown)
			end
		end

		function ImproveAny:CompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter)
			local _, icon, count, _, duration, expirationTime, _, _, _, _, _ = ImproveAny:UnitAura(unit, index, filter)
			buffFrame.icon:SetTexture(icon)
			if count > 1 then
				local countText = count
				if count >= 100 then
					countText = BUFF_STACKS_OVERFLOW
				end

				buffFrame.count:Show()
				buffFrame.count:SetText(countText)
			else
				buffFrame.count:Hide()
			end

			buffFrame:SetID(index)
			ImproveAny:CompactUnitFrame_UpdateCooldownFrame(buffFrame, expirationTime, duration)
			buffFrame:Show()
		end

		function ImproveAny:_CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
			-- make sure you are using the correct index here!
			--isBossAura says make this look large.
			--isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
			local _, icon, count, debuffType, duration, expirationTime, _, _, _, _
			if isBossBuff then
				_, icon, count, debuffType, duration, expirationTime, _, _, _, _ = ImproveAny:UnitAura(unit, index, filter)
			else
				_, icon, count, debuffType, duration, expirationTime, _, _, _, _ = ImproveAny:UnitAura(unit, index, filter)
			end

			debuffFrame.filter = filter
			debuffFrame.icon:SetTexture(icon)
			if count > 1 then
				local countText = count
				if count >= 100 then
					countText = BUFF_STACKS_OVERFLOW
				end

				debuffFrame.count:Show()
				debuffFrame.count:SetText(countText)
			else
				debuffFrame.count:Hide()
			end

			debuffFrame:SetID(index)
			ImproveAny:CompactUnitFrame_UpdateCooldownFrame(debuffFrame, expirationTime, duration)
			local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"]
			debuffFrame.border:SetVertexColor(color.r, color.g, color.b)
			debuffFrame.isBossBuff = isBossBuff
			if isBossAura then
				local size = min(debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE, debuffFrame.maxHeight)
				debuffFrame:SetSize(size, size)
			else
				debuffFrame:SetSize(debuffFrame.baseSize, debuffFrame.baseSize)
			end

			debuffFrame:Show()
		end

		if CompactUnitFrame_UpdateBuffs then
			hooksecurefunc(
				"CompactUnitFrame_UpdateBuffs",
				function(frame)
					if not ImproveAny:IsCompactRaidFrame(frame) then return end
					if ImproveAny:IsEnabled("RAIDFRAMEMOREBUFFS", false) then
						ImproveAny:RFAddBuffs(frame)
						local index = 1
						local frameNum = 1
						local filter = nil
						while frameNum <= 10 do
							if frame.displayedUnit then
								local buffName = ImproveAny:UnitAura(frame.displayedUnit, index, filter)
								if buffName then
									if CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) then
										local buffFrame = _G[ImproveAny:GetName(frame) .. "Buff" .. frameNum]
										if buffFrame then
											ImproveAny:CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter)
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
							local buffFrame = _G[ImproveAny:GetName(frame) .. "Buff" .. i]
							if buffFrame then
								buffFrame:Hide()
							end
						end
					end
				end
			)
		end

		if CompactUnitFrame_UpdateDebuffs then
			hooksecurefunc(
				"CompactUnitFrame_UpdateDebuffs",
				function(frame)
					if not ImproveAny:IsCompactRaidFrame(frame) then return end
					if ImproveAny:IsEnabled("RAIDFRAMEMOREBUFFS", false) then
						ImproveAny:RFAddDebuffs(frame)
						local index = 1
						local frameNum = 1
						local filter = nil
						while frameNum <= 10 do
							if frame.displayedUnit then
								local debuffName = ImproveAny:UnitAura(frame.displayedUnit, index, filter)
								if debuffName then
									if CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) then
										local debuffFrame = _G[ImproveAny:GetName(frame) .. "Debuff" .. frameNum]
										if debuffFrame then
											ImproveAny:CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, false)
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

						--Then we go through all the buffs looking for any boss flagged ones.
						index = 1
						while frameNum <= 10 do
							if frame.displayedUnit then
								local debuffName = ImproveAny:UnitAura(frame.displayedUnit, index, filter)
								if debuffName then
									if CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) then
										local debuffFrame = _G[ImproveAny:GetName(frame) .. "Debuff" .. frameNum]
										if debuffFrame then
											ImproveAny:CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, true)
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

						--Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
						index = 1
						while frameNum <= 10 do
							if frame.displayedUnit then
								local debuffName = ImproveAny:UnitAura(frame.displayedUnit, index, filter)
								if debuffName then
									if CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) then
										local debuffFrame = _G[ImproveAny:GetName(frame) .. "Debuff" .. frameNum]
										if debuffFrame then
											ImproveAny:CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false)
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

						if frame.optionTable.displayOnlyDispellableDebuffs then
							filter = "RAID"
						end

						index = 1
						--Now, we display all normal debuffs.
						if frame.optionTable.displayNonBossDebuffs then
							while frameNum <= 10 do
								if frame.displayedUnit then
									local debuffName = ImproveAny:UnitAura(frame.displayedUnit, index, filter)
									if debuffName then
										if CompactUnitFrame_UtilShouldDisplayDebuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) and not CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) then
											local debuffFrame = _G[ImproveAny:GetName(frame) .. "Debuff" .. frameNum]
											if debuffFrame then
												ImproveAny:CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false)
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
							local debuffFrame = _G[ImproveAny:GetName(frame) .. "Debuff" .. i]
							if debuffFrame then
								debuffFrame:Hide()
							end
						end
					end
				end
			)
		end

		local old1 = ""
		local old2 = ""
		function ImproveAny:ShowMsgForBuffs()
			if old1 ~= ImproveAny:IAGV("RFHIDEBUFFIDSINCOMBAT", "") then
				old1 = ImproveAny:IAGV("RFHIDEBUFFIDSINCOMBAT", "")
				local text = string.gsub(old1, ",", "\n")
				ImproveAny:MSG("[HIDE-BUFFS] Hide Buffs In Combat changed to: \n" .. text)
			end

			if old2 ~= ImproveAny:IAGV("RFHIDEBUFFIDSINNOTCOMBAT", "") then
				old2 = ImproveAny:IAGV("RFHIDEBUFFIDSINNOTCOMBAT", "")
				local text = string.gsub(old1, ",", "\n")
				ImproveAny:MSG("[HIDE-BUFFS] Hide Buffs Outside of Combat changed to: " .. text)
			end
		end
	end
end
