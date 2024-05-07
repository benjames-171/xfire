local M = {}

M.data = {}
M.names = {"TROOP", "MECHA", "SCOUT"}
M.arm = {6,8,4}
M.pow = {4,6,2}
M.movemax = {9,6,12}
M.firemax = {2,1,3}
M.current = nil

function M.init()
	M.data = {}
end

function M.add(x, y, team, type, url)
	local unit = {	x = x, y = y, team = team, type = type, hp = 8, url = url, arm = M.arm[type], pow = M.pow[type],
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