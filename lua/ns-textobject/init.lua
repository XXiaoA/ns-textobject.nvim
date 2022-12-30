local M = {}

local ns_utils = require("nvim-surround.utils")
local ns_buffer = require("nvim-surround.buffer")
local ns_config = require("nvim-surround.config")

M.default_opts = {
    auto_mapping = {
        aliases = true,
        surrounds = true,
    },
    disable_builtin_mapping = {
        enabled = true,
        chars = { "b", "B", "t", "`", "'", '"', "{", "}", "(", ")", "[", "]", "<", ">" },
    },
}

-- Gets the nearest two selections for the left and right surrounding pair.
---@param char string? A character representing what kind of surrounding pair is to be selected.
---@param mode "i"|"a" Inside or around
---@return table A table containing the start and end positions of the delimiters.
local function get_nearest_selections(char, mode)
    char = ns_utils.get_alias(char)

    local chars = ns_config.get_opts().aliases[char] or { char }
    chars = type(chars) == "string" and { chars } or chars
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

    --- store current operatorfunc because nvim-surround may change it
    local _operatorfunc = vim.go.operatorfunc
    local nearest_selections = get_nearest_selections(alias, mode)
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
    end
end

---@param mode string|table
function M.set_keymap(mode)
    --- set a new keymap
    ---@param lhs string
    ---@param rhs string|function
    ---@param opts table
    return function(lhs, rhs, opts)
        opts = opts or {}

        local options = vim.tbl_extend("force", {
            noremap = true,
            silent = true,
        }, opts)

        vim.keymap.set(mode, lhs, rhs, options)
    end
end

function M.auto_map()
    local textobj_map = M.set_keymap({ "x", "o" })
    if M.user_opts.auto_mapping.aliases then
        local aliases = vim.tbl_keys(ns_config.get_opts().aliases)
        if M.user_opts.disable_builtin_mapping.enabled then
            aliases = vim.tbl_filter(function(surround)
                local bulitin_mappings = M.user_opts.disable_builtin_mapping.chars
                if not vim.tbl_contains(bulitin_mappings, surround) then
                    return surround
                end
            end, aliases)
        end

        for _, alias in ipairs(aliases) do
            textobj_map("i" .. alias, function()
                M.create_textobj(alias, "i")
            end)
            textobj_map("a" .. alias, function()
                M.create_textobj(alias, "a")
            end)
        end
    end

    if M.user_opts.auto_mapping.surrounds then
        local surrounds = vim.tbl_keys(ns_config.get_opts().surrounds)
        if M.user_opts.disable_builtin_mapping.enabled then
            surrounds = vim.tbl_filter(function(surround)
                local bulitin_mappings = M.user_opts.disable_builtin_mapping.chars
                if
                    not vim.tbl_contains(bulitin_mappings, surround)
                    and surround ~= "invalid_key_behavior"
                then
                    return surround
                end
            end, surrounds)
        end
        for _, surround in ipairs(surrounds) do
            textobj_map("i" .. surround, function()
                M.create_textobj(surround, "i")
            end)
            textobj_map("a" .. surround, function()
                M.create_textobj(surround, "a")
            end)
        end
    end
end

function M.setup(opts)
    opts = opts or {}
    M.user_opts = vim.tbl_deep_extend("force", M.default_opts, opts)
    M.auto_map()
end

return M
