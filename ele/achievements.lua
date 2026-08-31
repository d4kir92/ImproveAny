local _, ImproveAny = ...
local pending = false
function ImproveAny:HasAchievementTracking()
	if C_ContentTracking and C_ContentTracking.GetTrackedIDs and C_ContentTracking.StopTracking and Enum and Enum.ContentTrackingType and Enum.ContentTrackingStopType then return true end
	if GetTrackedAchievements and RemoveTrackedAchievement then return true end

	return false
end

local function GetTrackedAchievementIDs()
	if C_ContentTracking and C_ContentTracking.GetTrackedIDs and Enum and Enum.ContentTrackingType then return C_ContentTracking.GetTrackedIDs(Enum.ContentTrackingType.Achievement) or {} end
	if GetTrackedAchievements then return {GetTrackedAchievements()} end

	return {}
end

local function UntrackAchievement(achievementID)
	if C_ContentTracking and C_ContentTracking.StopTracking and Enum and Enum.ContentTrackingType and Enum.ContentTrackingStopType then
		C_ContentTracking.StopTracking(Enum.ContentTrackingType.Achievement, achievementID, Enum.ContentTrackingStopType.Manual)

		return true
	end

	if RemoveTrackedAchievement then
		RemoveTrackedAchievement(achievementID)

		return true
	end

	return false
end

function ImproveAny:UntrackCompletedAchievements()
	if not ImproveAny:IsEnabled("UNTRACKCOMPLETEDACHIEVEMENTS", false) then return end
	if GetAchievementInfo == nil then return end
	if not ImproveAny:HasAchievementTracking() then return end
	for i, achievementID in ipairs(GetTrackedAchievementIDs()) do
		local _, name, _, completed = GetAchievementInfo(achievementID)
		if completed and UntrackAchievement(achievementID) then
			local link = nil
			if GetAchievementLink then link = GetAchievementLink(achievementID) end
			ImproveAny:MSG(ImproveAny:Trans("LID_UNTRACKEDACHIEVEMENT"), link or name or achievementID)
		end
	end
end

local function ScheduleUntrack()
	if pending then return end
	pending = true
	ImproveAny:After(1, function()
		pending = false
		ImproveAny:UntrackCompletedAchievements()
	end, "UntrackCompletedAchievements")
end

function ImproveAny:InitAchievements()
	if not ImproveAny:HasAchievementTracking() then return end
	local f = CreateFrame("Frame", "IAAchievements")
	ImproveAny:RegisterEvent(f, "ACHIEVEMENT_EARNED")
	ImproveAny:RegisterEvent(f, "TRACKED_ACHIEVEMENT_UPDATE")
	ImproveAny:RegisterEvent(f, "TRACKED_ACHIEVEMENT_LIST_CHANGED")
	ImproveAny:RegisterEvent(f, "CONTENT_TRACKING_UPDATE")
	ImproveAny:OnEvent(f, ScheduleUntrack, "UntrackCompletedAchievements")
	ImproveAny:After(5, function() ImproveAny:UntrackCompletedAchievements() end, "UntrackCompletedAchievements Login")
end
