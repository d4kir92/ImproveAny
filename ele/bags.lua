local _, ImproveAny = ...

local BAGS = {"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot"}

local BAGSIDS = {}
BAGSIDS["MainMenuBarBackpackButton"] = 0
BAGSIDS["CharacterBag0Slot"] = 1
BAGSIDS["CharacterBag1Slot"] = 2
BAGSIDS["CharacterBag2Slot"] = 3
BAGSIDS["CharacterBag3Slot"] = 4

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
	ImproveAny:BAGSTryAdd("BagToggle", #BAGS)
	ImproveAny:BAGSTryAdd("MainMenuBarBackpackButton")
end

local BAGThink = CreateFrame("FRAME", "BAGThink")

function BAGThink.UpdateItemInfos()
end

function ImproveAny:InitBags()
	if CharacterBag0Slot then
		local br = 3

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
					local size = ImproveAny:GV("BAGSIZE", 30)
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

				if SLOT and SLOT.text ~= nil and GetContainerNumFreeSlots and id then
					local numberOfFreeSlots = GetContainerNumFreeSlots(id)
					sum = sum + numberOfFreeSlots
					SLOT.text:SetText(numberOfFreeSlots)
					SLOT.maxDisplayCount = 999999

					if COUNT then
						COUNT:SetText("")
					end
				end
			end
		end

		BAGThink.UpdateItemInfos()
		BAGThink:RegisterEvent("BAG_UPDATE")

		BAGThink:SetScript("OnEvent", function(sel, event, slotid, ...)
			BAGThink.UpdateItemInfos()
		end)

		C_Timer.After(1, function()
			IABagBar = CreateFrame("FRAME", "IABagBar", BagsBar or UIParent)

			if ImproveAny:GV("BAGMODE", "RETAIL") == "RETAIL" then
				if ImproveAny:GetWoWBuild() ~= "RETAIL" and BagsBar then
					BagToggle = CreateFrame("BUTTON", "BagToggle", BagsBar or UIParent)
					local mainBag = _G["MainMenuBarBackpackButton"]

					if mainBag then
						local _, h = mainBag:GetSize()
						BagToggle:SetSize(h * 0.5, h * 0.8)
					end

					ImproveAny:BAGSTryAdd("BagToggle", #BAGS)
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

					BagToggle:SetScript("OnClick", function(sel, btn)
						BagToggle.show = not BagToggle.show

						if BagToggle.show then
							IABagBar:Show()
						else
							IABagBar:Hide()
						end

						BagToggle:UpdateIcon()
					end)

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
									hooksecurefunc(SLOT, "SetParent", function(sel, parent)
										if sel.ia_setparent then return end
										sel.ia_setparent = true
										sel:SetParent(IABagBar)
										sel.ia_setparent = false
									end)

									SLOT:SetParent(IABagBar)
								end

								SLOT:ClearAllPoints()

								if oldslot then
									SLOT:SetPoint("LEFT", IABagBar, "LEFT", sw + (i - 1) * br - SLOT:GetWidth(), 0)
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
			elseif ImproveAny:GV("BAGMODE", "RETAIL") == "CLASSIC" then
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
								SLOT:SetPoint("LEFT", IABagBar, "LEFT", sw + (i - 1) * br - SLOT:GetWidth(), 0)
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
			elseif ImproveAny:GV("BAGMODE", "RETAIL") == "ONEBAG" then
				for i, slot in pairs(BAGS) do
					local SLOT = _G[slot]

					if SLOT and slot ~= "MainMenuBarBackpackButton" then
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
			else
				ImproveAny:MSG("BAGMODE NOT FOUND: " .. ImproveAny:GV("BAGMODE", "RETAIL"))
			end
		end)
	end

	C_Timer.After(1, function()
		for i, v in pairs(BAGS) do
			local bagF = _G[v]
			local NT = _G[v .. "NormalTexture"]

			if NT and bagF and NT.scalesetup == nil then
				NT.scalesetup = true
				local sw, sh = bagF:GetSize()
				local scale = 1.67
				NT:SetSize(sw * scale, sh * scale)
			end
		end
	end)
end