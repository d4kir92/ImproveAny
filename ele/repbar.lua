
local AddOnName, ImproveAny = ...

local textc = "|cFF00FF00" -- Colored
local textw = "|r" -- "WHITE"

C_Timer.After( 0.01, function()

	if ReputationWatchBar and ReputationWatchBar.StatusBar then
		ReputationWatchBar.show = true
		ReputationWatchBar:HookScript( "OnEnter", function( self )
			ReputationWatchBar.show = false
			ReputationWatchBar.OverlayFrame.Text:Hide()
		end )
		ReputationWatchBar:HookScript( "OnLeave", function( self )
			ReputationWatchBar.show = true
			ReputationWatchBar.OverlayFrame.Text:Show()
		end )
		
		if ImproveAny:IsEnabled( "REPHIDEARTWORK", false ) then
			ReputationWatchBar:SetHeight( 15 )
			ReputationWatchBar.StatusBar:SetHeight( 15 )
			
			for i = 0, 3 do
				local art = ReputationWatchBar.StatusBar["WatchBarTexture" .. i]
				local art2 = ReputationWatchBar.StatusBar["XPBarTexture" .. i]
				if art then
					art.Show = art.Hide
					art:Hide()
				end
				if art2 then
					art2.Show = art.Hide
					art2:Hide()
				end
			end
		end
	end

	if ReputationWatchBar and ReputationWatchBar.OverlayFrame and ReputationWatchBar.OverlayFrame.Text then	
		local fontName, fontSize, fontFlags = ReputationWatchBar.OverlayFrame.Text:GetFont()	
		ReputationWatchBar.OverlayFrame.Text:SetFont( fontName, 12, fontFlags )
		ReputationWatchBar.OverlayFrame.Text:SetPoint( "CENTER", ReputationWatchBar.OverlayFrame, "CENTER", 0, 1 )
		hooksecurefunc( ReputationWatchBar.OverlayFrame.Text, "SetText", function( self, text )
			if self.iasettext then return end
			self.iasettext = true

			local name, reaction, minBar, maxBar, value, factionID = GetWatchedFactionInfo()

			local colorIndex = reaction
			local isCapped
			if GetFriendshipReputation then
				local friendshipID = GetFriendshipReputation(factionID)
				
				if ( self.factionID ~= factionID ) then
					self.factionID = factionID
					self.friendshipID = GetFriendshipReputation(factionID)
				end
				
				-- do something different for friendships
				local level
				
				if ( friendshipID ) then
					local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
					level = GetFriendshipReputationRanks(factionID)
					if ( nextFriendThreshold ) then
						minBar, maxBar, value = friendThreshold, nextFriendThreshold, friendRep
					else
						-- max rank, make it look like a full bar
						minBar, maxBar, value = 0, 1, 1
						isCapped = true
					end
					colorIndex = 5		-- always color friendships green
				elseif ( C_Reputation.IsFactionParagon(factionID) ) then
					local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
					minBar, maxBar  = 0, threshold
					value = currentValue % threshold
					if ( hasRewardPending ) then 
						value = value + threshold
					end
				else
					level = reaction
					if ( reaction == MAX_REPUTATION_REACTION ) then
						isCapped = true
					end
				end
			end
			
			-- Normalize values
			maxBar = maxBar - minBar
			value = value - minBar
			if ( isCapped and maxBar == 0 ) then
				maxBar = 1
				value = 1
			end
			minBar = 0

			--			  "|cAARRGGBB"
			local textc = "|cFF00FF00" -- Colored
			local textw = "|r" -- WHITE
			local text = ""

			if name ~= nil then
				self.rep = value
						
				local per = (value - minBar) / (maxBar-minBar)
				local percent = per * 100
				if maxBar-minBar > 0 then
					if ImproveAny:IsEnabled( "REPNUMBER", true ) then
						if text ~= "" then
							text = text .. " "
						end
						text = text .. textc .. (value - minBar) .. textw .. "/" .. textc .. (maxBar-minBar)
					end
					if ImproveAny:IsEnabled( "REPPERCENT", true ) then
						if text ~= "" then
							text = text .. textw .. " (" .. textc .. format("%.2f", percent) .. "%" .. textw .. ")"
						else
							text = text .. textc .. format("%.2f", percent) .. "%"
						end
					end
					self:SetText(name .. ": " .. text)
					if ReputationWatchBar.show then
						self:Show()
					end
				end
			end

			self.iasettext = false
		end )
		ReputationWatchBar.OverlayFrame.Text:SetText( ReputationWatchBar.OverlayFrame.Text:GetText() or "" )
	end
end )