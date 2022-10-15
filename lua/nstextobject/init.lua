local M = {}

local api = vim.api
local utils = require("nvim-surround.utils")
local buffer = require("nvim-surround.buffer")
local config = require("nvim-surround.config")

-- Gets the nearest two selections for the left and right surrounding pair.
---@param char string? A character representing what kind of surrounding pair is to be selected.
---@param mode "i"|"a" Inside or around
---@return table A table containing the start and end positions of the delimiters.
local function get_nearest_selections(char, mode)
    char = utils.get_alias(char)

    local chars = config.get_opts().aliases[char] or { char }
    local curpos = buffer.get_curpos()
    local selections_list = {}
    -- Iterate through all possible selections for each aliased character, and find the closest pair
    for _, c in ipairs(chars) do
        local cur_selections
        cur_selections = config.get_delete(c)(c)
        -- If found, add the current selections to the list of all possible selections
        if cur_selections then
            selections_list[#selections_list + 1] = cur_selections
        end
        -- Reset the cursor position
        buffer.set_curpos(curpos)
    end
    local nearest_selections = utils.filter_selections_list(selections_list)
    -- If a pair of selections is found, jump to the beginning of the left one
    if nearest_selections then
        if mode == "a" then
            buffer.set_curpos(nearest_selections.left.first_pos)
        else
            local left_pos = nearest_selections.left.first_pos
            buffer.set_curpos({ left_pos[1], left_pos[2] + 1 })
        end
    end

    return nearest_selections
end

--- create textobject
---@param alias string
---@param mode "i"|"a"
function M.create_textobj(alias, mode)
    -- note the cursor position of end point and start point
    -- so that we can restore the visual mode if fail to find quotes
    local start_curpos, end_curpos
    local is_visual

    if api.nvim_get_mode().mode == "v" then
        end_curpos = buffer.get_curpos()
        vim.cmd.normal("o")
        start_curpos = buffer.get_curpos()
        vim.cmd.normal("v")
        is_visual = true
    end

    local nearest_selections = get_nearest_selections(alias, mode)
    if nearest_selections then
        local right_pos = nearest_selections.right.first_pos
        vim.cmd.normal("v")
        if mode == "a" then
            buffer.set_curpos(right_pos)
        else
            buffer.set_curpos({ right_pos[1], right_pos[2] - 1 })
        end
    elseif is_visual then
        buffer.set_curpos(start_curpos)
        vim.cmd.normal("v")
        buffer.set_curpos(end_curpos)
    end
end

return M
