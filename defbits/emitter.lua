local defbits = require("defbits.defbits")

local M = {}

--- Create a new emitter that emits particles from a static position.
--- @param position vector3
--- @return Emitter
function M.new_static_emitter(position)

    ---@type Emitter
    local emitter = {}
    local dir = nil
    function emitter.get_position()
        return {position = position, dir = dir}
    end

    return emitter
end

--- Create a new dynamic emitter
--- @return DynamicEmitter
function M.new_dynamic_emitter()
    ---@type DynamicEmitter
    local emitter = {}
    local position = vmath.vector3(0, 0, 0)
    local dir = nil

    function emitter.set_position(x, y)
        position.x = x
        position.y = y
    end

    function emitter.set_dir(x, y)
        dir = vmath.vector3(x, y, 0)
    end

    function emitter.get_position()
        return { position = position, dir = dir }
    end

    return emitter
end

--- Create a new emitter that emits particles from a line segment.
--- @param start_pos vector3
--- @param end_pos vector3
--- @return Emitter
function M.new_line_emitter(start_pos, end_pos)
    ---@type Emitter
    local emitter = {}
    function emitter.get_position()
        local t = math.random()
        local x = (1 - t) * start_pos.x + t * end_pos.x
        local y = (1 - t) * start_pos.y + t * end_pos.y
        return {position = vmath.vector3(x, y, start_pos.z)}
    end
    return emitter
end

--- Create a new emitter that emits particles from a circle.
--- @param center vector3
--- @param radius number
--- @return Emitter
function M.new_circle_emitter(center, radius)

    ---@type Emitter
    local emitter = {}
    function emitter.get_position()
        local angle = math.random() * 2 * math.pi
        local r = math.sqrt(math.random()) * radius
        local x = center.x + r * math.cos(angle)
        local y = center.y + r * math.sin(angle)
        return {position = vmath.vector3(x, y, 0), dir = nil}
    end

    return emitter
end

--- Create a new emitter that emits particles from a rectangle.
--- @param top_left vector3
--- @param bottom_right vector3
--- @return Emitter
function M.new_rect_emitter(top_left, bottom_right)
    ---@type Emitter
    local emitter = {}
    emitter.get_position = function()
        local x = math.random() * (bottom_right.x - top_left.x) + top_left.x
        local y = math.random() * (bottom_right.y - top_left.y) + top_left.y
        return {position = vmath.vector3(x, y, 0), dir = nil}
    end
    return emitter
end

--- Create a new spiral emitter.
--- @param position vector3
--- @param speed number
--- @return Emitter
function M.new_spiral_emitter(position, speed)
    ---@type Emitter
    local emitter = {}

    local pi = math.pi
    local rotation_speed = math.pi * speed
    local dir = 0
    local handle

    emitter.init = function()
        dir = 0
        handle = timer.delay(0, true, function()
            dir = dir + rotation_speed * defbits.DT
            if dir > 2 * pi then
                dir = dir - 2 * pi
            end
        end)
    end

    emitter.cancel = function()
        timer.cancel(handle)
    end

    emitter.get_position = function()
        return {position = position, dir = vmath.vector3(math.cos(dir), math.sin(dir), 0)}
    end
    return emitter
end

--- Create a new heart emitter.
--- @param position vector3
function M.new_heart_emitter(position, amount, radius)
    ---@type Emitter
    local emitter = {}
    local i = 1

    --- Get the next position and direction
    emitter.get_position = function()
        local angle = i * 2 * math.pi / amount
        i = i + 1
        if i >= amount then
            i = 1
        end

        local x = (math.sqrt(2) * math.pow(math.sin(angle), 3)) * radius
        local y = (math.pow(-math.cos(angle), 3) - math.pow(math.cos(angle), 2) + 2 * math.cos(angle)) * -radius

        local v = vmath.vector3(x, y, 0)
        local v_norm = vmath.normalize(v)
        return {position = vmath.vector3(position.x - x, position.y - y, 0), dir = -v_norm}
    end

    return emitter
end

--- Create a new Lissajous curve emitter.
--- @param position vector3
--- @param amount number -- Number of particles to emit
--- @param A number -- Amplitude for x
--- @param B number -- Amplitude for y
--- @param a number -- Frequency multiplier for x
--- @param b number -- Frequency multiplier for y
--- @param delta number -- Phase shift for x
function M.new_lissajous_emitter(position, amount, A, B, a, b, delta)
    ---@type Emitter
    local emitter = {}
    local i = 1

    --- Get the next position and direction
    emitter.get_position = function()
        -- Calculate the parameter t for the Lissajous curve
        local t = i * 2 * math.pi / amount
        i = i + 1
        if i > amount then
            i = 1
        end

        -- Calculate the position on the Lissajous curve
        local x = A * math.sin(a * t + delta)
        local y = B * math.sin(b * t)
        
        -- Calculate the direction based on the Lissajous curve
        local dx = A * a * math.cos(a * t + delta)
        local dy = B * b * math.cos(b * t)
        local direction = vmath.vector3(dx, dy, 0)
        
        -- Normalize the direction vector
        local dir_vector = vmath.normalize(direction)
        
        -- Create the position vector
        local position_vector = vmath.vector3(position.x + x, position.y + y, 0)

        return {position = position_vector, dir = dir_vector}
    end

    return emitter
end




return M