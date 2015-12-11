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

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
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

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${orange}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${yellow}";
fi;

# Set the terminal title to the current working directory.
PROMPT="${userStyle}%n"; # username
PROMPT+="${white} at ";
PROMPT+="${hostStyle}%m"; # host
PROMPT+="${white} in ";
PROMPT+="${green}%~"; # working directory
PROMPT+="\$(prompt_git \"${white} on ${purple}\" \"${blue}\")"; # Git repository details
PROMPT+="\n";
PROMPT+="${white}\$ ${reset}"; # `$` (and reset color)

RPROMPT="${yellow}→ ${reset}";
export PS2;
