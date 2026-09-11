local _, D4 = ...
local initRealms = false
local initRealmLangs = false
local missingRealmNameOnce = true
local missingRealms = {}
local realms = {}
local missingRealmLangs = {}
local region = GetCurrentRegion and GetCurrentRegion() or 1
local withoutSpaces = {}
local realmLangs = {}
local missingRegionOnce = true
local missingWoWBuildOnce = true
local realmData = {}
local regions = {
    ["US"] = 1,
    ["KR"] = 2,
    ["EU"] = 3,
    ["TW"] = 4,
}

local function IsUkrainianLetters(str)
    return str:match("[\192-\199]") ~= nil
end

local function IsRussianLetters(str)
    return str:match("[\192-\255]") ~= nil
end

local function IsChineseLetters(str)
    return str:match("[\228-\233]") ~= nil
end

local function IsKoreanLetters(str)
    return str:match("[\234-\237]") ~= nil
end

function D4:AddRealmData(func)
    table.insert(realmData, func)
end

function D4:MissingRealmRegion(reg)
    if reg == 5 then return end
    if missingRegionOnce == false then return end
    missingRegionOnce = false
    if reg == 72 then return end
    D4:MSG("[D4] Missing REGION", reg)
end

local function InitRealms()
    if #realmData == 0 and missingWoWBuildOnce then
        missingWoWBuildOnce = false
        D4:MSG("[D4] Missing WoW-Build", D4:GetWoWBuildNr())
    end

    for i = 1, #realmData do
        realmData[i](realms, region, regions)
    end

    for name, val in pairs(realms) do
        if string.find(name, "-", 1, true) ~= nil then
            withoutSpaces[name:gsub("-", "")] = val
        end

        if string.find(name, " ", 1, true) ~= nil then
            withoutSpaces[name:gsub(" ", "")] = val
        end
    end

    for name, val in pairs(withoutSpaces) do
        realms[name] = val
    end
end

function D4:GetRealmLang(realmName)
    if D4:IsSecret(realmName) then return "" end
    if initRealms == false then
        initRealms = true
        InitRealms()
    end

    if GetLocale() == "" then return "" end
    if not (GetLocale() == "enUS" or GetLocale() == "deDE" or GetLocale() == "koKR" or GetLocale() == "zhTW") then return "" end
    if realmName == nil then
        if missingRealmNameOnce then
            missingRealmNameOnce = false
            D4:MSG("[D4] Realmname is nil!")
        end

        return ""
    end

    if realmName == "" then
        realmName = GetRealmName()
    end

    if realms[realmName] == nil then
        if IsUkrainianLetters(realmName) then
            return "ukUA"
        elseif IsRussianLetters(realmName) then
            return "ruRU"
        elseif IsChineseLetters(realmName) then
            return "zhCN"
        elseif IsKoreanLetters(realmName) then
            return "koKR"
        else
            if missingRealms[realmName] == nil then
                missingRealms[realmName] = true
                D4:MSG("[D4][GetRealmLang] Missing Realm-Language", realmName)
            end

            return ""
        end
    end

    return realms[realmName]
end

