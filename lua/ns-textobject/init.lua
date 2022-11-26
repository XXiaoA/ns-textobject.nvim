local M = {}

local ns_utils = require("nvim-surround.utils")
local ns_buffer = require("nvim-surround.buffer")
local ns_config = require("nvim-surround.config")

M.default_opts = {
    auto_mapping = true,
    disable_builtin_mapping = true,
}

-- Gets the nearest two selections for the left and right surrounding pair.
---@param char string? A character representing what kind of surrounding pair is to be selected.
---@param mode "i"|"a" Inside or around
---@return table A table containing the start and end positions of the delimiters.
local function get_nearest_selections(char, mode)
    char = ns_utils.get_alias(char)

    local chars = ns_config.get_opts().aliases[char] or { char }
    local curpos = ns_buffer.get_curpos()
    local selections_list = {}
    -- Iterate through all possible selections for each aliased character, and find the closest pair
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
---@param alias string
---@param mode "i"|"a"
function M.create_textobj(alias, mode)
    local cur_mode = vim.api.nvim_get_mode().mode

    if cur_mode == "v" then
        vim.cmd.normal("v")
    end
    local nearest_selections = get_nearest_selections(alias, mode)
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
    end
end

function M.setup(opts)
    opts = opts or {}
    M.user_opts = vim.tbl_deep_extend("force", M.default_opts, opts)

    if M.user_opts.auto_mapping then
        local aliases = vim.tbl_keys(ns_config.user_opts.aliases)
        for _, alias in ipairs(aliases) do
            -- disable 'b' and 'B' mapping if `disable_builtin_mapping` option is true
            if M.user_opts.disable_builtin_mapping and (alias == "b" or alias == "B") then
                goto countine
            end

            vim.keymap.set({ "x", "o" }, "i" .. alias, function()
                M.create_textobj(alias, "i")
            end)
            vim.keymap.set({ "x", "o" }, "a" .. alias, function()
                M.create_textobj(alias, "a")
            end)

            ::countine::
        end
    end
end

return M
