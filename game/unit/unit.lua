local data = require "main.data"

local M = {}

M.names = {"TROOPER", "X4-MECH", "SCOUT"}
M.armor = {4,6,2}
M.power = {5,7,3}
M.movemax = {10,8,12}
M.firemax = {3,2,4}
M.hp = {8,10,5}
M.ai = {false, true}

M.current = nil
M.data = {}
M.turn = 1
M.next = 0

function M.init()
	M.data = {}
	M.current = nil
	M.turn = 1
	M.next = 0
end

function M.add(x, y, team, type, url)
	local diff = 1
	if M.ai[team] then
		diff = data.diff()
	end
	local unit = {x = x, y = y, team = team, type = type, hp = M.hp[type] * diff, url = url, armor = M.armor[type], power = M.power[type],
		move = M.movemax[type], movmax = M.movemax[type], fire = M.firemax[type], firemax = M.firemax[type]}
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

function M.findurl(url)
	for _, v in pairs(M.data) do
		if v.url == url then
			return v
		end
	end
	return nil
end

function M.getname(type)
	return M.names[type]
end

function M.endturn()

end

function M.delete(x, y)
	for k, v in pairs(M.data) do
		if v.x == x and v.y == y then
			go.delete(v.url)
			table.remove(M.data, k)
			return
		end
	end
end

return M