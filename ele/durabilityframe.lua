local _, ImproveAny = ...
local IACHARSLOTS = {CharacterHeadSlot, CharacterNeckSlot, CharacterShoulderSlot, CharacterBackSlot, CharacterChestSlot, CharacterWristSlot, CharacterHandsSlot, CharacterWaistSlot, CharacterLegsSlot, CharacterFeetSlot, CharacterFinger0Slot, CharacterFinger1Slot, CharacterTrinket0Slot, CharacterTrinket1Slot, CharacterMainHandSlot, CharacterSecondaryHandSlot, CharacterRangedSlot}
-- Classic
local textperc = nil
local textrepaircosts = nil
function ImproveAny:InitDurabilityFrame()
	ImproveAny:After(
		1,
		function()
			ImproveAny:Debug("durabilityframe.lua: Init")
			textperc = DurabilityFrame:CreateFontString(nil)
			textperc:SetFont(STANDARD_TEXT_FONT, 10, "")
			textperc:SetPoint("TOP", DurabilityFrame, "TOP", 0, 10)
			textperc:SetText("101%")
			textrepaircosts = DurabilityFrame:CreateFontString(nil)
			textrepaircosts:SetFont(STANDARD_TEXT_FONT, 10, "")
			textrepaircosts:SetPoint("TOP", DurabilityFrame, "TOP", 0, 22)
			textrepaircosts:SetText("")
			textrepaircosts:SetTextColor(1.0, 1.0, 0.1)
			local function Think()
				local ok = xpcall(
					function()
						if true then return end
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
							if textperc ~= nil then
								textperc:SetText(perc .. "%")
								if perc > 50 then
									textperc:SetTextColor(0.1, 1.0, 0.1)
								elseif perc > 30 then
									textperc:SetTextColor(1.0, 1.0, 0.1)
								else
									textperc:SetTextColor(1.0, 0.1, 0.1)
								end
							end
						end

						if not InCombatLockdown() then
							if perc <= ImproveAny:IAGV("SHOWDURABILITYUNDER", 100) then
								DurabilityFrame:Show()
							else
								DurabilityFrame:Hide()
							end
						end

						if textrepaircosts then
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
								textrepaircosts:SetText(GetCoinTextureString(costs))
							else
								textrepaircosts:SetText("")
							end
						elseif textrepaircosts then
							textrepaircosts:SetText("")
						end
					end,
					function(err)
						print(err)
					end
				)

				ImproveAny:Debug("durabilityframe.lua: Think", "think")
				ImproveAny:After(1, Think, "Think")
			end

			Think()
		end, "InitDurabilityFrame"
	)
end