local function InitRealmLangs()
    -- deDE 
    realmLangs["Deutsch"] = "deDE"
    realmLangs["German"] = "deDE"
    realmLangs["독일어"] = "deDE"
    realmLangs["德國"] = "deDE"
    -- esES 
    realmLangs["Spanish"] = "esES"
    realmLangs["Spanisch"] = "esES"
    realmLangs["스페인어"] = "esES"
    realmLangs["拉丁美洲"] = "esES"
    realmLangs["라틴 아메리카"] = "esES"
    realmLangs["Lateinamerika"] = "esES"
    realmLangs["Latin America"] = "esES"
    realmLangs["西班牙"] = "esES"
    -- enUS 
    if region == regions["EU"] then
        realmLangs["English"] = "enGB"
        realmLangs["Englisch"] = "enGB"
        realmLangs["영어"] = "enGB"
        realmLangs["美國"] = "enGB"
        realmLangs["미국"] = "enGB"
        realmLangs["Vereinigte Staaten"] = "enGB"
        realmLangs["United States"] = "enGB"
        realmLangs["Global"] = "enGB"
        realmLangs["글로벌"] = "enGB"
        realmLangs["全球"] = "enGB"
        realmLangs["Saisonbedingt"] = "enGB"
        realmLangs["Hardcore"] = "enGB"
        realmLangs["Classic-Ära"] = "enGB"
        realmLangs["Seasonal"] = "enGB"
        realmLangs["Classic Era"] = "enGB"
    else
        realmLangs["English"] = "enUS"
        realmLangs["Englisch"] = "enUS"
        realmLangs["영어"] = "enUS"
        realmLangs["美國"] = "enUS"
        realmLangs["미국"] = "enUS"
        realmLangs["Vereinigte Staaten"] = "enUS"
        realmLangs["United States"] = "enUS"
        realmLangs["Global"] = "enUS"
        realmLangs["글로벌"] = "enUS"
        realmLangs["全球"] = "enUS"
        realmLangs["Saisonbedingt"] = "enUS"
        realmLangs["Hardcore"] = "enUS"
        realmLangs["Classic-Ära"] = "enUS"
        realmLangs["Seasonal"] = "enUS"
        realmLangs["Classic Era"] = "enUS"
    end

    -- enGB 
    realmLangs["大洋洲"] = "enGB"
    realmLangs["오세아니아"] = "enGB"
    realmLangs["Ozeanisch"] = "enGB"
    realmLangs["Oceanic"] = "enGB"
    realmLangs["英國"] = "enGB"
    -- frFR 
    realmLangs["French"] = "frFR"
    realmLangs["Französisch"] = "frFR"
    realmLangs["프랑스어"] = "frFR"
    realmLangs["法國"] = "frFR"
    -- itIT 
    realmLangs["Italian"] = "itIT"
    realmLangs["Italienisch"] = "itIT"
    realmLangs["이탈리아어"] = "itIT"
    realmLangs["義大利"] = "itIT"
    -- koKR 
    realmLangs["Korea"] = "koKR"
    realmLangs["한국"] = "koKR"
    realmLangs["韓國"] = "koKR"
    -- ptBR 
    realmLangs["巴西"] = "ptBR"
    realmLangs["브라질"] = "ptBR"
    realmLangs["Brasilien"] = "ptBR"
    realmLangs["Brazil"] = "ptBR"
    -- ruRU 
    realmLangs["Russian"] = "ruRU"
    realmLangs["Russisch"] = "ruRU"
    realmLangs["러시아어"] = "ruRU"
    realmLangs["俄羅斯"] = "ruRU"
    -- cnTW 
    realmLangs["Taiwan"] = "chTW"
    realmLangs["대만"] = "chTW"
    realmLangs["台灣"] = "chTW"
end

function D4:GetRealmFlag(realmName)
    if D4:IsSecret(realmName) then return "" end
    if initRealmLangs == false then
        initRealmLangs = true
        InitRealmLangs()
    end

    if realmName == "" then
        realmName = GetRealmName()
    end

    if not (GetLocale() == "enUS" or GetLocale() == "deDE" or GetLocale() == "koKR" or GetLocale() == "zhTW") then return "" end
    local realmLang = D4:GetRealmLang(realmName)
    if realmLang == nil then return "" end
    if realmLangs[realmLang] == nil then
        if realmLang == nil then
            if missingRealmLangs[realmLang] == nil then
                missingRealmLangs[realmLang] = true
                D4:MSG("[D4] Missing realmsLangs", realmName, realmLang)
            end

            return ""
        end

        return realmLang
    end

    return realmLangs[realmLang]
end

function D4:LoadRealms()
    InitRealms()
    InitRealmLangs()
end
