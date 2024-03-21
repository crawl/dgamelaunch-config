#! /bin/bash

help <<EOF

$SCRIPT_NAME: Manages dgamelaunch bot users.

Usage: $SCRIPT_NAME ls           List bot users
       $SCRIPT_NAME add <user>   Make <user> a bot
       $SCRIPT_NAME rm <user>    Make <user> a non-bot user.

EOF

assert-login-db-exists

SUBCOMMAND=$1
shift
[[ -z "$SUBCOMMAND" ]] && SUBCOMMAND="ls"

bot-ls() {
    echo "Existing bot users:"
    login-query <<EOF
SELECT username, email FROM dglusers
WHERE (flags & 64) = 64
ORDER BY username;
EOF
}


dgl-user-make-bot() {
    local user="$1"
    login-query <<EOF
UPDATE dglusers
SET flags = flags | 64
WHERE username='$user';
EOF
}

dgl-user-unmake-bot() {
    local user="$1"
    login-query <<EOF
UPDATE dglusers
SET flags = flags & ~64
WHERE username='$user';
EOF
}


bot-add() {
    local new_bot="$1"
    dgl-user-exists "$new_bot" || \
        abort-saying "Cannot find user $new_bot in dgl login db."
    if dgl-user-is-bot "$new_bot"; then
        echo "User $new_bot is already an bot."
        exit 0
    fi

    assert-running-as-root
    dgl-user-make-bot "$new_bot"

    if dgl-user-is-bot "$new_bot"; then
        printf 'Done, %s is now a DGL bot.\n' "$new_bot"
        exit 0
    else
        echo "Oops, couldn't make $new_bot a DGL bot."
        exit 1
    fi
}

bot-rm() {
    local ex_bot="$1"
    dgl-user-exists "$ex_bot" || \
        abort-saying "Cannot find user $ex_bot in dgl login db."
    if ! dgl-user-is-bot "$ex_bot"; then
        echo "User $ex_bot is not an bot, nothing to do."
        exit 0
    fi

    assert-running-as-root
    dgl-user-unmake-bot "$ex_bot"

    if ! dgl-user-is-bot "$ex_bot"; then
        printf 'Done, %s is now a regular DGL non-bot user.\n' "$ex_bot"
        exit 0
    else
        echo -e "Oops, couldn't make $ex_bot a regular DGL non-bot user."
        exit 1
    fi
}

case $SUBCOMMAND in
    ls) bot-ls "$@" ;;
    add) each-do bot-add "$@" ;;
    rm) each-do bot-rm "$@" ;;
    *) abort-saying "Unknown usage: $SCRIPT_NAME $SUBCOMMAND"
esac
