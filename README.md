# telescope-hugo.nvim

This is a [telescope](https://github.com/nvim-telescope/telescope.nvim) extension for managing Markdown articles in a Hugo-based project. It recursively scans the `content` directory and allows you to search for articles based on titles and tags.


## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'goropikari/telescope-hugo.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    {
      'goropikari/front-matter.nvim',
      opts = {},
      build = 'make setup',
    },
  },
},
```

## Usage

To launch the picker for Hugo articles:

```lua
:lua require('telescope').extensions.hugo.hugo()
```

## License

This plugin is licensed under the MIT License.
