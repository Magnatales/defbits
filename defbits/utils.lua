local M = {}

local random = math.random

function M.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

--- Lerp between two vector 4
--- @param v1 vector4
--- @param v2 vector4  
--- @param t number
function M.lerp_v(v1, v2, t)
    local x = v1.x + (v2.x - v1.x) * t
    local y = v1.y + (v2.y - v1.y) * t
    local z = v1.z + (v2.z - v1.z) * t
    local w = v1.w + (v2.w - v1.w) * t

    return vmath.vector4(x, y, z, w)
end

--- Lerp between two numbers
--- @param start number
--- @param final number
--- @param t number
--- @return number
function M.lerp(start, final, t)
    return start + (final - start) * t
end

--- Convert number degrees to number radians
--- @param degrees number
--- @return number radians
function M.deg_to_rad(degrees)
    return degrees * math.pi / 180
end

--- Return a random number between min and max
--- @param min number
--- @param max number
function M.random(min, max)
    return random() * (max - min) + min
end

--- Return a random vector4 

--- Convert hex color to rgba
--- @param hex string
--- @param alpha number
function M.hex (hex, alpha) 
	local redColor,greenColor,blueColor=hex:match('#?(..)(..)(..)')
	redColor, greenColor, blueColor = tonumber(redColor, 16)/255, tonumber(greenColor, 16)/255, tonumber(blueColor, 16)/255
	if alpha == nil then
		return redColor, greenColor, blueColor
	end
	return redColor, greenColor, blueColor, alpha
end

function M.hex_to_vec4(hex, alpha)
    local r, g, b, a = M.hex(hex, alpha)
    return vmath.vector4(r, g, b, a)
end


return M