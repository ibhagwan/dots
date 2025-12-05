---@diagnostic disable: inject-field
require('fzf-lua').setup({
  { "cli" },
  fzf_opts = {
    ["--border-label-pos"] = "4:bottom",
    ["--border"] = os.getenv("TMUX") and "rounded" or "horizontal",
  },
  ---@diagnostic disable-next-line: missing-fields
  hls = {
    title = "diffAdd",
    title_flags = "PmenuSel",
    header_bind = "Directory",
    header_text = "WarningMsg",
    live_prompt = "ErrorMsg",
  },
  ---@diagnostic disable-next-line: missing-fields
  previewers = { bat = { theme = "Catppuccin Mocha" } },
  actions = {
    files = {
      true,
      ["enter"] = function(s, o)
        local entries = vim.tbl_map(function(e) return FzfLua.path.entry_to_file(e, o) end, s)
        entries = vim.tbl_map(function(e)
          ---@diagnostic disable-next-line: undefined-field, param-type-mismatch
          e.path = FzfLua.path.relative_to(e.path, vim.uv.cwd())
          return e
        end, entries)
        io.stdout:write(vim.json.encode(entries) .. "\n")
        vim.cmd.quit()
      end,
    }
  },
  grep = {
    prompt = false,
    ---@diagnostic disable-next-line: param-type-mismatch
    fzf_opts = { ["--history"] = vim.fs.joinpath(vim.fn.stdpath("data"), "fzf_search_hist") },
  },
  ---@diagnostic disable-next-line: missing-fields
  zoxide = {
    actions = {
      ["enter"] = function(s)
        local entries = vim.tbl_map(function(e) return { path = e:match("[^\t]+$") } end, s)
        io.stdout:write(vim.json.encode(entries) .. "\n")
        vim.cmd.quit()
      end
    },
  },
})

local yadm_opts = {
  -- debug = true,
  cwd_header = false,
  cwd = "$HOME",
  git_dir = "$YADM_REPO",
  git_worktree = "$HOME",
  git_config = "status.showUntrackedFiles=no",
}

FzfLua.git_lgrep = function(opts)
  return FzfLua.live_grep(vim.tbl_extend("force",
    { cmd = "git grep -i --line-number --column --color=always" }, opts))
end

FzfLua.yadm_files = function(opts)
  return FzfLua.git_files(vim.tbl_extend("force",
    yadm_opts, { fzf_opts = { ["--border-label"] = "Yadm Files" } }, opts))
end

FzfLua.yadm_branches = function(opts)
  return FzfLua.git_branches(vim.tbl_extend("force",
    yadm_opts, { fzf_opts = { ["--border-label"] = "Yadm Branches" } }, opts))
end

FzfLua.yadm_commits = function(opts)
  FzfLua.git_commits(vim.tbl_extend("force",
    yadm_opts, { fzf_opts = { ["--border-label"] = "Yadm Commits" } }, opts))
end

FzfLua.yadm_lgrep = function(opts)
  FzfLua.live_grep(vim.tbl_extend("force", yadm_opts, {
    fzf_opts = { ["--border-label"] = "Yadm Grep" },
    cmd = "git --git-dir=${YADM_REPO} -C ${HOME} grep -i --line-number --column --color=always",
    rg_glob = false, -- this isn't `rg`
  }, opts))
end

FzfLua.yadm_status = function(opts)
  FzfLua.git_status(vim.tbl_extend("force",
    yadm_opts, { fzf_opts = { ["--border-label"] = "Yadm Status" }, cmd = "git status -s" }, opts))
end

FzfLua.yadm_hunks = function(opts)
  FzfLua.git_hunks(vim.tbl_extend("force",
    yadm_opts, { fzf_opts = { ["--border-label"] = "Yadm Hunks" }, path_shorten = true }, opts))
end
