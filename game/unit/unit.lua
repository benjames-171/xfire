local M = {}

M.data = {}

function M.addunit(x, y, team, type, url)
	local unit = {x, y, team, type, url}
	table.insert(M.data, unit)
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

function M.deleteall()
	for k, v in pairs(M.data) do
		go.delete(v.url)
		table.remove(M.data, k)
	end
end

return M