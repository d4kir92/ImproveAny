local _, ImproveAny = ...
ImproveAny:Debug("repbar.lua: Init")
ImproveAny:After(
	0.01,
	function()
		if ImproveAny:IsEnabled("REPBAR", false) then
			if ReputationWatchBar and ReputationWatchBar.StatusBar then
				ReputationWatchBar.show = true
				ReputationWatchBar:HookScript(
					"OnEnter",
					function(sel)
						ReputationWatchBar.show = false
						ReputationWatchBar.OverlayFrame.Text:Hide()
					end
				)

				ReputationWatchBar:HookScript(
					"OnLeave",
					function(sel)
						ReputationWatchBar.show = true
						ReputationWatchBar.OverlayFrame.Text:Show()
					end
				)

				if ImproveAny:IsEnabled("REPHIDEARTWORK", false) then
					if not ImproveAny:IsAddOnLoaded("MoveAny") then
						hooksecurefunc(
							ReputationWatchBar,
							"SetHeight",
							function(sel, h)
								if sel.iasetheight then return end
								sel.iasetheight = true
								sel:SetHeight(15)
								sel.iasetheight = false
							end
						)

						ReputationWatchBar:SetHeight(15)
						hooksecurefunc(
							ReputationWatchBar.StatusBar,
							"SetHeight",
							function(sel, h)
								if sel.iasetheight then return end
								sel.iasetheight = true
								sel:SetHeight(15)
								sel.iasetheight = false
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
								function(sel)
									if sel.iahide then return end
									sel.iahide = true
									sel:Hide()
									sel.iahide = false
								end
							)

							art:Hide()
						end

						if art2 then
							hooksecurefunc(
								art2,
								"Show",
								function(sel)
									if sel.iahide then return end
									sel.iahide = true
									sel:Hide()
									sel.iahide = false
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
					function(sel, orgText)
						if sel.iasettext then return end
						sel.iasettext = true
						local ff, _, fflags = sel:GetFont()
						sel:SetFont(ff, ImproveAny:Clamp(ReputationWatchBar:GetHeight() * 0.7, 8, 30), fflags)
						local name, reaction, minBar, maxBar, value, factionID = GetWatchedFactionInfo()
						local isCapped
						if GetFriendshipReputation then
							local friendshipID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
							if sel.factionID ~= factionID then
								sel.factionID = factionID
								sel.friendshipID = friendshipID
							end

							-- do something different for friendships
							if friendshipID then
								if nextFriendThreshold then
									minBar, maxBar, value = friendThreshold, nextFriendThreshold, friendRep
								else
									-- max rank, make it look like a full bar
									minBar, maxBar, value = 0, 1, 1
									isCapped = true
								end
							elseif C_Reputation.IsFactionParagon(factionID) then
								local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
								minBar, maxBar = 0, threshold
								value = currentValue % threshold
								if hasRewardPending then
									value = value + threshold
								end
							else
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
							sel.rep = value
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

								text = string.gsub(text, "%s+$", "")
								if ImproveAny:IsEnabled("REPNUMBER", false) or ImproveAny:IsEnabled("REPPERCENT", false) then
									sel:SetText(name .. ": " .. text)
								else
									sel:SetText(orgText)
								end

								if ReputationWatchBar.show then
									sel:Show()
								end
							end
						end

						sel.iasettext = false
					end
				)

				ReputationWatchBar.OverlayFrame.Text:SetText(ReputationWatchBar.OverlayFrame.Text:GetText() or "")
			end
		end
	end, "RepBar"
)
