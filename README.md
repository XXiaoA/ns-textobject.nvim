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

&nbsp;

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
})
```
</details>


### Usage
```lua
local nstextobject = require("nstextobject")

vim.keymap.set({ "x", "o" }, "aq", function()
    -- q means the alias of nvim-surround
    -- a means around or i means inside
    nstextobject.create_textobj("q", "a")
end, { desc = "around the quote" })
vim.keymap.set({ "x", "o" }, "iq", function()
    nstextobject.create_textobj("q", "i")
end, { desc = "inside the quote" })

vim.keymap.set({ "x", "o" }, "aa", function()
    nstextobject.create_textobj("a", "a")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
    nstextobject.create_textobj("a", "i")
end)

vim.keymap.set({ "x", "o" }, "ar", function()
    nstextobject.create_textobj("r", "a")
end)
vim.keymap.set({ "x", "o" }, "ir", function()
    nstextobject.create_textobj("r", "i")
end)
```
