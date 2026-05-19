# ~/.zshrc

# Enable Starship prompt
eval "$(starship init zsh)"
# Enable rustup
export PATH="$HOME/.cargo/bin:$PATH"

# Better history behavior
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Useful options
setopt autocd
setopt histignorealldups
setopt sharehistory

# Completion system
autoload -Uz compinit
compinit

# Better ls colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Editor
export EDITOR=vim

#Here for Aliases
#alias v='nvim'
alias v='vim'

alias gcc_unsafe='gcc -fno-stack-protector \
        -U_FORTIFY_SOURCE -D _FORTIFY_SOURCE=0 \
        -fno-sanitize=all \
        -funroll-loops \
        -march=native \
        -fdelete-null-pointer-checks \
        -fstrict-overflow -Ofast \
        -fno-wrapv \
        -s \
  -flto -fomit-frame-pointer \
  -fno-asynchronous-unwind-tables -fno-ident \
  -fno-math-errno'

alias gcc_fast='gcc -fno-stack-protector -std=c17\
    -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0 \
    -fno-sanitize=all \
    -funroll-loops \
    -march=native \
    -mtune=native \
    -fno-delete-null-pointer-checks \
    -fstrict-overflow -Ofast \
    -fno-wrapv \
    -s \
    -flto \
    -fomit-frame-pointer \
    -fno-asynchronous-unwind-tables \
    -fno-ident \
    -fno-math-errno \
    -fno-exceptions\
    -fno-stack-check \
    -fdelete-null-pointer-checks \
    -ffast-math \
    -fopt-info-vec \
    -fvect-cost-model=dynamic \
    -fno-common \
    -fipa-pta \
    -fgcse-after-reload \
    -fprefetch-loop-arrays \
    -fno-verbose-asm \
    -Ofast'


alias gcc_safe='gcc -std=c17 -Wall -Wextra -Wpedantic -Werror \
    -Wconversion -Wshadow -Wpointer-arith -Wcast-align \
    -Wstrict-overflow=5 -Wfloat-equal -Wundef -Wwrite-strings \
    -Wmissing-prototypes -Wswitch-enum \
    -Wformat=2 -Wnull-dereference -Wduplicated-cond -Wlogical-op \
    -fsanitize=address,undefined,leak \
    -D_FORTIFY_SOURCE=2 -g3 -pedantic-errors \
    -fPIE -pie -Wl,-z,relro,-z,now \
    -fsanitize=bounds-strict -fstack-clash-protection \
    -fno-omit-frame-pointer \
    -fstack-protector-strong -fno-common -O2'

alias clang_safe='clang -std=c17 -Wall -Wextra -Wpedantic -Werror \
    -Wconversion -Wshadow -Wpointer-arith -Wcast-align \
    -Wfloat-equal -Wundef -Wwrite-strings \
    -Wmissing-prototypes -Wswitch-enum \
    -Wformat=2 -Wnull-dereference \
    -fsanitize=address,undefined,leak \
    -D_FORTIFY_SOURCE=2 -g3 -pedantic-errors \
    -Wfloat-conversion -Wcast-function-type \
    -fPIE -pie -Wl,-z,relro,-z,now \
    -fstack-clash-protection \
    -fno-omit-frame-pointer \
    -fstack-protector-strong -fno-common -Og'

alias clang_compile_safe='clang -std=c17 -Wall -Wextra -Wpedantic -Werror \
    -Wconversion -Wshadow -Wpointer-arith -Wcast-align \
    -Wfloat-equal -Wundef -Wwrite-strings \
    -Wmissing-prototypes -Wswitch-enum \
    -Wformat=2 -Wnull-dereference \
    -fsanitize=address,undefined,leak \
    -D_FORTIFY_SOURCE=2 -g3 -pedantic-errors \
    -Wfloat-conversion -Wcast-function-type \
    -fstack-clash-protection \
    -fno-omit-frame-pointer \
    -fstack-protector-strong -fno-common -O2'



alias gpp_safe='g++ -std=c++20 \
    -Wall -Wextra -Wpedantic -Werror \
    -Wconversion -Wshadow -Wpointer-arith -Wcast-align  \
    -Wstrict-overflow=5 -Wfloat-equal -Wundef -Wwrite-strings  \
    -Wswitch-enum -Wformat=2 -Wnull-dereference \
    -Wduplicated-cond -Wlogical-op \
    -Wnon-virtual-dtor -Wold-style-cast \
    -Woverloaded-virtual -Wsuggest-override \
    -fsanitize=address,undefined,leak -fno-omit-frame-pointer  \
    -fstack-protector-strong -fno-common -O2'

alias gcc_prod='gcc -std=c17 -Wall -Wextra -Wpedantic -Werror \
    -Wconversion -Wshadow -Wpointer-arith -Wcast-align \
    -Wstrict-overflow=5 -Wfloat-equal -Wundef -Wwrite-strings \
    -Wmissing-prototypes -Wswitch-enum -Wformat=2 -Wnull-dereference \
    -D_FORTIFY_SOURCE=2 \
    \
    -flto -march=native -mtune=native -funroll-loops \
    -fno-math-errno -ffast-math \
    \
    -fstack-protector-strong -fPIE -pie -Wl,-z,relro,-z,now \
    -s -fno-verbose-asm -fno-ident \
    -O3'
                #we can also use -Ofast, but eh
    alias gcc_quick_prod='gcc -std=c17 \
    -Wall -Wextra -Wpedantic \
    -Wconversion -Wshadow -Wpointer-arith -Wcast-align \
    -Wstrict-overflow=5 -Wfloat-equal -Wundef -Wwrite-strings \
    -Wmissing-prototypes -Wswitch-enum -Wformat=2 -Wnull-dereference \
    -D_FORTIFY_SOURCE=2 \
    \
    -flto -march=native -mtune=native -funroll-loops \
    -fno-math-errno -ffast-math \
    \
    -fstack-protector-strong -fPIE -pie -Wl,-z,relro,-z,now \
    -s -fno-verbose-asm -fno-ident \
    -O3'
    alias clang_prod='clang -std=c17 -Wall -Wextra -Wpedantic -Werror \
    -Wconversion -Wshadow -Wpointer-arith -Wcast-align \
    -Wstrict-overflow -Wfloat-equal -Wundef -Wwrite-strings \
    -Wmissing-prototypes -Wswitch-enum -Wformat=2 -Wnull-dereference \
    -Wfloat-conversion -Wcast-function-type \
    -D_FORTIFY_SOURCE=2 \
    \
    -flto -march=native -mtune=native -funroll-loops \
    -fno-math-errno -ffast-math \
    \
    -fstack-protector-strong -fPIE -pie -Wl,-z,relro,-z,now \
    -s -fno-verbose-asm -fno-ident \
                -O3'

#zsh stuff
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#Add the line below to *the end of* your .zshrc to enable highlighting.
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
