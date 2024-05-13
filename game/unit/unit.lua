local data = require "main.data"

local M = {}

M.names = {"TROOPER", "X4-MECHA", "C2-SCOUT"}
M.armor = {4,6,2}
M.power = {5,8,3}
M.movemax = {8,6,10}
M.firemax = {3,2,4}
M.hp = {8,10,5}
M.ai = {false, true}

M.obj = nil
M.stat = nil
M.data = {}
M.cursor = {}
M.turn = 1
M.next = 0

function M.init()
	M.data = {}
	M.obj = nil
	M.stat = nil
	M.turn = 1
	M.next = 0
end

function M.add(x, y, team, type, obj)
	local diff = 1
	if M.ai[team] then
		diff = data.diff()
	end
	local unit = {x = x, y = y, team = team, type = type, hp = M.hp[type] * diff, hpmax = M.hp[type] * diff, obj = obj,
		armor = M.armor[type], power = M.power[type], move = M.movemax[type], movemax = M.movemax[type],
		fire = M.firemax[type], firemax = M.firemax[type]}
	table.insert(M.data, unit)
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
	local pos = go.get_position() + vmath.vector3(-8, -8, 0)
	local total = 0

	for _, v in pairs(M.data) do
		if M.stat.team ~= v.team then
			local target = data.tile2world(vmath.vector3(v.x, v.y, 0)) + vmath.vector3(-8, -8, 0)
			local ray = physics.raycast(pos, target, {hash("world")})
			if ray == nil then
				table.insert(self.target, vmath.vector3(v.x, v.y, 0))
				total = total + 1
			end
		end
	end

	return total
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