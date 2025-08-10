local _, ImproveAny = ...
local BAGS = {"MainMenuBarBackpackButton", "CharacterBag3Slot", "CharacterBag2Slot", "CharacterBag1Slot", "CharacterBag0Slot"}
local BAGSIDS = {}
BAGSIDS["MainMenuBarBackpackButton"] = 0
BAGSIDS["CharacterBag3Slot"] = 4
BAGSIDS["CharacterBag2Slot"] = 3
BAGSIDS["CharacterBag1Slot"] = 2
BAGSIDS["CharacterBag0Slot"] = 1
function ImproveAny:BAGSTryAdd(fra, index)
	if _G[fra] == nil then return end
	if fra and not tContains(BAGS, fra) then
		if index then
			tinsert(BAGS, index, tostring(fra))
		else
			tinsert(BAGS, tostring(fra))
		end
	end
end

function ImproveAny:BAGSTryRemove(fra)
	if _G[fra] == nil then return end
	if fra and tContains(BAGS, fra) then
		local index = nil
		for i, v in pairs(BAGS) do
			if v == fra then
				index = i
			end
		end

		if index then
			tremove(BAGS, index)
		end
	end
end

function ImproveAny:UpdateBagsTable()
	ImproveAny:BAGSTryAdd("CharacterReagentBag0Slot", 1)
	ImproveAny:BAGSTryAdd("KeyRingButton", 1)
	ImproveAny:BAGSTryAdd("BagBarExpandToggle", #BAGS + 1)
	ImproveAny:BAGSTryAdd("BagToggle", #BAGS + 1)
	ImproveAny:BAGSTryAdd("MainMenuBarBackpackButton")
end

local BAGThink = CreateFrame("FRAME", "BAGThink")
function BAGThink.UpdateItemInfos()
end

function ImproveAny:InitBags()
	if CharacterBag0Slot then
		local br = 5
		for i, slot in pairs(BAGS) do
			local SLOT = _G[slot]
			if slot ~= "KeyRingButton" and SLOT and SLOT.text == nil then
				SLOT.text = SLOT:CreateFontString(nil, "ARTWORK")
				SLOT.text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
				SLOT.text:SetPoint("TOP", SLOT, "TOP", 0, -3)
				SLOT.text:SetText("")
			end
		end

		function BAGThink.UpdateItemInfos()
			ImproveAny:UpdateBagsTable()
			local sum = 0
			for i, slot in pairs(BAGS) do
				local SLOT = _G[slot]
				local COUNT = _G[slot .. "Count"]
				local id = BAGSIDS[slot]
				if SLOT and ImproveAny:IsEnabled("BAGSAMESIZE", false) then
					local size = ImproveAny:IAGV("BAGSIZE", 30)
					local scale = size / 30
					if SLOT == BagToggle then
						SLOT:SetSize(size * 0.5, size * 0.8)
					elseif SLOT == BagBarExpandToggle then
						SLOT:SetSize(10 * scale, 15 * scale)
					elseif SLOT == KeyRingButton then
						SLOT:SetSize(14 * scale, 30 * scale)
					else
						SLOT:SetSize(size, size)
					end

					if MAUpdateBags then
						MAUpdateBags()
					end
				end

				if SLOT and SLOT.text ~= nil and C_Container and C_Container.GetContainerNumFreeSlots and id then
					local numberOfFreeSlots = C_Container.GetContainerNumFreeSlots(id)
					sum = sum + numberOfFreeSlots
					if ImproveAny:IsEnabled("FREESPACEBAGS", false) then
						SLOT.text:SetText("(" .. numberOfFreeSlots .. ")")
					end

					SLOT.maxDisplayCount = 999999
					if COUNT and ImproveAny:IsEnabled("FREESPACEBAGS", false) then
						COUNT:SetText("")
					end
				end
			end
		end

		BAGThink.UpdateItemInfos()
		ImproveAny:RegisterEvent(BAGThink, "BAG_UPDATE")
		ImproveAny:OnEvent(
			BAGThink,
			function(sel, event, slotid, ...)
				BAGThink.UpdateItemInfos()
			end, "BAGThink"
		)

		ImproveAny:Debug("bags #1")
		ImproveAny:After(
			1,
			function()
				if not BagsBar then
					BagsBar = CreateFrame("Frame", "BagsBar", UIParent)
					BagsBar:SetSize(100, 100)
					if MicroButtonAndBagsBar then
						BagsBar:SetPoint("CENTER", MicroButtonAndBagsBar, "CENTER", 0, 0)
					elseif MainMenuBarArtFrame then
						BagsBar:SetPoint("BOTTOMRIGHT", MainMenuBarArtFrame, "BOTTOMRIGHT", -6, 1)
					end
				end

				IABagBar = CreateFrame("FRAME", "IABagBar", BagsBar or UIParent)
				if ImproveAny:IsAddOnLoaded("Dominos") and ImproveAny:GetBagMode() ~= "DISABLED" then
					ImproveAny:MSG(format("Dominos is enabled, BAGMODE: %s may can break Domonis moving the bag bar.", ImproveAny:GetBagMode()))
				end

				if ImproveAny:GetBagMode() == "RETAIL" then
					if ImproveAny:GetWoWBuild() ~= "RETAIL" and BagsBar then
						BagToggle = CreateFrame("BUTTON", "BagToggle", BagsBar or UIParent)
						local mainBag = _G["MainMenuBarBackpackButton"]
						if mainBag then
							local _, h = mainBag:GetSize()
							BagToggle:SetSize(h * 0.5, h * 0.8)
						end

						ImproveAny:BAGSTryAdd("BagToggle", #BAGS + 1)
						BagToggle.show = true
						BagToggle:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
						function BagToggle:UpdateIcon()
							if BagToggle.show then
								BagToggle:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
								BagToggle:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
							else
								BagToggle:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
								BagToggle:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
							end
						end

						BagToggle:UpdateIcon()
						BagToggle:SetScript(
							"OnClick",
							function(sel, btn)
								BagToggle.show = not BagToggle.show
								if BagToggle.show then
									IABagBar:Show()
								else
									IABagBar:Hide()
								end

								BagToggle:UpdateIcon()
							end
						)

						local sw = 0
						local sh = 0
						local count = 0
						local oldslot = nil
						for i, slot in pairs(BAGS) do
							local SLOT = _G[slot]
							if SLOT then
								count = count + 1
								sw = sw + _G[slot]:GetWidth()
								if sh < _G[slot]:GetHeight() then
									sh = _G[slot]:GetHeight()
								end

								if slot ~= "MainMenuBarBackpackButton" then
									if slot ~= "BagToggle" then
										hooksecurefunc(
											SLOT,
											"SetParent",
											function(sel, parent)
												if sel.ia_setparent then return end
												sel.ia_setparent = true
												sel:SetParent(IABagBar)
												sel.ia_setparent = false
											end
										)

										SLOT:SetParent(IABagBar)
									end

									SLOT:ClearAllPoints()
									if oldslot then
										SLOT:SetPoint("LEFT", oldslot, "RIGHT", br, 0)
									else
										SLOT:SetPoint("LEFT", IABagBar, "LEFT", 0, 0)
									end

									oldslot = SLOT
								else
									SLOT:ClearAllPoints()
									SLOT:SetPoint("RIGHT", BagsBar or UIParent, "RIGHT", 0, 0)
								end
							end
						end

						sw = sw + (count - 1) * br
						BagToggle:SetPoint("LEFT", BagsBar or UIParent, "RIGHT", -sh * 1.5 - br, 0)
						BagToggle:SetSize(sh * 0.5, sh * 0.8)
						IABagBar:SetSize(sw, sh)
						IABagBar:SetPoint("RIGHT", BagsBar or UIParent, "RIGHT", 0, 0)
						if BagsBar then
							BagsBar:SetSize(sw, sh)
						end
					end
				elseif ImproveAny:GetBagMode() == "CLASSIC" then
					local BBET = _G["BagBarExpandToggle"]
					if BBET then
						BBET:SetParent(IAHIDDEN)
						ImproveAny:BAGSTryRemove("BagBarExpandToggle")
					end

					local sw, sh, count = 0, 0, 0
					for i, slot in pairs(BAGS) do
						if _G[slot] then
							count = count + 1
							sw = sw + _G[slot]:GetWidth()
							if sh < _G[slot]:GetHeight() then
								sh = _G[slot]:GetHeight()
							end
						end

						if slot ~= "MainMenuBarBackpackButton" then
							local SLOT = _G[slot]
							if SLOT then
								SLOT:SetParent(IABagBar)
								SLOT:ClearAllPoints()
								if oldslot then
									SLOT:SetPoint("LEFT", oldslot, "RIGHT", br, 0)
								else
									SLOT:SetPoint("LEFT", IABagBar, "LEFT", 0, 0)
								end

								oldslot = SLOT
							end
						else
							local SLOT = _G[slot]
							if SLOT then
								SLOT:ClearAllPoints()
								SLOT:SetPoint("RIGHT", IABagBar, "RIGHT", 0, 0)
							end
						end
					end

					if sw > 0 and sh > 0 then
						sw = sw + (count - 1) * br
						IABagBar:SetSize(sw, sh)
						if BagsBar then
							IABagBar:SetPoint("RIGHT", BagsBar or UIParent, "RIGHT", 0, 0)
							BagsBar:SetSize(sw, sh)
						else
							IABagBar:SetPoint("TOPRIGHT", MicroButtonAndBagsBar, "TOPRIGHT", 0, 0)
						end
					end
				elseif ImproveAny:GetBagMode() == "ONEBAG" then
					for i, slot in pairs(BAGS) do
						local SLOT = _G[slot]
						if SLOT and slot ~= "MainMenuBarBackpackButton" then
							hooksecurefunc(
								SLOT,
								"SetParent",
								function(sel)
									if sel.ia_setparent then return end
									sel.ia_setparent = true
									if ImproveAny:GetParent(sel) ~= IAHIDDEN then
										sel:SetParent(IAHIDDEN)
									end

									sel.ia_setparent = false
								end
							)

							SLOT:SetParent(IAHIDDEN)
						end
					end

					local SLOT = _G["MainMenuBarBackpackButton"]
					if SLOT then
						local sw, sh = SLOT:GetSize()
						IABagBar:SetSize(sw, sh)
						if BagsBar then
							IABagBar:SetPoint("RIGHT", BagsBar or UIParent, "RIGHT", 0, 0)
							BagsBar:SetSize(sw, sh)
						else
							IABagBar:SetPoint("TOPRIGHT", MicroButtonAndBagsBar, "TOPRIGHT", 0, 0)
						end

						SLOT:ClearAllPoints()
						SLOT:SetPoint("RIGHT", IABagBar, "RIGHT", 0, 0)
					end
				elseif ImproveAny:GetBagMode() ~= "DISABLED" then
					ImproveAny:MSG("BAGMODE NOT FOUND: " .. ImproveAny:GetBagMode())
				end
			end, "bags #1"
		)
	end

	ImproveAny:Debug("bags #2")
	ImproveAny:After(
		1,
		function()
			for i, v in pairs(BAGS) do
				local bagF = _G[v]
				local NT = _G[v .. "NormalTexture"]
				if NT and bagF and NT.scalesetup == nil then
					NT.scalesetup = true
					if NT:GetTexture() == 130841 then
						local sw, sh = bagF:GetSize()
						local scale = 1.66
						NT:SetSize(sw * scale, sh * scale)
					end
				end
			end
		end, "bags #2"
	)
end
