# bfpimentel's dotfiles

## Introduction

This is a heavily opinionated and personal dotfiles repository.

It's intended to be fully reproducible, although I'm not ensuring anything.

An automated setup can be found below.

I do not offer any guarantees and I'm not responsible for any issues in each user's machines.

Diligence is needed:
1. Inspect the code in your own.
2. Do not run code you don't know what it is doing.

## Installation

To install, simply run:

```bash
wget -qO- https://raw.githubusercontent.com/bfpimentel/dotfiles/main/setup/install.sh | bash
```

Or:

1. Clone this repository.
2. `cd` to `setup`.
3. Make sure `init.sh` is executable.
4. Run `./init.sh`.

## Notice

If you came looking for the Nix configs, you can still find them [here](https://github.com/bfpimentel/dotfiles/tree/nix). 

I felt I didn't need Nix anymore, so I decided to move forward and downscale my setup.
