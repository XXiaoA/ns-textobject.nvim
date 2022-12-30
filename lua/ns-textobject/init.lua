local M = {}
local config = require("ns-textobject.config")
local textobj = require("ns-textobject.textobj")

function M.create_textobj(char, mode)
    textobj.create_textobj(char, mode)
end

function M.map_textobj(char, desc)
    textobj.map_textobj(char, desc)
end

function M.setup(opts)
    config.setup(opts)
end

return M
