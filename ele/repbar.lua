local _, ImproveAny = ...
ImproveAny:Debug("repbar.lua: Init")
C_Timer.After(
	0.01,
	function()
		if ImproveAny:IsEnabled("REPBAR", false) then
			if ReputationWatchBar and ReputationWatchBar.StatusBar then
				ReputationWatchBar.show = true
				ReputationWatchBar:HookScript(
					"OnEnter",
					function(self)
						ReputationWatchBar.show = false
						ReputationWatchBar.OverlayFrame.Text:Hide()
					end
				)

				ReputationWatchBar:HookScript(
					"OnLeave",
					function(self)
						ReputationWatchBar.show = true
						ReputationWatchBar.OverlayFrame.Text:Show()
					end
				)

				if ImproveAny:IsEnabled("REPHIDEARTWORK", false) then
					if not D4:IsAddOnLoaded("MoveAny") then
						hooksecurefunc(
							ReputationWatchBar,
							"SetHeight",
							function(self, h)
								if self.iasetheight then return end
								self.iasetheight = true
								self:SetHeight(15)
								self.iasetheight = false
							end
						)

						ReputationWatchBar:SetHeight(15)
						hooksecurefunc(
							ReputationWatchBar.StatusBar,
							"SetHeight",
							function(self, h)
								if self.iasetheight then return end
								self.iasetheight = true
								self:SetHeight(15)
								self.iasetheight = false
							end
						)

						ReputationWatchBar.StatusBar:SetHeight(15)
					end

					for i = 0, 3 do
						local art = ReputationWatchBar.StatusBar["WatchBarTexture" .. i]
						local art2 = ReputationWatchBar.StatusBar["XPBarTexture" .. i]
						if art then
							hooksecurefunc(
								art,
								"Show",
								function(self)
									if self.iahide then return end
									self.iahide = true
									self:Hide()
									self.iahide = false
								end
							)

							art:Hide()
						end

						if art2 then
							hooksecurefunc(
								art2,
								"Show",
								function(self)
									if self.iahide then return end
									self.iahide = true
									self:Hide()
									self.iahide = false
								end
							)

							art2:Hide()
						end
					end
				end
			end

			if ReputationWatchBar and ReputationWatchBar.OverlayFrame and ReputationWatchBar.OverlayFrame.Text then
				local fontName, _, fontFlags = MainMenuBarExpText:GetFont()
				ReputationWatchBar.OverlayFrame.Text:SetFont(fontName, ImproveAny:Clamp(ReputationWatchBar:GetHeight() * 0.7, 8, 30), fontFlags)
				ReputationWatchBar.OverlayFrame.Text:SetPoint("CENTER", ReputationWatchBar.OverlayFrame, "CENTER", 0, 1)
				hooksecurefunc(
					ReputationWatchBar.OverlayFrame.Text,
					"SetText",
					function(self, orgText)
						if self.iasettext then return end
						self.iasettext = true
						local ff, _, fflags = self:GetFont()
						self:SetFont(ff, ImproveAny:Clamp(ReputationWatchBar:GetHeight() * 0.7, 8, 30), fflags)
						local name, reaction, minBar, maxBar, value, factionID = GetWatchedFactionInfo()
						local isCapped
						if GetFriendshipReputation then
							local friendshipID = GetFriendshipReputation(factionID)
							if self.factionID ~= factionID then
								self.factionID = factionID
								self.friendshipID = GetFriendshipReputation(factionID)
							end

							-- do something different for friendships
							if friendshipID then
								local _, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
								level = GetFriendshipReputationRanks(factionID)
								if nextFriendThreshold then
									minBar, maxBar, value = friendThreshold, nextFriendThreshold, friendRep
								else
									-- max rank, make it look like a full bar
									minBar, maxBar, value = 0, 1, 1
									isCapped = true
								end

								colorIndex = 5 -- always color friendships green
							elseif C_Reputation.IsFactionParagon(factionID) then
								local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
								minBar, maxBar = 0, threshold
								value = currentValue % threshold
								if hasRewardPending then
									value = value + threshold
								end
							else
								level = reaction
								if reaction == MAX_REPUTATION_REACTION then
									isCapped = true
								end
							end
						end

						-- Normalize values
						maxBar = maxBar - minBar
						value = value - minBar
						if isCapped and maxBar == 0 then
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
							local per = (value - minBar) / (maxBar - minBar)
							local percent = per * 100
							if maxBar - minBar > 0 then
								if ImproveAny:IsEnabled("REPNUMBER", false) then
									if text ~= "" then
										text = text .. " "
									end

									text = text .. textc .. (value - minBar) .. textw .. "/" .. textc .. (maxBar - minBar)
								end

								if ImproveAny:IsEnabled("REPPERCENT", false) then
									if text ~= "" then
										text = text .. textw .. " (" .. textc .. format("%.2f", percent) .. "%" .. textw .. ")"
									else
										text = text .. textc .. format("%.2f", percent) .. "%"
									end
								end

								if ImproveAny:IsEnabled("REPNUMBER", false) or ImproveAny:IsEnabled("REPPERCENT", false) then
									self:SetText(name .. ": " .. text)
								else
									self:SetText(orgText)
								end

								if ReputationWatchBar.show then
									self:Show()
								end
							end
						end

						self.iasettext = false
					end
				)

				ReputationWatchBar.OverlayFrame.Text:SetText(ReputationWatchBar.OverlayFrame.Text:GetText() or "")
			end
		end
	end
)
