local _, ImproveAny = ...
local tab = {}
local seen = {}
local tries = {}
local restoring = false
local checks = 0
local function GetTokenListSize()
	if GetCurrencyListSize then
		return GetCurrencyListSize()
	elseif C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListSize then
		return C_CurrencyInfo.GetCurrencyListSize()
	end

	return 0
end

local function GetTokenInfo(index)
	if GetCurrencyListInfo then
		local name, isHeader, _, _, isWatched, count, icon = GetCurrencyListInfo(index)

		return name, isHeader, isWatched, count, icon
	elseif C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListInfo then
		local info = C_CurrencyInfo.GetCurrencyListInfo(index)
		if info then return info.name, info.isHeader, info.isShowInBackpack, info.quantity, info.iconFileID end
	end

	return nil
end

local function SetTokenWatched(index, state)
	if SetCurrencyBackpack then
		SetCurrencyBackpack(index, state)

		return true
	elseif C_CurrencyInfo and C_CurrencyInfo.SetCurrencyBackpack then
		C_CurrencyInfo.SetCurrencyBackpack(index, state)

		return true
	end

	return false
end

function ImproveAny:GetWatchedTokens()
	IATABPC = IATABPC or {}
	IATABPC["WATCHEDTOKENS"] = IATABPC["WATCHEDTOKENS"] or {}

	return IATABPC["WATCHEDTOKENS"]
end

function ImproveAny:UpdateWatchedTokens()
	if restoring then return end
	if not ImproveAny:IsEnabled("TOKENBARRESTORE", true) then return end
	local saved = ImproveAny:GetWatchedTokens()
	for index = 1, GetTokenListSize() do
		local name, isHeader, isWatched = GetTokenInfo(index)
		if name == nil then break end
		if not isHeader then
			local try = tries[name] or 0
			if saved[name] and not isWatched and try < 3 and (seen[name] == nil or try > 0) then
				tries[name] = try + 1
				restoring = true
				local done = SetTokenWatched(index, true)
				restoring = false
				ImproveAny:Debug("tokenbar.lua: restore " .. name .. " " .. tostring(done), "tokenbar")
				if not done then return end
			elseif isWatched then
				saved[name] = true
				tries[name] = nil
			elseif try == 0 then
				saved[name] = nil
			end

			seen[name] = true
		end
	end
end

local function CheckWatchedTokens()
	ImproveAny:UpdateWatchedTokens()
	checks = checks + 1
	if checks < 6 then ImproveAny:After(5, CheckWatchedTokens, "CheckWatchedTokens") end
end

function ImproveAny:GetTokenList()
	tab = {}
	for index = 1, GetTokenListSize() do
		local name, isHeader, isWatched, count, icon = GetTokenInfo(index)
		if name then
			if isWatched and not isHeader then
				tinsert(
					tab,
					{
						["name"] = name,
						["count"] = count,
						["icon"] = icon
					}
				)
			end
		else
			break
		end
	end

	if IATokenBar and IATokenBar.text then
		local text = ""
		for i, token in pairs(tab) do
			if text ~= "" then
				text = text .. " "
			end

			text = text .. token.count .. "|T" .. token.icon .. ":0:0:0:0:64:64|t"
		end

		IATokenBar.text:SetText(text)
	end
end

IATokenBar = CreateFrame("FRAME", "IATokenBar", UIParent)
function ImproveAny:InitTokenBar()
	if ImproveAny:IsEnabled("TOKENBARRESTORE", true) then
		local watcher = CreateFrame("FRAME", "IAWatchedTokens")
		ImproveAny:RegisterEvent(watcher, "CURRENCY_DISPLAY_UPDATE")
		ImproveAny:OnEvent(
			watcher,
			function(sel, ...)
				ImproveAny:UpdateWatchedTokens()
			end, "IAWatchedTokens"
		)

		ImproveAny:After(2, CheckWatchedTokens, "CheckWatchedTokens")
	end

	if ImproveAny:IsEnabled("TOKENBAR", false) then
		IATokenBar:SetSize(180, 20)
		IATokenBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -200, 130)
		IATokenBar:EnableMouse(true)
		IATokenBar.text = IATokenBar:CreateFontString(nil, "ARTWORK")
		IATokenBar.text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
		IATokenBar.text:SetPoint("CENTER", IATokenBar, "CENTER", 0, 0)
		IATokenBar.text:SetText("ImproveAny - Tokenbar")
		ImproveAny:RegisterEvent(IATokenBar, "CURRENCY_DISPLAY_UPDATE")
		ImproveAny:OnEvent(
			IATokenBar,
			function(sel, ...)
				ImproveAny:GetTokenList()
			end, "IATokenBar"
		)

		if TokenFrame_Update then
			hooksecurefunc(
				"TokenFrame_Update",
				function()
					ImproveAny:GetTokenList()
				end
			)
		end

		ImproveAny:GetTokenList()
	end
end
