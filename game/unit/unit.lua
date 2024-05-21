local data = require "main.data"

local M = {}

M.MAX_VIS = 256

M.names = {"TROOPER", "HEAVY MECH", "LIGHT DRONE"}
M.armor = {4,6,2}
M.power = {5,8,3}
M.movemax = {8,6,10}
M.firemax = {3,2,4}
M.hp = {8,10,5}

M.obj = nil
M.stat = nil
M.data = {}
M.cursor = {}
M.total = {0, 0}
M.turn = 1
M.numturns = 0
M.next = 0
M.targets = 0

function M.init()
	M.data = {}
	M.total = {0, 0}
	M.obj = nil
	M.stat = nil
	M.turn = 1
	M.numturns = 1
	M.next = 0
end

function M.add(x, y, team, type, obj)
	local diff = 1
	local movextra = 0
	local firextra = 0
	
	if data.save.ai[team] then
		diff = data.diff()
		movextra = data.save.diff
		firextra = data.clamp(data.save.diff, 0, 2)
	end

	local unit = {x = x, y = y, team = team, type = type, hp = M.hp[type] * diff, hpmax = M.hp[type] * diff, obj = obj,
	armor = M.armor[type], power = M.power[type], move = M.movemax[type] + movextra, movemax = M.movemax[type] + movextra,
	fire = M.firemax[type] + firextra, firemax = M.firemax[type] + firextra}

	table.insert(M.data, unit)
	M.total[team] = M.total[team] + 1
end

function M.sortdata()
	local i = 1
	local t = {}
	local order = {3,1,2}
	for type = 1, 3 do
		for _,v in pairs(M.data) do
			if v.type == order[type] then
				t[i] = v
				i = i + 1
			end
		end
	end
	M.data = t
end

function M.prepteam(team)
	for _, v in pairs(M.data) do
		if v.team == team then
			v.move = v.movemax
			v.fire = v.firemax
		end
	end
end

function M.findxy(x, y)
	for _, v in pairs(M.data) do
		if v.x == x and v.y == y then
			return v
		end
	end
	return nil
end

function M.findobj(obj)
	for _, v in pairs(M.data) do
		if v.obj == obj then
			return v
		end
	end
	return nil
end

function M.findtargets(self)
	self.target = {}
	local pos = data.tile2world(vmath.vector3(M.stat.x, M.stat.y, 0)) + vmath.vector3(-8, -8, 0)
	M.targets = 0

	for _, v in pairs(M.data) do
		if M.stat.team ~= v.team then
			local target = data.tile2world(vmath.vector3(v.x, v.y, 0)) + vmath.vector3(-8, -8, 0)
			local ray = physics.raycast(pos, target, {hash("world")})
			if ray == nil and vmath.length(target - pos) < M.MAX_VIS then
				table.insert(self.target, vmath.vector3(v.x, v.y, 0))
				M.targets = M.targets + 1
			end
		end
	end
	return M.targets
end

function M.getname(type)
	return M.names[type]
end

function M.delete(x, y)
	for k, v in pairs(M.data) do
		if v.x == x and v.y == y then
			go.delete(v.obj)
			table.remove(M.data, k)
			return
		end
	end
end

function M.setcursor()
	local pos = vmath.vector3()
	local total = 0
	for _, v in pairs(M.data) do
		if v.team == M.turn then
			pos = pos + vmath.vector3(v.x, v.y, 0)
			total = total + 1
		end
	end
	data.cursor = pos / total
	data.cursor.x = math.floor(data.cursor.x)
	data.cursor.y = math.floor(data.cursor.y)
end

function M.dropflag()
	local pos = data.world2tile(go.get_position())
	tilemap.set_tile("level#tilemap", "control", pos.x, pos.y, 178)
	data.flag = pos
	data.flaginplay = false
end

function M.gameover()
	local t = {}
	for n = 1, data.MAX_TEAMS do
		t[n] = 0
	end
	for _, v in pairs(M.data) do
		t[v.team] = t[v.team] + 1
	end
	for n = 1, data.MAX_TEAMS do
		if t[n] == 0 then
			return true
		end
	end
	return false
end

return M