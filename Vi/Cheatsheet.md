## This cheatsheet is based off of: Learning the Vi and Vim editors, 8th edition

### These may or may not be used, they are extemporaneous
* The \\Vi symbol indicates I have been using Vi to edit
* The \\Vim symbol is for when I switch to Vim
* the \\Nvim symbol is for Neovim

* To abandon changes:
`:e!`

* To suspend and enter shell:
<C-z>

* Opening a new shell:
`:sh`

* To go at beginning of a line:
`0`

* To go at the end of a line:
`$`

* Move backwards or forwards by one alphanumerical word:
`b` or `w`

* Move backwards or forwards by one whitespace-separated word:
`B` or `W`

* Delete until the end of a word, preserving backspace:
`de`

* Delete a non bwhitespace separated word:
```
dW

This doesn't compute
This compute

```
* Delete a line and enter insert mode:
`cc`, `S`, `c$`

* Delete all to the right:
`D`

* Delete char at cursor and substitute text:
`s`

* Delete line and substitute text:
`S`

* Substitute starting from the cursor:
`R`

* Change capitalisation:
`~`

This is a line









