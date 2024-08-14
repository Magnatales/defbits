local defbits = require "defbits.defbits"

local M = {}

local fps = 0
local fps_time = 0
local frames = {}

function M.update(dt)
    fps_time = fps_time + dt
	if fps_time > 1 then
		fps = #frames
		frames = {}
		fps_time = 0
	end
	table.insert(frames, 1 / dt)

	local fps = string.format("%.0f", fps) -- Assuming `fps` is a number

	label.set_text("#label",
		"FPS: " .. fps .. "\n" ..
		"Particles: " .. defbits.TotalParticles
	)
end

return M