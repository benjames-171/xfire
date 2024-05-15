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

function M.getmetrics(nodename)
	local node = gui.get_node(nodename)
	local text = gui.get_text(node)
	local font_name = gui.get_font(node)
	local font = gui.get_font_resource(font_name)

	if text == nil then
		text = gui.get_text(node)
	end

	return resource.get_text_metrics(font, text)
end

return M