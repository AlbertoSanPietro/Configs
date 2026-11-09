## Vi config
* This uses the old Vi Unix editor, found at: https://github.com/n-t-roff/heirloom-ex-vi
* Append the lines of bash code below for the old school terminal feeling
### Code
```
# Classic CRT colors for Heirloom vi
vi() (
        # Restore terminal colors whenever vi exits
                trap 'printf "\e[0m\e]110\a\e]111\a\e]112\a"' EXIT

                        # Green text, black background, green cursor
                                printf '\e]10;#66FF66\a'
                                        printf '\e]11;#000000\a'
                                                printf '\e]12;#66FF66\a'

                                                        # Launch the real vi, preserving arguments
                                                                command vi "$@"
                                                                )

```
