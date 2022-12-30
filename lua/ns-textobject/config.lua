local M = {}
local ns_config = require("nvim-surround.config")
local textobj = require("ns-textobject.textobj")

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

M.user_opts = nil

function M.get_opts()
    return M.user_opts or M.default_opts
end

function M.auto_map()
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
            textobj.map_textobj(alias)
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
            textobj.map_textobj(surround)
        end
    end
end

function M.setup(opts)
    opts = opts or {}
    M.user_opts = vim.tbl_deep_extend("force", M.default_opts, opts)
    M.auto_map()
end

return M
