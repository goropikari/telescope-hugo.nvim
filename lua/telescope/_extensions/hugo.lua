local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local telescope = require('telescope')

local fm = require('front-matter')

local function list_markdown_files(directory)
  local files = vim.fs.find(function(name, path)
    return name:match('.*%.md$')
  end, { limit = math.huge, type = 'file', path = directory })

  return files
end

local function list_article_metadata()
  local content_path = vim.fs.joinpath(vim.fn.getcwd(), 'content')

  local markdowns = list_markdown_files(content_path)
  local metadata = fm.get(markdowns) or {}
  local mds = {}
  for path, md in pairs(metadata) do
    md.path = path
    table.insert(mds, md)
  end

  return mds
end

local function articles_picker(opts)
  opts = opts or {}

  local function make_display(entry)
    local displayer = entry_display.create({
      separator = ' ',
      items = {
        { width = opts.bufnr_width },
        { width = opts.bufnr_width },
      },
    })

    local path = vim.fn.fnamemodify(entry.path, ':.')
    return displayer({
      path,
      entry.value.title,
    })
  end

  pickers
    .new(opts, {
      prompt_title = 'Find Articles',
      finder = finders.new_table({
        results = list_article_metadata(),
        entry_maker = function(entry)
          local tags = entry.tags or {}

          return {
            value = entry,
            path = entry.path,
            display = make_display,
            ordinal = vim.fn.join({ entry.title, vim.fn.join(tags) }, '_'),
          }
        end,
      }),
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return telescope.register_extension({
  exports = {
    hugo = articles_picker,
  },
})
