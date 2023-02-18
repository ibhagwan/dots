## dots

### Notes

- This repo excludes my neovim config which can be found
[here](https://github.com/ibhagwan/nvim-lua)

- This repo is deployed using [`yadm`](https://github.com/TheLocehiliosan/yadm) using the
[`install.sh`](https://github.com/ibhagwan/dots/blob/master/dots/install.sh) script

### Fzf Customizations

[`fzf`](https://github.com/junegunn/fzf) customizations inspired by
[@junegunn's git functions](https://github.com/junegunn/fzf-git.sh) are installed by
[`fzf_git_functions.sh`](https://github.com/ibhagwan/dots/blob/master/.config/zsh/fzf_git_functions.sh) and
[`fzf_git_keybindings.sh`](https://github.com/ibhagwan/dots/blob/master/.config/zsh/fzf_git_keybindings.zsh)
which add the below keybinds to the shell:

Use `ctrl-f` to open "live grep" with fzf (if available, in a tmux popup).

If the pwd is inside a git repo, the following binds are available:

| Key       | Command           | Key       | Command           |
| ----------| ------------------| ----------| ------------------|
| `<C-g-f>` | git ls-files      | `<C-g-s>` | git status        |
| `<C-g-b>` | git branches      | `<C-g-c>` | git commits       |
| `<C-g-g>` | git grep          | `<C-g-r>` | git remtoes       |
| `<C-g-t>` | git tags          |

And the same for the `yadm` dot files repo with `<C-y>` prefix:
| Key       | Command           | Key       | Command           |
| ----------| ------------------| ----------| ------------------|
| `<C-y-f>` | yadm ls-files     | `<C-y-s>` | yadm status       |
| `<C-y-b>` | yadm branches     | `<C-y-c>` | yadm commits      |
| `<C-y-g>` | yadm grep         | `<C-y-r>` | yadm remtoes      |
| `<C-y-t>` | yadm tags         |


### rEFInd

If you're looking for my rEFInd setup as shown
[here](https://www.reddit.com/r/unixporn/comments/ff0o8d/refind_which_kernel_are_you_feeling_like_today/):

**Note:** I've since installed Void Linux (side-by-side with the rest of the OS's), [`refind.conf`](https://github.com/ibhagwan/dots/blob/master/dots/refind/refind.conf) reflects the new setup.

![rEFInd](https://github.com/ibhagwan/dots/raw/master/dots/screenshots/rEFInd.png)
