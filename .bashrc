eval "$(/opt/homebrew/bin/brew shellenv)"

# Move native PATHs to the back
#  (Workaroung for VS-Code Terminal
#   to avoid it putting '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
#   in front thus breaking Brew setup)
while read bin_dir; do
	if [[ ":${PATH}:" == *":${bin_dir}:"* ]]; then
		PATH=${PATH//":${bin_dir}:"/":"} # delete any instances in the middle
		PATH=${PATH/#"${bin_dir}:"/} # delete any instance at the beginning
		PATH=${PATH/%":${bin_dir}"/} # delete any instance in the at the end
		export PATH=${PATH}:${bin_dir}
	fi
done < /etc/paths

# Add a tool in PATH and MANPATH
addtool() {
	curr_dir="$1"
	if [ ! -d ${curr_dir} ]; then
		echo "[addtool] Given directory doesn't exit: ${curr_dir}"
		return 1
	fi

	bin_dir="${curr_dir}/bin"
	if [ ! -d ${bin_dir} ]; then
		# Try with gnubin
		bin_dir="${curr_dir}/gnubin"
	fi
	if [ -d ${bin_dir} ] && [[ ":${PATH}:" != *":${bin_dir}:"* ]]; then
		export PATH=${bin_dir}${PATH+:${PATH}}
	fi

	man_dir="${curr_dir}/man"
	if [ ! -d ${man_dir} ]; then
		# Try with gnuman
		man_dir="${curr_dir}/gnuman"
	fi
	if [ -d ${man_dir} ] && [[ ":${MANPATH}:" != *":${man_dir}:"* ]]; then
		export MANPATH=${man_dir}${MANPATH+:${MANPATH}}
	fi
}

# Add brew installed packages if needed
for dir in `find ${HOMEBREW_PREFIX}/opt -type l`
do
    # Keep only those with libexec
    curr_dir=${dir}/libexec
    if [ -d ${curr_dir} ]; then
	addtool "${curr_dir}"
    fi
done

# Cargo
# addtool "${HOME}/.cargo"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_ROOT_PREFIX="${HOME}/mamba";
export MAMBA_EXE="${MAMBA_ROOT_PREFIX}/bin/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Direnv
eval "$(direnv hook bash)"

# Locale
export LC_ALL="en_US.UTF-8"

# History
export HISTSIZE=1000
export HISTFILESIZE=2000

# If this is a non interactive shell
if [ -z "$PS1" ]; then
   return
fi

# Custom Prompt
# conda config --set changeps1 False
customPrompt="$(echo '(${CONDA_PREFIX:-system})')➜ \[\033[31m\]\u\[\033[39m\]@\[\033[34m\]\h\[\033[39m\][\W]$ "
PS1="${customPrompt}"
