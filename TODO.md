# TODOs for Ben

I haven't done any research into any of these ideas. These the ideas might already implemented in the project.

## ~/.config/ml4w/cache/ moved to ~/.cache/ml4w

**Background**: ML4W currently caches local information in a directory located at `~/.config/ml4w/cache`. If the installed dotfiles directory is within a Git-tracked repository, the local cache files inadvertently become part of the version control.

**Current Workaround**: Users must manually add an entry for the cache directory in their `.gitignore` file to prevent this.

**Proposal**: To improve the situation, I propose moving the local cache directory to `~/.cache/ml4w`. This change offers several advantages:

- Separation from Version Control: By relocating the cache, local cache files will no longer be tracked by Git.
- Simplification: Users will no longer need to modify their .gitignore to exclude cache files.
- Compliance with Standards: This adjustment aligns better with the XDG Base Directory Specification, promoting standardized file organization.

Implementing this change will enhance usability and adhere to established best practices for directory structure.

## BYO Dotfiles

**Proposal**: During the installation process of ML4W, prompt the user to enter a Git repository URL for their own dotfiles. If the user provides a URL, attempt to clone the repository and use those dotfiles. If no URL is provided, the installation will proceed with the default dotfiles.

**Implementation Steps**:

1. Prompt the user with:

```
```sh
    Dotfiles repository URL (press Enter for default, or ? for more info): _
```

2. If the user inputs a URL:

- Clone the repository.
- Use the files from the repository to create symlinks in the home directory.

3. If the input is left blank, use the default dotfiles directory.

4. If the input is `?`, describe what this is, and to use default if the user is unsure what to put.

This change allows users to customize their dotfiles while keeping the installation process straightforward.

### Ideas

#### Dotfiles initialization hook

We don't know everything the user could include in their dotfiles repository. We can populate out the symlinks for the XDG base directories that are included in the install script. But let's say the user has all sorts of other directories they need simlink'd. For example, they could include a `ml4w\installHook.sh` and make it executable. The user could populate this file to their own needs. Say they have some documentation they'd like to keep in their dotfiles repository, and would like their `/path/to/dotfiles/documents/` folder to be symlink'd to `$HOME/documents`, or `$XDG_DATA_DIR/documents`.

We check if that file exists in the cloned repo, and execute it.

#### Input validation

Basic input validation. Can `git` contact the URL? If not, then what? Show prompt again, and repeat until they either provide a clone-able repository, or enter no input and proceed with the default.
