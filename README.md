## dots

#### NOTE: This repo excludes my neovim config which can be found [here](https://github.com/ibhagwan/nvim-lua)

### Deployment

This repo is managed using a
[git bare repo](https://www.atlassian.com/git/tutorials/dotfiles)
and deployed using
[`dots/install.sh`](https://github.com/ibhagwan/dots/blob/master/dots/install.sh):

```sh
# clones this repository into "$HOME"
❯ git clone https://github.com/ibhagwan/dots.git $HOME/dots
# deploys the files in this repository into "$HOME"
❯ ./dots/install.sh
```

An alias named `dot` will be created:
```sh
alias dot="git -c status.showUntrackedFiles=no --git-dir=${YADM_REPO} -C ${HOME}"
```

Which you can use to manage your dot files as if it was `git`:
```sh
❯ dot status         # git status
❯ dot pull --rebase  # git pull --rebase
```

### Fzf Customizations

[`fzf`](https://github.com/junegunn/fzf) customizations inspired by
[@junegunn's git functions](https://github.com/junegunn/fzf-git.sh) are installed by
[`fzf_git_functions.sh`](https://github.com/ibhagwan/dots/blob/master/.config/zsh/fzf_git_functions.sh) and
[`fzf_git_keybindings.sh`](https://github.com/ibhagwan/dots/blob/master/.config/zsh/fzf_git_keybindings.zsh)
which add the below keybinds to the shell:

| Key       | Command           |
| ----------| ------------------|
| `<A-c>`   | cd directory      |
| `<C-r>`   | cmd history       |
| `<C-t>`   | find paths        |
| `<C-f>`   | "live" grep       |

If the pwd is inside a git repo, the following binds are available:

| Key       | Command           | Key       | Command              |
| ----------| ------------------| ----------| ---------------------|
| `<C-g-f>` | git ls-files      | `<C-g-s>` | git stashes          |
| `<C-g-b>` | git branches      | `<C-g-h>` | git hashes (commits) |
| `<C-g-g>` | git grep          | `<C-g-r>` | git remtoes          |
| `<C-g-t>` | git tags          | `<C-g-e>` | git for-each-ref     |
| `<C-g-l>` | git reflogs       | `<C-g-w>` | git worktrees        |

And the same for the `yadm` dot files repo with `<C-y>` prefix:
| Key       | Command           | Key       | Command              |
| ----------| ------------------| ----------| ---------------------|
| `<C-y-f>` | yadm ls-files     | `<C-y-s>` | yadm stashes         |
| `<C-y-b>` | yadm branches     | `<C-y-h>` | yadm hashes (commits)|
| `<C-y-g>` | yadm grep         | `<C-y-r>` | yadm remtoes         |
| `<C-y-t>` | yadm tags         | `<C-y-e>` | yadm for-each-ref    |
| `<C-y-l>` | yadm reflogs      | `<C-y-w>` | yadm worktrees       |



### rEFInd

If you're looking for my rEFInd setup as shown
[here](https://www.reddit.com/r/unixporn/comments/ff0o8d/refind_which_kernel_are_you_feeling_like_today/):

**Note:** I've since installed Void Linux (side-by-side with the rest of the OS's), [`refind.conf`](https://github.com/ibhagwan/dots/blob/master/dots/refind/refind.conf) reflects the new setup.

![rEFInd](https://github.com/ibhagwan/dots/raw/master/dots/screenshots/rEFInd.png)
