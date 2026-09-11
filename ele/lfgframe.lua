local _, ImproveAny = ...

function ImproveAny:GetFlagString(realmName, text)
	if not ImproveAny:IsEnabled("LFGSHOWLANGUAGEFLAG", false) then return text end
	local realmLang = ImproveAny:GetRealmFlag(realmName)
	if realmLang and realmLang ~= "" then
		return "|T" .. "Interface\\Addons\\ImproveAny\\media\\flags\\" .. realmLang .. ":0:2:0:0|t" .. " " .. text
	else
		return text
	end
end

function ImproveAny:InitLFGFrame()
	if LFGListApplicationViewer_UpdateApplicantMember then
		hooksecurefunc(
			"LFGListApplicationViewer_UpdateApplicantMember",
			function(member, id, index, status, pendingStatus)
				local name, class = C_LFGList.GetApplicantMemberInfo(id, index)
				local activeEntryInfo = C_LFGList.GetActiveEntryInfo()
				if not activeEntryInfo then return end
				if name == nil then return end
				local dName = member.Name:GetText()
				local text = ""
				if activeEntryInfo.activityIDs == nil or activeEntryInfo.activityIDs[1] == nil then
					if activeEntryInfo.activityIDs == nil then
						ImproveAny:MSG("[LFG] activityIDs is nil")
					elseif activeEntryInfo.activityIDs[1] == nil then
						ImproveAny:MSG("[LFG] activityIDs[1] is nil")
					end

					return
				end

				local bestDungeonScoreForListing = C_LFGList.GetApplicantDungeonScoreForListing(id, index, activeEntryInfo.activityIDs[1])
				local dungeonRating = bestDungeonScoreForListing.mapScore
				local dungeonKey = bestDungeonScoreForListing.bestRunLevel
				local showDungeonScore = ImproveAny:IsEnabled("LFGSHOWDUNGEONSCORE", false)
				local showDungeonKey = ImproveAny:IsEnabled("LFGSHOWDUNGEONKEY", false)
				if member.Rating and (showDungeonScore or showDungeonKey) then
					local font, _, flags = member.Rating:GetFont()
					if font then
						member.Rating:SetFont(font, 8, flags)
					end

					if member.Rating:IsShown() then
						local info = {}
						if showDungeonKey and dungeonKey and dungeonKey > 0 then
							info[#info + 1] = dungeonKey
						end

						if showDungeonScore and dungeonRating and dungeonRating > 0 then
							local color = C_ChallengeMode.GetDungeonScoreRarityColor(dungeonRating)
							if color then
								info[#info + 1] = "|c" .. color:GenerateHexColor() .. dungeonRating .. "|r"
							else
								info[#info + 1] = dungeonRating
							end
						end

						if #info > 0 then
							member.Rating:SetText((member.Rating:GetText() or "") .. " (" .. table.concat(info, ":") .. ")")
						end
					end
				end

				if member.RoleIcon1 and ImproveAny.GetClassAtlas then
					if member.IAClassIcon == nil then
						member.IAClassIcon = member:CreateTexture(nil, "OVERLAY")
						member.IAClassIcon:SetSize(16, 16)
						member.IAClassIcon:SetPoint("RIGHT", member.RoleIcon1, "LEFT", -2, 0)
						for i = 1, member.Name:GetNumPoints() do
							local point, rel, relPoint, x, y = member.Name:GetPoint(i)
							if point == "RIGHT" then
								member.IANameRight = {rel or member, relPoint, x, y}
								break
							end
						end
					end

					if ImproveAny:IsEnabled("LFGSHOWCLASSICON", false) and class then
						member.IAClassIcon:SetAtlas(ImproveAny:GetClassAtlas(class))
						member.IAClassIcon:Show()
						member.Name:SetPoint("RIGHT", member.RoleIcon1, "LEFT", -20, 0)
					else
						member.IAClassIcon:Hide()
						if member.IANameRight then
							member.Name:SetPoint("RIGHT", member.IANameRight[1], member.IANameRight[2], member.IANameRight[3], member.IANameRight[4])
						end
					end
				end

				text = text .. dName
				local server = ""
				local s, _ = string.find(name, "-")
				if s then
					server = strsub(name, s + 1)
				else
					server = GetRealmName()
				end

				local lang = ImproveAny:GetFlagString(server, text)
				if lang then
					if member.Name.SetWordWrap then member.Name:SetWordWrap(false) end
					member.Name:SetText(lang)
				end
			end
		)
	end

	if LFGListSearchEntry_Update then
		hooksecurefunc(
			"LFGListSearchEntry_Update",
			function(sel, ...)
				local sri = C_LFGList.GetSearchResultInfo(sel.resultID)
				if sri then
					local name = sri.leaderName
					if name == nil then return end
					local text = sel.Name:GetText()
					if sri.isWarMode then
						text = "[WM] " .. text
					end

					if sri.requiredItemLevel > 0 then
						text = "[ilvl: " .. sri.requiredItemLevel .. "+] " .. text
					end

					-- only when its for dungeon
					if sri.leaderDungeonScoreInfo and sri.leaderDungeonScoreInfo.mapScore then
						local score = ""
						if ImproveAny:IsEnabled("LFGSHOWOVERALLSCORE", false) and sri.leaderOverallDungeonScore and sri.leaderOverallDungeonScore > 0 then
							local color = C_ChallengeMode.GetDungeonScoreRarityColor(sri.leaderOverallDungeonScore)
							if color then
								score = "|c" .. color:GenerateHexColor() .. sri.leaderOverallDungeonScore .. "|r"
							end
						end

						local info = {}
						local bestRunLevel = sri.leaderDungeonScoreInfo.bestRunLevel
						if ImproveAny:IsEnabled("LFGSHOWDUNGEONKEY", false) and bestRunLevel and bestRunLevel > 0 then
							info[#info + 1] = bestRunLevel
						end

						if ImproveAny:IsEnabled("LFGSHOWDUNGEONSCORE", false) and sri.leaderDungeonScoreInfo.mapScore > 0 then
							local color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(sri.leaderDungeonScoreInfo.mapScore)
							if color then
								info[#info + 1] = "|c" .. color:GenerateHexColor() .. sri.leaderDungeonScoreInfo.mapScore .. "|r"
							end
						end

						if #info > 0 then
							if score ~= "" then
								score = score .. " (" .. table.concat(info, ":") .. ")"
							else
								score = table.concat(info, ":")
							end
						end

						if score ~= "" then
							text = score .. " " .. text
						end
					end

					if text then
						sel.Name:SetText(text)
					end

					local server = ""
					local s, _ = string.find(name, "-")
					if s then
						server = strsub(name, s + 1)
					else
						server = GetRealmName()
					end

					local lang = ImproveAny:GetFlagString(server, sel.ActivityName:GetText())
					if lang then
						if sel.ActivityName.SetWordWrap then sel.ActivityName:SetWordWrap(false) end
						sel.ActivityName:SetText(lang)
					end
				end
			end
		)
	end
end
