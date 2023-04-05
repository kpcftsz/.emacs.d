# KP's Emacs Config

![Screenshot](screenshot.png)

This is how I like to use Emacs. Everything's mostly stock but there's a few UX tweaks and language-specific things that make it more intuitive.

## Background

I started using Emacs a few years ago after growing frustrated with [JOE](https://joe-editor.sourceforge.io/)'s lack of extensibility. Having used that editor for years I found the transition to Emacs a little rough, so this config was made to ease the growing pains.

## Notable changes
- [Redo+](https://www.emacswiki.org/emacs/RedoPlus) used to replicate undo/redo behavior from JOE
- [MWIM](https://github.com/alezost/mwim.el) used to replicate traditional Home/End (or C-a/C-e) behavior from other editors
- [web-mode](https://web-mode.org/) added for better support for HTML, CSS, JS, PHP, etc.
- [emmet-mode](https://github.com/smihica/emmet-mode) added for quicker HTML editing
- `perl-mode` replaced with `cperl-mode` + Perl syntax highlighting fixes
- JOE navigation keybinds added
- Deleted text is no longer copied into the kill ring
- Emacs logo replaced w/ a cute Emacsified drawing of Reimu from [Touhou Project](https://en.touhouwiki.net/wiki/Touhou_Project)

## Installing and customizing

Just clone the repo from `~` (on a *nix) or `%APPDATA%` (on Windows) and you're all set.

The default theme is set to a custom one I've created w/ the font set to MS Gothic. If you want to change this look for the region labeled "Visual stuff" and adjust accordingly. If you want to change the startup logo you can also add/remove files via `images/` which Emacs randomly selects from.
