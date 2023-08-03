local _, ImproveAny = ...
local sw = 180
local sh = 18
local textc = "|cFF00FF00"
local textw = "|r"
local skillMax = -1
local skillIds = {}
local jobs = {}
local subTypes = {}

function ImproveAny:GetSkillData(name)
	local itemcur = nil
	local itemmax = nil
	local itemname = nil

	if GetSkillLineInfo then
		local id = skillIds[name]

		if id then
			local skillName, _, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(id)

			if skillName then
				itemcur = skillRank
				itemmax = skillMaxRank
				itemname = skillName
			end
		else
			local numSkillLines = 999

			if GetNumSkillLines then
				numSkillLines = GetNumSkillLines()
			end

			for i = 1, numSkillLines do
				local skillName, _, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(i)

				if skillName then
					if name == string.lower(skillName) then
						skillIds[name] = i
						itemcur = skillRank
						itemmax = skillMaxRank
						itemname = skillName

						return itemname, itemcur, itemmax
					end
				else
					break
				end
			end

			if name then
				skillIds[name] = -1
			end
		end
	end

	return itemname, itemcur, itemmax
end

function ImproveAny:GetWeaponSkillData(id)
	local itemcur = nil
	local itemmax = nil
	local itemname = nil
	local item = GetInventoryItemLink("player", id)

	if item then
		if subTypes[item] then
			itemname, itemcur, itemmax = ImproveAny:GetSkillData(subTypes[item])
		else
			_, _, _, _, _, _, itemSubType = GetItemInfo(item)

			if itemSubType then
				if AUCTION_SUBCATEGORY_ONE_HANDED then
					local s1, e1 = string.find(itemSubType, AUCTION_SUBCATEGORY_ONE_HANDED, 1, true)

					if s1 and e1 then
						local onehanded = string.gsub(AUCTION_SUBCATEGORY_ONE_HANDED, "%-", "_")
						itemSubType = string.gsub(itemSubType, "%-", "_")
						itemSubType, count = string.gsub(itemSubType, "(" .. onehanded .. ") ", "") -- english
						itemSubType, count = string.gsub(itemSubType, "(" .. onehanded .. ")", "") -- german
					end
				end

				itemSubType = string.lower(itemSubType)
			end

			subTypes[item] = itemSubType
			itemname, itemcur, itemmax = ImproveAny:GetSkillData(itemSubType)
		end
	end

	return itemname, itemcur, itemmax
end

function ImproveAny:SkillsThink()
	if GetNumSkillLines then
		numSkillLines = GetNumSkillLines()
	end

	if GetNumSkillLines ~= skillMax then
		skillMax = GetNumSkillLines
		skillIds = {}
		jobs = {}
		subTypes = {}

		if GetSkillLineInfo then
			for i = 1, 64 do
				local skillName, _, _, _, _, _, _, isAbandonable, _, _, _, _ = GetSkillLineInfo(i)

				if skillName and not tContains(jobs, skillName) then
					if isAbandonable then
						tinsert(jobs, skillName)
					end
				else
					break
				end
			end
		end
	end

	local id = 1
	local jobid = 1

	for i, bar in pairs(IASkills.bars) do
		local name, cur, max = bar:func(bar.args)

		if bar.args == "job" and jobs[jobid] then
			name, cur, max = bar:func(string.lower(jobs[jobid]))
			jobid = jobid + 1
		end

		if name and cur and max and cur < max then
			if not bar:IsShown() then
				bar:Show()
			end

			bar:SetPoint("TOPLEFT", IASkills, "TOPLEFT", 0, -(id - 1) * sh)
			bar.text:SetText(name .. " " .. textc .. cur .. textw .. "/" .. textc .. max)
			bar.bar:SetWidth(cur / max * bar.bar.sw)
			id = id + 1
		else
			if bar:IsShown() then
				bar:Hide()
			end
		end
	end

	if IASkills and IASkillsMover then
		IASkills:SetHeight((id - 1) * sh)
		IASkillsMover:SetHeight((id - 1) * sh)
	end

	C_Timer.After(0.5, ImproveAny.SkillsThink)
end

local skillid = 0

function ImproveAny:AddStatusBar(func, args)
	skillid = skillid + 1

	if skillid then
		IASkills.bars[skillid] = CreateFrame("FRAME", name, IASkills)
		local bar = IASkills.bars[skillid]
		bar.func = func
		bar.args = args
		bar:SetSize(sw, sh)
		bar:SetPoint("TOPLEFT", IASkills, "TOPLEFT", 0, 0)
		bar.bg = bar:CreateTexture(nil, "BACKGROUND")
		bar.bg:SetColorTexture(0.02, 0.02, 0.02, 0.4)
		bar.bg:SetDrawLayer("BACKGROUND", 0)
		bar.bar = bar:CreateTexture(nil, "BACKGROUND")
		bar.bar.sw = 0
		bar.bar:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
		bar.bar:SetVertexColor(0.2, 0.2, 1, 1)
		bar.bar:SetDrawLayer("BACKGROUND", 1)
		bar.text = bar:CreateFontString(nil, "ARTWORK")
		bar.text:SetFont(STANDARD_TEXT_FONT, 10, "")
		bar.text:SetPoint("CENTER", bar, "CENTER", 0, 0)
		bar.text:SetText("LOAD")
		bar.bar.sw = sw
		bar.bar:SetSize(sw, sh - 1.1)
		bar.bar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		bar.bg:SetSize(sw, sh - 1.1)
		bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
	end
end

function ImproveAny:InitSkillBars()
	if ImproveAny:GetWoWBuild() ~= "RETAIL" then
		IASkills = CreateFrame("FRAME", "IASkills", UIParent)
		IASkills:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 520, 0)
		IASkills:SetSize(sw, 6 * sh)
		IASkills.bars = {}
	end

	if ImproveAny:IsEnabled("SKILLBARS", false) and ImproveAny:GetWoWBuild() ~= "RETAIL" then
		ImproveAny:AddStatusBar(ImproveAny.GetWeaponSkillData, 16)
		ImproveAny:AddStatusBar(ImproveAny.GetWeaponSkillData, 17)
		ImproveAny:AddStatusBar(ImproveAny.GetWeaponSkillData, 18)
		ImproveAny:AddStatusBar(ImproveAny.GetSkillData, string.lower(STAT_CATEGORY_DEFENSE))
		ImproveAny:AddStatusBar(ImproveAny.GetSkillData, "job")
		ImproveAny:AddStatusBar(ImproveAny.GetSkillData, "job")
		ImproveAny:AddStatusBar(ImproveAny.GetSkillData, string.lower(PROFESSIONS_FIRST_AID))
		ImproveAny:AddStatusBar(ImproveAny.GetSkillData, string.lower(PROFESSIONS_COOKING))
		ImproveAny:AddStatusBar(ImproveAny.GetSkillData, string.lower(PROFESSIONS_FISHING))
		ImproveAny:SkillsThink()
	end
end