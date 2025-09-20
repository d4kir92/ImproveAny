local _, ImproveAny = ...
local ialang = {}
function ImproveAny:GetLangTab()
	return ialang
end

function ImproveAny:GT(str)
	local tab = ImproveAny:GetLangTab()
	local result = tab[str]
	if result ~= nil then
		return result
	elseif str then
		ImproveAny:MSG(format("Missing Translation: %s", str))

		return str
	else
		ImproveAny:MSG("MISSING STR", str)
	end
end

function ImproveAny:UpdateLanguage()
	ImproveAny:Lang_enUS()
	if GetLocale() == "deDE" then
		ImproveAny:Lang_deDE()
	elseif GetLocale() == "ruRU" then
		ImproveAny:Lang_ruRU()
	elseif GetLocale() == "enUS" then
		ImproveAny:Lang_enUS()
	end
end

ImproveAny:UpdateLanguage()
