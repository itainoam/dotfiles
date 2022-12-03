	#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprofile"
fi


# make aliases work with sudo
alias sudo='sudo '

# Aliases
alias g='git'
alias gs='git status -s'
alias ui-start='API_PROXY=ui-proxy SIMPLE_FORMATTER=true NO_TS_CHECK=true yarn run client:start'
alias codereview='/Users/itai/dev/codereview/codereview.sh'
alias gco='git co'
alias gadd='git add'
alias gitp='git push --dry-run --no-verify && git push'
alias gre='git reset'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


alias sub="cd ~/dev/acs-submittals"
alias bim="cd ~/dev/meetings-ui-web"
alias platform="cd ~/dev/acs-sc-web-platform"
alias edu="cd ~/edu"
#
# alias cj="jira view $(git branch | sed -n '/\* /s///p' | grep -oiE 'ui-[0-9]{4}')"
alias laptop-mount="sudo sshfs -o allow_other,defer_permissions,IdentityFile=/Users/itai/.ssh/id_rsa itai@10.0.17.71:/home/itai/dev /Users/itai/laptop"
alias laptop-ssh="ssh itai@10.0.17.71"
alias sharbot='slack-cli -d sharbot "allocate" && sleep 5 && slack-cli -d sharbot "super extend" && slack-cli -l 3 -s sharbot | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | cut -f 1 | xargs sudo python /Users/itai/dev/mui/tools/ui-proxy'
alias mui-sync="while sleep 2; do ls ~/dev/mui/js/client/dist | entr -d npm run deploy ui-proxy; done"
alias magit="emacs --no-window-system --eval '(progn (magit-status) (delete-other-windows))'"

alias ag='ag --path-to-ignore ~/.agignore'

# python config
alias python3='/usr/local/bin/python3.7'
alias pip3='/usr/local/bin/pip3.7'
export WORKON_HOME=~/Envs
VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3.7
source /usr/local/bin/virtualenvwrapper.sh
# workflows_service specific
export PYCURL_SSL_LIBRARY=openssl
export CPPFLAGS=-I/usr/local/opt/openssl/include
export LDFLAGS=-L/usr/local/opt/openssl/lib

## Helper functions
sharbot1() {
  slack-cli -d sharbot "allocate";
  sleep 5 && slack-cli -d sharbot "super extend";
  slack-cli -l 3 -s sharbot | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | cut -f 1 | xargs sudo python /Users/itai/dev/mui/tools/ui-proxy
}

fzf-down() {
  fzf --height 60% "$@" --border
}

codi() {
    local syntax="${1:-javascript}"
    shift
    vim -c \
        "let g:startify_disable_at_vimenter = 1 |\
        let g:codi#interpreters = { 'javascript': {'width': 70, 'rightalign':0},} |\
        set bt=nofile ls=0 noru nonu nornu |\
        hi ColorColumn ctermbg=NONE |\
        hi VertSplit ctermbg=NONE |\
        hi NonText ctermfg=0 |\
        Codi $syntax" "$@"
    }

branches()  {
  git branch --sort=-committerdate  | cut -c2- | fzf --height 40% --reverse --preview="echo {} | xargs -I % sh -c 'git log origin/develop..%'"
}

commits() {
    HASH=`git --no-pager log --pretty=format:'%h %<(20)%an %<(15)%cr %s' |\
      fzf-down --tiebreak=index --reverse |\
      awk 'END { if (NR==0)  exit 1; else print $1;}'` && echo $HASH 
  }

unstaged() {
    git ls-files --modified --others --exclude-standard | fzf  --height 50% --reverse -m --preview-window down:35 --bind "ctrl-n:preview-page-down,ctrl-p:preview-page-up,q:abort"\
 --preview="echo {}| cut -d ' ' -f3 | xargs -I % sh -c 'git diff --color % | diff-so-fancy'"
}

staged() {
     git diff --name-only --cached | fzf  --height 50% --reverse --preview-window down:35 --bind "ctrl-n:preview-page-down,ctrl-p:preview-page-up,q:abort"\
 --preview="echo {}| cut -d ' ' -f3 | xargs -I % sh -c 'git diff --staged --color % | diff-so-fancy'"
}

changed() {
     git status -s | fzf  --height 50%  --preview-window down:35 --ansi -m | cut -c 4- 
}

stashes() {
  git stash list | fzf  --height 50% --reverse -m --preview-window down:35 --preview="echo {} | cut -d ':' -f1 | xargs -I % sh -c 'git stash show -p %' | diff-so-fancy" | cut -d ":" -f1
}

printing_test () {
  # shows how printing to prompt can be done. can be used improve jiras by pasting branch name into terminal.
  JIRA=$(git branch | sed -n '/\* /s///p' | grep -oiE 'ui-[0-9]{4}'); print -z $JIRA;
  print -z asdf $JIRA;
  }

