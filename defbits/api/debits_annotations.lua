--- @meta

--- @class ParticleData
--- @field public max_particles integer|nil
--- @field public factory_data FactoryData
--- @field public color_data ColorData|nil
--- @field public angle_data AngleData|nil
--- @field public life_data LifeData|nil
--- @field public speed_data SpeedData|nil
--- @field public emit_data EmitData|nil
--- @field public size_data SizeData|nil
--- @field public noise_data NoiseData|nil
--- @field public wind_data WindData|nil
--- @field public rotation_data RotationData|nil

---@class Emitter
---@field get_position fun() : EmitterData
---@field init fun()|nil
---@field cancel fun()|nil

---@class EmitterData
---@field position vector3
---@field dir vector3|nil

---@class DynamicEmitter : Emitter
---@field set_position fun(x:number, y:number)
---@field set_dir fun(x:number, y:number)

---@class FactoryData
---@field public url string
---@field public sprite_id string
---@field public collision_id string

---@class ColorData
---@field public start vector4
---@field public final vector4

---@class AngleData
---@field public angle number
---@field public angle_variance number

---@class LifeData
---@field public lifespan_min number
---@field public lifespan_max number

---@class SpeedData
---@field public speed_min number
---@field public speed_max number

---@class EmitData
---@field public interval number
---@field public emit_count integer

---size_end cannot be 0, put a small value instead
---@class SizeData
---@field public size_start_min number
---@field public size_start_max number
---@field public size_end number

---@class NoiseData
---@field public noise_min number
---@field public noise_max number

---@class WindData
---@field public wind_frequency_min number
---@field public wind_frequency_max number
---@field public wind_amplitude_min number
---@field public wind_amplitude_max number

---@class RotationData
---@field public rotation_speed_min number
---@field public rotation_speed_max number

---@class Vector2
---@field public x number
---@field public y number

---@class Vector4
---@field public x number
---@field public y number
---@field public z number
---@field public w number