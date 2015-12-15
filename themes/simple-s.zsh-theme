################################################################
# simple-s Theme
# https://github.com/raffitz/simple-s
#
# This theme was based on lfiolhais's Theme:
# https://github.com/lfiolhais/theme-simple-ass-prompt
# And on Mathias Bynens's Theme:
# https://github.com/mathiasbynens/dotfiles
# And on Nicolas Gallagher's Theme:
# https://github.com/necolas/dotfiles
################################################################

# Symbols are:
#	✓	
#	!	
#	☡	
#	↩	

function prompt_git {
	local s="";
	local branchName=$(git symbolic-ref --quiet --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null || echo '(unknown)');
	
	
	# Check if the current directory is in a Git repository.
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then

		git update-index --really-refresh -q &>/dev/null;

		# Check for uncommitted changes in the index.
		if ! $(git diff --quiet --ignore-submodules --cached); then
			s+='✓';
		fi;

		# Check for unstaged changes.
		if ! $(git diff-files --quiet --ignore-submodules --); then
			s+='!';
		fi;

		# Check for untracked files.
		if [ -n "$(git ls-files --others --exclude-standard)" ]; then
			s+='☡';
		fi;

		# Check for stashed files.
		if $(git rev-parse --verify refs/stash &>/dev/null); then
			s+='↩';
		fi;

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	fi;
}

# Following function blatantly plagiarised from https://github.com/sorin-ionescu/prezto/
# Original author is https://github.com/lunaryorn
function prompt_sorin_pwd {
	autoload -U regexp-replace

	local abbreviated
	local head

	abbreviated="${PWD/#${HOME}/~}"
	head="${abbreviated:h}"
	regexp-replace head '/[^/]*' '/${MATCH:1:1}'
	_prompt_sorin_pwd="${head}/${abbreviated:t}"
  
	echo $_prompt_sorin_pwd
}
# End of blatant plagiarising

autoload -U colors && colors

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="%{$FG[001]%}";
else
	userStyle="%{$FG[009]%}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="%{$FG[001]%}%B";
	hostEnd="%b";
else
	hostStyle="%{$FG[003]%}";
	hostEnd="";
fi;

# Set the terminal title to the current working directory.
PROMPT="${userStyle}%n"; # username
PROMPT+="%{$FG[014]%} at ";
PROMPT+="${hostStyle}%m${hostEnd}"; # host
PROMPT+="%{$FG[014]%} in ";
PROMPT+="%{$FG[002]%}\$(prompt_sorin_pwd)"; # working directory
PROMPT+="\$(prompt_git \"%{$FG[014]%} on %{$FG[013]%}\" \"%{$FG[004]%}\")"; # Git repository details
PROMPT+=$'\n'
PROMPT+="%{$FG[014]%}%B↪%b %{$reset_color%}"; # `$` (and reset color)

RPROMPT=""
#RPROMPT="%{$FG_bold[yellow]%} %{$reset_color%}";