jiras() {
    BRANCH=$(jira list --query "resolution = unresolved and status = open and assignee=currentuser() ORDER BY cf[10007] ASC, created" |\
        fzf  --height 90% --reverse   \
        --header 'Press CTRL-X to copy, ENTER to browse' \
        --preview-window down:15 --preview="echo {}| cut -d : -f 1 |xargs -I % sh -c 'jira view %'" |\
        awk -F : '{print $1 "%" $2 }' |  tr -d ,.\' | tr -s " " | awk '{gsub(" ","-");print}' | awk '{gsub("%"," ");print}');
    echo ${BRANCH:0:8}${BRANCH:9} | awk '{print tolower($0)}'
      }


# not working yet as multi (-m) because git reset only accepts one file.
g-unstage() {
     git reset HEAD $(git diff --name-only --cached | fzf  --height 50% --reverse --preview-window down:60 --bind "ctrl-n:preview-page-down,ctrl-p:preview-page-up,q:abort"\
 --preview="echo {}| cut -d ' ' -f3 | xargs -I % sh -c 'git diff --staged --color % | diff-so-fancy'")
}

prs() {
    hub pr list -f "%sC%>(8)%I%Creset %t% l%n" | fzf --height 40% --reverse | awk '{print $1}' 
}

g-fixup() {
oldcommit=$(git --no-pager log --pretty=format:'%h %<(20)%an %<(15)%cr %s' |\
  fzf  --height 90% --reverse\
        --bind "ctrl-n:preview-page-down,ctrl-p:preview-page-up,q:abort"\
        --header 'Select which commit to add changes to. ctrl-n, ctrl-p to scroll diff. ' \
        --expect=enter \
        --preview-window down:25 --preview="git diff --color --staged | diff-so-fancy" |\
        awk '{print $1}') && [ ! -z "$oldcommit" ] && git commit --fixup=$oldcommit && git rebase --interactive --autosquash $oldcommit~
}

#add ** autocomplete to g-start
_fzf_complete_g-start() {
    ARGS="$@"
     
    local branches
    jiras=$(jiras)
    if [[ $ARGS == 'g-start'* ]]; then
        _fzf_complete "--reverse --multi" "$@" < <(
            echo $jiras
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

g-start() {
 # git fetch && git checkout master && git rebase --autostash && git checkout -b "itai/$1:u/$2" master && git branch --set-upstream-to "origin/master"; 

  SOURCE_BRANCH="develop"
  # workaround because main branch in meetings is develop
  REMOTE_URL=$(git config --get remote.origin.url)
  if [ "$REMOTE_URL" = "https://git.autodesk.com/BIM360/meetings-ui-web.git" ]; then
    SOURCE_BRANCH="develop"
  fi
  git fetch && git checkout $SOURCE_BRANCH && git rebase --autostash && git checkout -b "itai/SCPJM-$1" $SOURCE_BRANCH && git branch --set-upstream-to origin/$SOURCE_BRANCH && git push; 
}

g-finish() {
  BRANCH=$(git branch | sed -n '/\* /s///p' )
  JIRA=$(echo $BRANCH | grep -oiE 'SCPJM-[0-9]{5}');
  PR_MSG=$(echo ${JIRA} ${BRANCH:16} | tr "-" " " | awk '{print toupper(substr($0, 1, 1)) substr($0, 2)}' ) # removes dash and then capitlize first letter
  REMOTE_URL=$(git config --get remote.origin.url)
  
  # workaround because main branch in meetings is develop
  # # update 2021 - no longer needed
  # if [ "$REMOTE_URL" = "https://git.autodesk.com/BIM360/meetings-ui-web.git" ]; then
  #   UPSTREAM_BRANCH="origin/develop" # sometime previous pr msg is left, no need to use them..
  #   rm -f ~/dev/meetings-ui-web/.git/PULLREQ_EDITMSG
  # else
  #   UPSTREAM_BRANCH="origin/master"
  #   rm -f ~/dev/acs-meetings/.git/PULLREQ_EDITMSG
  # fi
  # jira transition --noedit 'Start Progress' $JIRA || true;
  # jira transition --noedit 'Ready for review' $JIRA || true;

  UPSTREAM_BRANCH="origin/develop"
  
  DIFF_LOG=$(git log --pretty=format:%s%n%n%b ${UPSTREAM_BRANCH}..);
  echo "${PR_MSG}\n\nresolves: ${JIRA}" |cat - ~/pr-template.md > /tmp/out && mv /tmp/out ~/pr-template-with-changes.md;
  git push && hub pull-request --push --browse -F - --edit < ~/pr-template-with-changes.md && git branch --set-upstream-to ${UPSTREAM_BRANCH}
}

. "$HOME/.cargo/env"
