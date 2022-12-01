
local AddOnName, ImproveAny = ...

local BAGS = {
	"CharacterBag3Slot",
	"CharacterBag2Slot",
	"CharacterBag1Slot",
	"CharacterBag0Slot"
}

function ImproveAny:BAGSTryAdd( fra, index )
	if _G[fra] == nil then
		return
	end
	if fra and not tContains( BAGS, fra ) then
		if index then
			tinsert( BAGS, index, tostring( fra ) )
		else
			tinsert( BAGS, tostring( fra ) )
		end
	end
end

function ImproveAny:BAGSTryRemove( fra )
	if _G[fra] == nil then
		return
	end
	if fra and tContains( BAGS, fra ) then
		local index = nil
		for i, v in pairs( BAGS ) do
			if v == fra then
				index = i
			end
		end
		if index then
			tremove( BAGS, index )
		end
	end
end

function ImproveAny:UpdateBagsTable()
	ImproveAny:BAGSTryAdd( "CharacterReagentBag0Slot", 1 )
	ImproveAny:BAGSTryAdd( "KeyRingButton", 1 )
	ImproveAny:BAGSTryAdd( "BagBarExpandToggle", #BAGS + 1 )
	ImproveAny:BAGSTryAdd( "BagToggle", #BAGS )
	ImproveAny:BAGSTryAdd( "MainMenuBarBackpackButton" )
end

local BAGThink = CreateFrame( "FRAME", "BAGThink" )
function BAGThink.UpdateItemInfos()
	--
end

function ImproveAny:InitBags()
	local BagThinker = CreateFrame( "FRAME", "BagThinker", UIParent)

	if CharacterBag0Slot then
		local br = 3
		
		for i, slot in pairs( BAGS ) do
			local SLOT = _G[slot]
			if slot ~= "KeyRingButton" and SLOT and SLOT.text == nil then
				SLOT.text = SLOT:CreateFontString( nil, "ARTWORK" )
				SLOT.text:SetFont( STANDARD_TEXT_FONT, 10, "THINOUTLINE" )
				SLOT.text:SetPoint( "TOP", SLOT, "TOP", 0, -3 )
				SLOT.text:SetText( "" )
			end
		end

		function BAGThink.UpdateItemInfos()
			ImproveAny:UpdateBagsTable()

			local sum = 0
			for i, slot in pairs(BAGS) do
				local SLOT = _G[slot]
				local COUNT = _G[slot .. "Count"]
				if SLOT and ImproveAny:IsEnabled( "BAGSAMESIZE", true ) then
					local size = ImproveAny:GV( "BAGSIZE", 30 )
					local scale = size / 30
					if SLOT == BagToggle then
						SLOT:SetSize( size * 0.5, size * 0.8 )
					elseif SLOT == BagBarExpandToggle then
						SLOT:SetSize( 10 * scale, 15 * scale )
					elseif SLOT == KeyRingButton then
						SLOT:SetSize( 14 * scale, 30 * scale )
					else
						SLOT:SetSize( size, size )
					end

					if MAUpdateBags then
						MAUpdateBags()
					end
				end
				if SLOT and SLOT.text ~= nil and GetContainerNumFreeSlots then
					local numberOfFreeSlots = GetContainerNumFreeSlots(i - 1)
					sum = sum + numberOfFreeSlots
					SLOT.text:SetText( numberOfFreeSlots )
					SLOT.maxDisplayCount = 999999

					if COUNT then
						COUNT:SetText("")
					end
				end
			end
		end
		BAGThink.UpdateItemInfos()

		BAGThink:RegisterEvent("BAG_UPDATE")
		BAGThink:SetScript("OnEvent", function(self, event, slotid, ...)
			BAGThink.UpdateItemInfos()
		end)

		C_Timer.After( 1, function()
			IABagBar = CreateFrame( "FRAME", "IABagBar", MABagBar )
		
			if ImproveAny:GV( "BAGMODE", "RETAIL" ) == "RETAIL" then
				if ImproveAny:GetWoWBuild() ~= "RETAIL" and MABagBar then
					local sw, sh = MABagBar:GetSize()
					sw = sw + 4 * br
					IABagBar:SetSize( sw - sh, sh )
					IABagBar:SetPoint( "RIGHT", MABagBar, "RIGHT", -sh - (sh / 2) - 2 * br, 0 )
						
					BagToggle = CreateFrame( "BUTTON", "BagToggle", MABagBar )
					BagToggle:SetSize( sh * 0.5, sh * 0.8 )
					BagToggle:SetPoint( "LEFT", MABagBar, "RIGHT", -sh * 1.5 - br, 0 )

					BagToggle.show = true

					BagToggle:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight" )
					function BagToggle:UpdateIcon()
						if BagToggle.show then
							BagToggle:SetNormalTexture( "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up" )
							BagToggle:SetPushedTexture( "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down" )
						else
							BagToggle:SetNormalTexture( "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up" )
							BagToggle:SetPushedTexture( "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down" )
						end
					end
					BagToggle:UpdateIcon()

					BagToggle:SetScript( "OnClick", function( self, btn )
						BagToggle.show = not BagToggle.show
						if BagToggle.show then
							IABagBar:Show()
						else
							IABagBar:Hide()
						end

						BagToggle:UpdateIcon()
					end )

					local oldslot = nil
					for i, slot in pairs( BAGS ) do
						if slot ~= "MainMenuBarBackpackButton" then
							local SLOT = _G[slot]
							if SLOT then
								SLOT:SetParent( IABagBar )
								SLOT:ClearAllPoints()
								if oldslot then
									SLOT:SetPoint( "LEFT", oldslot, "RIGHT", br, 0 )
								else
									SLOT:SetPoint( "LEFT", IABagBar, "LEFT", 0, 0 )
								end

								oldslot = SLOT
							end
						else
							local SLOT = _G[slot]
							if SLOT then
								SLOT:ClearAllPoints()
								SLOT:SetPoint( "RIGHT", MABagBar, "RIGHT", 0, 0 )
							end
						end
					end

					local isw, ish = IABagBar:GetSize()
					MABagBar:SetSize( isw + br + sh * 0.5 + br + sh, ish )
				end
			elseif ImproveAny:GV( "BAGMODE", "RETAIL" ) == "CLASSIC" then
				local SLOT = _G["BagBarExpandToggle"]
				if SLOT then
					hooksecurefunc( SLOT, "Show", function( self )
						if self.iashow then return end
						self.iashow = true
						self:Hide()
						self.iashow = false							
					end )
					SLOT:Hide()
					ImproveAny:BAGSTryRemove( "BagBarExpandToggle" )
				end
				
				local sw, sh, count = 0, 0, 0
				for i, slot in pairs( BAGS ) do
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
							SLOT:SetParent( IABagBar )
							SLOT:ClearAllPoints()
							if oldslot then
								SLOT:SetPoint( "LEFT", oldslot, "RIGHT", br, 0 )
							else
								SLOT:SetPoint( "LEFT", IABagBar, "LEFT", 0, 0 )
							end

							oldslot = SLOT
						end
					else
						local SLOT = _G[slot]
						if SLOT then
							SLOT:ClearAllPoints()
							SLOT:SetPoint( "RIGHT", MABagBar, "RIGHT", 0, 0 )
						end
					end
				end
				if sw > 0 and sh > 0 then
					sw = sw + ( count - 1 ) * br
					IABagBar:SetSize( sw, sh )
					IABagBar:SetPoint( "RIGHT", MABagBar, "RIGHT", 0, 0 )
					MABagBar:SetSize( sw, sh )
				end
			elseif ImproveAny:GV( "BAGMODE", "RETAIL" ) == "ONEBAG" then
				for i, slot in pairs( BAGS ) do
					local SLOT = _G[slot]
					if SLOT and slot ~= "MainMenuBarBackpackButton" then
						hooksecurefunc( SLOT, "Show", function( self )
							if self.iashow then return end
							self.iashow = true
							self:Hide()
							self.iashow = false							
						end )
						SLOT:Hide()
					end
				end

				local SLOT = _G["MainMenuBarBackpackButton"]
				if SLOT then
					local sw, sh = SLOT:GetSize()
					IABagBar:SetSize( sw, sh )
					IABagBar:SetPoint( "RIGHT", MABagBar, "RIGHT", 0, 0 )
					MABagBar:SetSize( sw, sh )

					SLOT:ClearAllPoints()
					SLOT:SetPoint( "RIGHT", MABagBar, "RIGHT", 0, 0 )
				end
			else
				ImproveAny:MSG( "BAGMODE NOT FOUND: " .. ImproveAny:GV( "BAGMODE", "RETAIL" ) )
			end
		end )
	end
end
