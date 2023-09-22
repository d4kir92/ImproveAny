local _, ImproveAny = ...
local IACHARSLOTS = {CharacterHeadSlot, CharacterNeckSlot, CharacterShoulderSlot, CharacterBackSlot, CharacterChestSlot, CharacterWristSlot, CharacterHandsSlot, CharacterWaistSlot, CharacterLegsSlot, CharacterFeetSlot, CharacterFinger0Slot, CharacterFinger1Slot, CharacterTrinket0Slot, CharacterTrinket1Slot, CharacterMainHandSlot, CharacterSecondaryHandSlot, CharacterRangedSlot}
-- Classic
function ImproveAny:InitDurabilityFrame()
	C_Timer.After(
		1,
		function()
			ImproveAny:Debug("durabilityframe.lua: Init")
			DurabilityFrame.textperc = DurabilityFrame:CreateFontString(nil)
			DurabilityFrame.textperc:SetFont(STANDARD_TEXT_FONT, 10, "")
			DurabilityFrame.textperc:SetPoint("TOP", DurabilityFrame, "TOP", 0, 10)
			DurabilityFrame.textperc:SetText("101%")
			DurabilityFrame.textrepaircosts = DurabilityFrame:CreateFontString(nil)
			DurabilityFrame.textrepaircosts:SetFont(STANDARD_TEXT_FONT, 10, "")
			DurabilityFrame.textrepaircosts:SetPoint("TOP", DurabilityFrame, "TOP", 0, 22)
			DurabilityFrame.textrepaircosts:SetText("")
			DurabilityFrame.textrepaircosts:SetTextColor(1.0, 1.0, 0.1)
			function DurabilityFrame.Think()
				local ccur = 0
				local cmax = 0
				for i = 0, 20 do
					local curr, maxi = GetInventoryItemDurability(i)
					if curr ~= nil and maxi ~= nil then
						ccur = ccur + curr
						cmax = cmax + maxi
					end
				end

				local perc = 0
				if cmax > 0 then
					perc = ImproveAny:MathR(ccur / cmax * 100, 1)
					if DurabilityFrame.textperc ~= nil then
						DurabilityFrame.textperc:SetText(perc .. "%")
						if perc > 50 then
							DurabilityFrame.textperc:SetTextColor(0.1, 1.0, 0.1)
						elseif perc > 30 then
							DurabilityFrame.textperc:SetTextColor(1.0, 1.0, 0.1)
						else
							DurabilityFrame.textperc:SetTextColor(1.0, 0.1, 0.1)
						end
					end
				end

				if perc <= ImproveAny:GV("SHOWDURABILITYUNDER", 100) then
					DurabilityFrame:Show()
				else
					DurabilityFrame:Hide()
				end

				if DurabilityFrame.textrepaircosts then
					local costs = 0
					for i, v in pairs(IACHARSLOTS) do
						local id = v:GetID()
						if v.tt == nil then
							v.tt = CreateFrame("GameTooltip", "DURA" .. i, DurabilityFrame)
							v.tt:ClearLines()
						end

						if v.tt and v.tt.SetInventoryItem then
							local cost = select(3, v.tt:SetInventoryItem("player", id))
							costs = costs + cost
						end
					end

					if costs > 0 then
						DurabilityFrame.textrepaircosts:SetText(GetCoinTextureString(costs))
					else
						DurabilityFrame.textrepaircosts:SetText("")
					end
				elseif DurabilityFrame.textrepaircosts then
					DurabilityFrame.textrepaircosts:SetText("")
				end

				ImproveAny:Debug("durabilityframe.lua: Think", "think")
				C_Timer.After(1, DurabilityFrame.Think)
			end

			DurabilityFrame.Think()
			if DurabilityFrame.SetAlerts ~= nil then
				hooksecurefunc(
					DurabilityFrame,
					"SetAlerts",
					function()
						DurabilityFrame:Show()
						for index, value in ipairs(INVENTORY_ALERT_STATUS_SLOTS) do
							if (not value.showSeparate) or value.slot == "Weapon" then
								getglobal("Durability" .. value.slot):Show()
							end
						end
					end
				)

				DurabilityFrame:SetAlerts()
			elseif DurabilityFrame_SetAlerts ~= nil then
				local oldalerts = DurabilityFrame_SetAlerts
				function DurabilityFrame_SetAlerts()
					if oldalerts ~= nil then
						oldalerts()
					end

					DurabilityFrame:Show()
					for index, value in ipairs(INVENTORY_ALERT_STATUS_SLOTS) do
						if (not value.showSeparate) or value.slot == "Weapon" then
							getglobal("Durability" .. value.slot):Show()
						end
					end
				end

				DurabilityFrame_SetAlerts()
			end
		end
	)
end