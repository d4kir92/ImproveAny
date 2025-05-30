local _, ImproveAny = ...
ImproveAny:SetAddonOutput("ImproveAny", 136033)
function ImproveAny:Debug(msg, typ)
	if typ == "think" then return end
	if typ == "retry" then return end
	if false then
		ImproveAny:MSG("|cFFFF0000" .. "[DEBUG] " .. msg)
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

function ImproveAny:GetRowsCols(amount)
	local wurzel = math.sqrt(amount)
	if wurzel % 1 == 0 then return wurzel, wurzel end
	local rows, cols
	if wurzel % 1 > 0.5 then
		wurzel = math.ceil(wurzel)
		rows = wurzel
		cols = wurzel
	else
		wurzel = math.floor(wurzel)
		rows = wurzel
		cols = wurzel + 1
	end

	rows = ImproveAny:MathC(rows, 1, 20)
	cols = ImproveAny:MathC(cols, 1, 20)

	return rows, cols
end
