
local AddOnName, MoveAny = ...

function IAMathC( val, vmin, vmax )
	if val == nil then
		return 0
	end
	if vmin == nil then
		return 0
	end
	if vmax == nil then
		return 1
	end
	if val < vmin then
		return vmin
	elseif val > vmax then
		return vmax
	else
		return val
	end
end

function IAMathR( val, dec )
	val = val or 0
	dec = dec or 0
	return tonumber( string.format( "%0." .. dec .. "f", val ) )
end

function IAFormatValue( val, dec )
	dec = dec or 1
	if val<1000 then return ("%." .. dec .. "f"):format(val)
	elseif val<1000000 then return ("%." .. dec .. "fk"):format(val/1000)
	elseif val<1000000000 then return ("%." .. dec .. "fm"):format(val/1000000)
	elseif val<1000000000000 then return ("%." .. dec .. "fb"):format(val/1000000000)
	else return ("%." .. dec .. "ft"):format(val/1000000000000) end
end
