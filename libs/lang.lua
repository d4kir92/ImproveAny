
local AddOnName, ImproveAny = ...

LANG_IA = LANG_IA or {}

function IAGT( str )
	local result = LANG_IA[str]
	if result ~= nil then
		return result
	else
		ImproveAny:MSG( format( "Missing Translation: %s", str ) )
		return str
	end
end

function IAUpdateLanguage()
	IALang_enUS()
	if GetLocale() == "deDE" then
		IALang_deDE()
	elseif GetLocale() == "enUS" then
		IALang_enUS()
	end
end
IAUpdateLanguage()
