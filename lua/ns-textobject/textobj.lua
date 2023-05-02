local M = {}
local ns_utils = require("nvim-surround.utils")
local ns_buffer = require("nvim-surround.buffer")
local ns_config = require("nvim-surround.config")
local textobj_map = require("ns-textobject.keymap").textobj_map

-- Gets the nearest two selections for the left and right surrounding pair.
---@param char string? A character representing what kind of surrounding pair is to be selected.
---@param mode "i"|"a" Inside or around
---@return table A table containing the start and end positions of the delimiters.
local function get_nearest_selections(char, mode)
    char = ns_config.get_alias(char)

    local chars = ns_config.get_opts().aliases[char] or { char }
    chars = type(chars) == "string" and { chars } or chars
    local curpos = ns_buffer.get_curpos()
    local selections_list = {}
    -- Iterate through all possible selections for each aliased character, and find the closest pair
    local winview = vim.fn.winsaveview()
    for _, c in ipairs(chars) do
        local cur_selections
        cur_selections = ns_config.get_delete(c)(c)
        -- If found, add the current selections to the list of all possible selections
        if cur_selections then
            selections_list[#selections_list + 1] = cur_selections
        end
        -- Reset the cursor position
        ns_buffer.set_curpos(curpos)
    end
    vim.fn.winrestview(winview)
    local nearest_selections = ns_utils.filter_selections_list(selections_list)
    -- If a pair of selections is found, jump to the beginning of the left one
    if nearest_selections then
        if mode == "a" then
            ns_buffer.set_curpos(nearest_selections.left.first_pos)
        else
            ns_buffer.set_curpos({
                nearest_selections.left.last_pos[1],
                nearest_selections.left.last_pos[2] + 1,
            })
        end
    end

    return nearest_selections
end

--- create textobject
---@param char string
---@param mode "i"|"a"
function M.create_textobj(char, mode)
    local cur_mode = vim.api.nvim_get_mode().mode

    if cur_mode == "v" then
        vim.cmd.normal("v")
    end

    --- store current operatorfunc because nvim-surround may change it
    local _operatorfunc = vim.go.operatorfunc
    local nearest_selections = get_nearest_selections(char, mode)
    vim.go.operatorfunc = _operatorfunc

    if nearest_selections then
        if mode == "a" then
            ns_buffer.set_curpos(nearest_selections.left.first_pos)
        else
            ns_buffer.set_curpos({
                nearest_selections.left.last_pos[1],
                nearest_selections.left.last_pos[2] + 1,
            })
        end

        vim.cmd.normal("v")
        if mode == "a" then
            ns_buffer.set_curpos(nearest_selections.right.last_pos)
        else
            ns_buffer.set_curpos({
                nearest_selections.right.first_pos[1],
                nearest_selections.right.first_pos[2] - 1,
            })
        end
    else
        vim.defer_fn(function()
            if vim.api.nvim_get_mode().mode == "i" then
                vim.cmd.stopinsert()
                vim.cmd.normal("l")
            end
        end, 0.2)
    end
end

--- add keymap for inside and around textobject
---@param char string
---@param desc string
function M.map_textobj(char, desc)
    local mode_desc = { i = "Inside ", a = "Around " }
    for _, mode in ipairs({ "i", "a" }) do
        textobj_map(mode .. char, function()
            M.create_textobj(char, mode)
        end, { desc = type(desc) == "string" and mode_desc[mode] .. desc or nil })
    end
end

return M
