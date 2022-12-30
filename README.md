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

https://user-images.githubusercontent.com/62557596/196021198-cac764a0-7aac-494b-a4cc-03d679acfedb.mp4


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

We will make the keymaps refer to your nvim-surround's aliases automatically after calling `setup`, if your `auto_mapping` option is true (defalut is true). <br>

Or, you could map manually like the following:

<details>
<summary><font size="2" color="">Click to show the code.</font></summary>

```lua
local nstextobject = require("ns-textobject")

vim.keymap.set({ "x", "o" }, "aq", function()
    -- q means a alias or surround of nvim-surround
    -- a means around or i means inside
    nstextobject.create_textobj("q", "a")
end, { desc = "around the quote" })
vim.keymap.set({ "x", "o" }, "iq", function()
    nstextobject.create_textobj("q", "i")
end, { desc = "inside the quote" })
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
