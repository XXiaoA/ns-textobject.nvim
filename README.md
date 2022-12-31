<p align="center">
  <h2 align="center">ns-textobject.nvim</h2>
</p>

<p align="center">
	A textobejct plugin with nvim-surround
</p>

<p align="center">
	<a href="https://github.com/XXiaoA/ns-textobject.nvim/stargazers">
		<img alt="Stars" src="https://img.shields.io/github/stars/XXiaoA/ns-textobject.nvim?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41"></a>
	<a href="https://github.com/XXiaoA/ns-textobject.nvim/issues">
		<img alt="Issues" src="https://img.shields.io/github/issues/XXiaoA/ns-textobject.nvim?style=for-the-badge&logo=bilibili&color=F5E0DC&logoColor=D9E0EE&labelColor=302D41"></a>
	<a href="https://github.com/XXiaoA/ns-textobject.nvim">
		<img alt="Repo Size" src="https://img.shields.io/github/repo-size/XXiaoA/ns-textobject.nvim?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=302D41"/></a>
</p>

https://user-images.githubusercontent.com/62557596/210149085-8cb8c3e0-dd57-40c6-aeec-5fbac8aa01d1.mp4


### Requirements

- [nvim-surround](https://github.com/kylechui/nvim-surround)


### Installation

Install the plugin with your favourite package manager:

<details>
	<summary><a href="https://github.com/wbthomason/packer.nvim">Packer.nvim</a></summary>

```lua
use({
    "XXiaoA/ns-textobject.nvim",
    after = "nvim-surround",
    config = function()
        require("ns-textobject").setup({
            -- your configuration here
            -- or just left empty to use defaluts
        })
    end
})
```
</details>


### Usage

We will make the keymaps refer to your nvim-surround's aliases and surrounds automatically after calling `setup`. If you want to disable this feature, check the [Configuration](#Configuration) . <br>

Then you're able to map manually like the following:

<details>
<summary><font size="2" color="">Click to show the code.</font></summary>

```lua
local nstextobject = require("ns-textobject")

vim.keymap.set({ "x", "o" }, "aq", function()
    -- First parameter means a alias or surround of nvim-surround
    -- The second one has two choice: `a` means around or `i` means inside
    nstextobject.create_textobj("q", "a")
end, { desc = "Around the quote" })
vim.keymap.set({ "x", "o" }, "iq", function()
    nstextobject.create_textobj("q", "i")
end, { desc = "Inside the quote" })

-- Or a simple way:
-- First parameter means a alias or surround of nvim-surround
-- The second one used to add the description for keymap
nstextobject.map_textobj("q", "quotes")
```
</details>


### Configuration
```lua
{
    auto_mapping = {
        -- automatically mapping for nvim-surround's aliases
        aliases = true,
        -- for nvim-surround's surrounds
        surrounds = true,
    },
    disable_builtin_mapping = {
        enabled = true,
        -- list of char which shouldn't mapping by auto_mapping
        chars = { "b", "B", "t", "`", "'", '"', "{", "}", "(", ")", "[", "]", "<", ">" },
    },
}
```


### TODO
- [x] new option to disable auto mapping for builtin textobject (ib, etc.)
- [x] support nvim-surround
