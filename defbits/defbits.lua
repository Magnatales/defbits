local utils = require("defbits.utils")

local Defbits = {}

---@type integer
Defbits.TotalParticles = 0

local random = math.random

---@type number
Defbits.DT = 0

--- Create a new particle emitter
--- @param emitter Emitter
--- @param data ParticleData
--- @return Defbits defbits
function Defbits.new(emitter, data)

    assert(emitter, "Emitter must be provided to create a particle emitter")
    assert(data, "Particle data must be provided to create a particle emitter")
    assert(data.factory_data, "Factory data must be provided to create a particle emitter")
    assert(data.factory_data.url, "Factory URL must be provided to create a particle emitter")
    assert(data.factory_data.sprite_id, "Sprite ID must be provided to create a particle emitter")

    ---@type ParticleData
    local default_data = {
        max_particles = 150,
        factory_data = { url = "", sprite_id = "", collision_id = "" },
        color_data = { start = vmath.vector4(1, 1, 1, 1), final = vmath.vector4(1, 1, 1, 1) },
        angle_data = { angle = 180, angle_variance = 45 },
        life_data = { lifespan_min = 1, lifespan_max = 1 },
        speed_data = { speed_min = 50, speed_max = 50 },
        emit_data = { interval = 0.01, emit_count = 1 },
        size_data = { size_start_min = 1, size_start_max = 1, size_end = 1 },
        noise_data = { noise_min = 0, noise_max = 0 },
        rotation_data = { rotation_speed_min = 0, rotation_speed_max = 0 }
    }

	---@type ParticleData
    local particle_data = {
        max_particles = data.max_particles or default_data.max_particles,
        factory_data = data.factory_data,
        color_data = data.color_data or default_data.color_data,
        angle_data = data.angle_data or default_data.angle_data,
        life_data = data.life_data or default_data.life_data,
        speed_data = data.speed_data or default_data.speed_data,
        emit_data = data.emit_data or default_data.emit_data,
        size_data = data.size_data or default_data.size_data,
        noise_data = data.noise_data or default_data.noise_data,
        rotation_data = data.rotation_data or default_data.rotation_data
    }

    ---@class Defbits
    ---@field TotalParticles integer
    ---@field particles integer
    local defbits = {}

    local particles = 0

    --- Initialize a particle
    --- @param position vector3
    local function initialize_particle(position, dir)
        local lifespan = utils.random(particle_data.life_data.lifespan_min, particle_data.life_data.lifespan_max)
        local rotationSpeed = utils.random(particle_data.rotation_data.rotation_speed_min, particle_data.rotation_data.rotation_speed_max)
        local speed = random(particle_data.speed_data.speed_min, particle_data.speed_data.speed_max)

        local starting_scale = random(particle_data.size_data.size_start_min, particle_data.size_data.size_start_max)

        local direction = vmath.vector3()
        if not dir then
            local angle = random(particle_data.angle_data.angle - particle_data.angle_data.angle_variance,
                particle_data.angle_data.angle + particle_data.angle_data.angle_variance)
            angle = utils.deg_to_rad(angle)
            direction = vmath.vector3(math.sin(angle), -math.cos(angle), 0)
        else
            direction = dir
        end

        local game_object = factory.create(particle_data.factory_data.url, position, nil, nil, starting_scale)
        local sprite_id = msg.url(nil, game_object, particle_data.factory_data.sprite_id)

        local end_position = position + direction * speed * lifespan
        local end_scale = particle_data.size_data.size_end
        local end_color = particle_data.color_data.final

        if position.x ~= end_position.x then
            go.animate(game_object, "position.x", go.PLAYBACK_ONCE_FORWARD, end_position.x, go.EASING_LINEAR, lifespan)
        end

        if position.y ~= end_position.y then
            go.animate(game_object, "position.y", go.PLAYBACK_ONCE_FORWARD, end_position.y, go.EASING_LINEAR, lifespan)
        end

        if rotationSpeed ~= 0 then
            go.animate(game_object, "euler.z", go.PLAYBACK_LOOP_PINGPONG, rotationSpeed, go.EASING_LINEAR, lifespan)
        end

        if starting_scale ~= end_scale then
            go.animate(game_object, "scale.x", go.PLAYBACK_ONCE_FORWARD, end_scale, go.EASING_LINEAR, lifespan)
            go.animate(game_object, "scale.y", go.PLAYBACK_ONCE_FORWARD, end_scale, go.EASING_LINEAR, lifespan)
        end

        if type(particle_data.color_data.start) == "table" then
            local color = particle_data.color_data.start[random(#particle_data.color_data.start)]
            go.set(sprite_id, "tint", color)
        else
            go.set(sprite_id, "tint", particle_data.color_data.start)
        end
        if particle_data.color_data.start ~= end_color then
            if particle_data.color_data.start.x ~= end_color.x then
                go.animate(sprite_id, "tint.x", go.PLAYBACK_ONCE_FORWARD, end_color.x, go.EASING_LINEAR, lifespan)
            end
            if particle_data.color_data.start.y ~= end_color.y then
                go.animate(sprite_id, "tint.y", go.PLAYBACK_ONCE_FORWARD, end_color.y, go.EASING_LINEAR, lifespan)
            end
            if particle_data.color_data.start.z ~= end_color.z then
                go.animate(sprite_id, "tint.z", go.PLAYBACK_ONCE_FORWARD, end_color.z, go.EASING_LINEAR, lifespan)
            end
            if particle_data.color_data.start.w ~= end_color.w then
                go.animate(sprite_id, "tint.w", go.PLAYBACK_ONCE_FORWARD, end_color.w, go.EASING_LINEAR, lifespan)
            end
        end

        timer.delay(lifespan, false, function()
            go.delete(game_object)
            particles = particles - 1
            Defbits.TotalParticles = Defbits.TotalParticles - 1
        end)
    end

    --- Add a particle to the emitter
    --- @param emitter_data EmitterData
    local function add_particle(emitter_data)
        local position = emitter_data.position
        local dir = emitter_data.dir
        if particle_data.noise_data.noise_max ~= 0 then
        position = position +
        vmath.vector3(random(-particle_data.noise_data.noise_min, particle_data.noise_data.noise_max), random(-particle_data.noise_data.noise_min, particle_data.noise_data.noise_max), 0)
        end
        particles = particles + 1
        Defbits.TotalParticles = Defbits.TotalParticles + 1
        initialize_particle(position, dir)
    end

    local function emit()
        if particles + particle_data.emit_data.emit_count >= particle_data.max_particles  then return end
        for _ = 1, particle_data.emit_data.emit_count do
            add_particle(emitter.get_position())
        end
    end

    local handler

    --- Start emitting particles
    function defbits.emit()
        handler = timer.delay(particle_data.emit_data.interval, true, function()
            emit()
        end)
        if emitter.init then
            emitter.init()
        end
    end

    --- Emit an amount of particles once
    function defbits.emit_once(amount)
        for _ = 1, amount do
            add_particle(emitter.get_position())
        end
    end

    --- Start emitting particles for a duration, then cancel
    function defbits.emit_for(duration)
        local timer_count = 0
        local handler
        handler = timer.delay(particle_data.emit_data.interval, true, function()
            emit()
            timer_count = timer_count + particle_data.emit_data.interval
            if timer_count >= duration then
                timer.cancel(handler)
                if emitter.cancel then
                    emitter.cancel()
                end
            end
        end)
        if emitter.init then
            emitter.init()
        end
    end

    --- Cancel emitting particles
    function defbits.cancel()
        timer.cancel(handler)
        if emitter.cancel then
            emitter.cancel()
        end
    end

    return defbits
end

return Defbits
