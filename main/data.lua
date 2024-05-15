local M = {}

M.STATE_NULL = -1

M.STATE_MENU = 1
M.STATE_CONTROLS = 2
M.STATE_OPTIONS = 3
M.STATE_CREDITS = 4
M.STATE_SELECT = 5
M.STATE_PAUSE = 6

M.STATE_PLAYING = 10
M.STATE_UNIT = 11
M.STATE_FIRE = 12
M.STATE_MAP = 13
M.STATE_COMPLETE = 14
M.STATE_POWERUP = 15
M.STATE_AI = 16

M.state = M.STATE_MENU

M.SCR_W = 0
M.SCR_H = 0
M.CANV_W = 0
M.CANV_H = 0
M.TILE_SIZE = 16
M.MAP_SIZE = 64
M.MAX_TEAMS = 2

M.currentsong = nil
M.cursor = vmath.vector3()
M.scroll = vmath.vector3()
M.offset = vmath.vector3(8.5, 8.5, 0)
M.bounds = vmath.vector4(0, -2, M.MAP_SIZE - 16, M.MAP_SIZE - 14)
M.gate = {}
M.wp = {}
M.hints = {}
M.teamname = {"", ""}
M.maxwp = 0
M.level = 1
M.clock = 0

M.APP_NAME = "Xfire"
M.FILE_NAME = "Xfire.sav"

M.save = {
	diff = 2,
	length = 1,
	hints = true,
	ai = {false, true},
	speed = 2,
	sfx = 8,
	music = 8,
}

function M.diff()
	local d = {0.7, 1, 1.2}
	return d[M.save.diff] or 1
end

function M.speed()
	local s = {0.7, 0.4, 0.1}
	return s[M.save.speed] or 1
end

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

function M.walltile(t)
	return t > 0 and t <= 80
end

function M.solidtile(t)
	return t >= 81 and t <= 112
end

function M.world2tile(p)
	return vmath.vector3(math.ceil(p.x / M.TILE_SIZE), math.ceil(p.y / M.TILE_SIZE), p.z)
end

function M.tile2world(p)
	return vmath.vector3(p.x * M.TILE_SIZE, p.y * M.TILE_SIZE, p.z)
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
		t = os.clock() - t
		if t > 0.05 then
			M.gate[id] = os.clock()
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

function M.formattime(time)
	local hr = math.floor(time / 3600)
	local rem = time % 3600
	local min = math.floor(rem / 60)
	rem = rem % 60
	local sec = rem

	local ex = ""
	if hr > 0 then
		ex = tostring(hr)..":"
	end
	local text = string.format("%s%02d:%02d", ex, min, math.floor(sec))

	return text
end

function M.fullscreen()
	defos.toggle_fullscreen()
	defos.disable_window_resize()
	defos.disable_maximize_button()
end

return M

