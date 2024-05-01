local M = {}

M.STATE_MENU = 1
M.STATE_CONTROLS = 2
M.STATE_OPTIONS = 3
M.STATE_CREDITS = 4
M.STATE_PLAYING = 5
M.STATE_CLEAR = 6
M.STATE_PAUSE = 7
M.STATE_GAMEOVER = 8
M.STATE_COMPLETE = 9

M.state = M.STATE_MENU

M.SCR_W = 0
M.SCR_H = 0
M.CANV_W = 0
M.CANV_H = 0
M.TILE_SIZE = 16
M.PIXEL_SIZE = 4
M.MAX_LEVELS = 10

M.level = 1
M.time = 0
M.currentsong = nil
M.offset = vmath.vector3()
M.player = vmath.vector3()
M.scroll = vmath.vector3()
M.bounds = vmath.vector3()
M.gate = {}

M.APP_NAME = "unnamed"
M.FILE_NAME = "unnamed.sav"

M.save = {
	sfx = 7,
	music = 7,
}

function M.clamp(v, min, max)
	if type(v) ~= "number" then v = 0 end
	if v < min then v = min
	elseif v > max then v = max
	end
	return v
end

function M.wrap(v, min, max)
	if type(v) ~= "number" then v = 0 end
	if v < min then v = max
	elseif v > max then v = min
	end
	return v
end

function M.world2tile(p)
	return vmath.vector3(math.floor((p.x + M.TILE_SIZE) / M.TILE_SIZE), math.floor((p.y + M.TILE_SIZE) / M.TILE_SIZE), p.z)
end

function M.tile2world(p)
	return vmath.vector3((p.x * M.TILE_SIZE) - (M.TILE_SIZE / 2), (p.y * M.TILE_SIZE) - (M.TILE_SIZE / 2), p.z)
end

function M.loadgamefile()
	local file = sys.load(sys.get_save_file(M.APP_NAME, M.FILE_NAME))

	if next(file) ~= nil then
		M.save = file
		return true
	end

	return false
end

function M.savegamefile()
	sys.save(sys.get_save_file(M.APP_NAME, M.FILE_NAME), M.save)
end

function M.hex2rgba(hex)
	hex = hex:gsub("#","")
	local rgba = vmath.vector4(tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255, 1)
	return rgba
end

function M.sound(id)
	if M.save.sfx > 0 then
		local t = M.gate[id] or 0
		t = M.clock - t
		if t > 0.05 then
			M.gate[id] = M.clock
			msg.post("main:/sound", "play", {id = id})
		end
	end
end

function M.playmusic(id)
	if id ~= nil then
		msg.post("main:/sound", "music", {id = id})
	end
end

function M.pausemusic(pause)
	msg.post("main:/sound", "pause", {pause = pause})
end

function M.stopmusic()
	msg.post("main:/sound", "stopmusic")
end

function M.onscreen(p, m)
	if p.x > M.scroll.x - m and
	p.x < M.scroll.x + m + M.offset.x * 2 and
	p.y > M.scroll.y - m and
	p.y < M.scroll.y + m + M.offset.y * 2 then
		return true
	else
		return false
	end
end

function M.ms2str(time)
	local day = math.floor(time / 86400)
	local rem = time % 86400
	local hr = math.floor(rem / 3600)
	rem = rem % 3600
	local min = math.floor(rem / 60)
	rem = rem % 60
	local sec = rem

	local str = ""
	if day > 0 then str = tostring(day) .. "d " end
	if hr > 0 or day > 0 then str = str .. tostring(hr) .. ":" end

	str = string.format("%s%02d:%02d", str, min, math.floor(sec))
	return str
end

function M.fullscreen(self)
	defos.toggle_fullscreen()
	defos.disable_window_resize()
	defos.disable_maximize_button()
end

return M
