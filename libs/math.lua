local _, ImproveAny = ...
function ImproveAny:Debug(msg, typ)
	if typ == "think" then return end
	if typ == "retry" then return end
	--if msg ~= "minimap.lua: UpdatePos #2" then return end
	if false then
		print("|cFFFF0000" .. "[DEBUG][ImproveAny |T136033:16:16:0:0|t] " .. msg)
	end
end

function ImproveAny:MathC(val, vmin, vmax)
	if val == nil then return 0 end
	if vmin == nil then return 0 end
	if vmax == nil then return 1 end
	if val < vmin then
		return vmin
	elseif val > vmax then
		return vmax
	else
		return val
	end
end

function ImproveAny:MathR(val, dec)
	val = val or 0
	dec = dec or 0

	return tonumber(string.format("%0." .. dec .. "f", val))
end

function ImproveAny:FormatValue(val, dec)
	dec = dec or 1
	if val < 1000 then
		return ("%." .. 0 .. "f"):format(val)
	elseif val < 1000000 then
		return ("%." .. dec .. "fk"):format(val / 1000)
	elseif val < 1000000000 then
		return ("%." .. dec .. "fm"):format(val / 1000000)
	elseif val < 1000000000000 then
		return ("%." .. dec .. "fb"):format(val / 1000000000)
	else
		return ("%." .. dec .. "ft"):format(val / 1000000000000)
	end
end

function ImproveAny:Lerp(pos1, pos2, perc)
	return (1 - perc) * pos1 + perc * pos2
end

function ImproveAny:ReplaceStr(text, old, new)
	if text == nil then return "" end
	local b, e = text:find(old, 1, true)
	if b == nil then
		return text
	else
		return text:sub(1, b - 1) .. new .. text:sub(e + 1)
	end
end

function ImproveAny:GetRowsCols(amount)
	local wurzel = math.sqrt(amount)
	if wurzel * wurzel == amount then return math.ceil(wurzel), math.ceil(wurzel) end
	if wurzel % 1 >= 0.5 then return math.ceil(wurzel), math.ceil(wurzel) end

	return math.floor(wurzel), math.ceil(wurzel)
end