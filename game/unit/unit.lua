local M = {}

M.data = {}

function M.init()
	M.data = {}
end

function M.add(x, y, team, type, url)
	local unit = {x = x, y = y, team = team, type = type, url = url}
	table.insert(M.data, unit)
end

function M.find(x, y)
	for _, v in pairs(M.data) do
		if v.x == x and v.y == y then
			return v
		end
	end
	return nil
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