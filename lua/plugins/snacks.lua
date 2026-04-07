local Snacks = require "snacks"
local header = [[
██████████████████████████████████████████████████████████████████
██                                                              ██
██  ██████████████████████████  ██████████          ██████  ██  ██
██  ██      ██████      ██████  ██                  ██          ██
██  ██  ██  ██████  ██  ██████  ██████      ██████  ██  ██  ██  ██
██  ██  ██          ██  ██████  ██          ██████  ██  ██  ██  ██
██  ██  ██  ██  ██  ██      ██  ██████████  ██  ██  ██████  ██  ██
██  ██  ██  ██  ██  ██  ██  ██                                  ██
██  ██  ██  ██  ██  ██  ██  ██  ████████████████  ████████████████
██  ██  ██  ██  ██  ██  ██  ██  ██████████████            ████████
██  ██                  ██  ██  ████            ████████  ████████
██  ██                ██    ██  ████            ██    ██        ██
██  ██  ██████████████    ████  ████████████    ██    ██  ████  ██
██  ██                  ██████  ██████████████  ████████  ████  ██
██  ██████████████████████████                                  ██
██                                     EmGiXIII@EmGiCO.         ██
██████████████████████████████████████▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄██████████
]]

---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
    },
    image = {
      enabled = false,
    },
    scratch = {
      enabled = true,
    },
    quickfile = {},
    explorer = { enabled = true, replace_netrw = true },
    dashboard = {
      formats = {
        key = function(item) return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } } end,
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function() return Snacks.git.get_root() ~= nil end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
      preset = {
        header = header,
      },
    },
    statuscolumn = {
      enabled = true,
      left = { "mark" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true,
        git_hl = true,
      },
    },
    picker = {
      db = {
        sqlite3_path = "/lib/x86_64-linux-gnu/libsqlite3.so.0", -- Path to sqlite3 shared object
      },
      previewers = {
        diff = {
          builtin = false, -- use Neovim for previewing diffs (true) or use an external tool (false)
          cmd = { "delta" }, -- example to show a diff with delta
        },
        git = {
          builtin = false, -- use Neovim for previewing git output (true) or use git (false)
          args = { "-c", "core.pager=delta" }, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
        },
        -- file = {
        --   max_size = 1024 * 1024, -- 1MB
        --   max_line_length = 500, -- max line length
        --   ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
        -- },
        -- man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
      },
      matcher = {
        frecency = true,
        cwd_bonus = true,
      },
      layout = function(source)
        for key, _ in pairs { "explorer", "lines" } do
          ---@diagnostic disable-next-line nil can be returned to default to plugin default
          if source == key then return nil end
        end
        return {
          preview = nil,
          layout = {
            box = "vertical",
            backdrop = {
              blend = 90,
              transparent = true,
              bg = "#000000",
            },
            width = 0.9,
            height = 0.9,
            position = "float",
            border = "double",
            title = " {title} {live} {flags}",
            title_pos = "center",
            { win = "preview", title = "{preview}", border = "bottom" },
            { win = "list", height = 0.20, border = "bottom" },
            { win = "input", height = 1, border = "none" },
          },
        }
      end,
    },
    words = {
      enabled = true,
    },
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<Leader>e"] = {
              function() Snacks.explorer() end,
              desc = "Open Explorer",
            },
            ["<Leader>fu"] = {
              function() Snacks.picker.undo() end,
              desc = "Find Undos",
            },
            ["<Leader>fP"] = {
              function() Snacks.picker.pickers() end,
              desc = "Find all Pickers",
            },
            ["<Leader>."] = {
              function() Snacks.scratch() end,
              desc = "Open Scratch Buffer",
            },
            ["<Leader>f."] = {
              function() Snacks.scratch.select() end,
              desc = "Search Scratch Buffers",
            },
            --- Snacks Words implementation
            ["]]"] = {
              function() Snacks.words.jump(vim.v.count1) end,
              desc = "Snacks words jump next",
            },
            ["[["] = {
              function() Snacks.words.jump(-vim.v.count1) end,
              desc = "Snacks words jump prev",
            },
          },
        },
      },
    },
  },
  specs = {
    {
      "rebelot/heirline.nvim",
      optional = true,
      opts = function(_, opts) opts.statuscolumn = nil end,
    },
  },
}
