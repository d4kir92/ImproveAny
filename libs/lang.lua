
local AddOnName, ImproveAny = ...

local ialang = {}
function ImproveAny:GetLangTab()
	return ialang
end

function ImproveAny:GT( str )
	local tab = ImproveAny:GetLangTab()
	local result = tab[str]
	if result ~= nil then
		return result
	else
		ImproveAny:MSG( format( "Missing Translation: %s", str ) )
		return str
	end
end

function ImproveAny:UpdateLanguage()
	ImproveAny:Lang_enUS()
	if GetLocale() == "deDE" then
		ImproveAny:Lang_deDE()
	elseif GetLocale() == "enUS" then
		ImproveAny:Lang_enUS()
	end
end
ImproveAny:UpdateLanguage()
