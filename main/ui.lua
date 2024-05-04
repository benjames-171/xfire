local M = {}

function M.show(node)
	gui.set_enabled(node, true)
end

function M.hide(node)
	gui.set_enabled(node, false)
end

function M.init(node)
	gui.set_enabled(node, false)
end

return M