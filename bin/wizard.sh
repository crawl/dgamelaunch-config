#! /bin/bash

help <<EOF

$SCRIPT_NAME: Manages dgamelaunch wizard users.

Usage: $SCRIPT_NAME ls           List wizard users
       $SCRIPT_NAME add <user>   Make <user> a wizard
       $SCRIPT_NAME rm <user>    Make <user> a non-wizard user.

EOF

assert-login-db-exists

SUBCOMMAND=$1
shift
[[ -z "$SUBCOMMAND" ]] && SUBCOMMAND="ls"

wizard-ls() {
    echo "Existing wizard users:"
    login-query <<EOF
SELECT username, email FROM dglusers
WHERE (flags & 32) = 32
ORDER BY username;
EOF
}


dgl-user-make-wizard() {
    local user="$1"
    login-query <<EOF
UPDATE dglusers
SET flags = flags | 32
WHERE username='$user';
EOF
}

dgl-user-unmake-wizard() {
    local user="$1"
    login-query <<EOF
UPDATE dglusers
SET flags = flags & ~32
WHERE username='$user';
EOF
}


wizard-add() {
    local new_wizard="$1"
    dgl-user-exists "$new_wizard" || \
        abort-saying "Cannot find user $new_wizard in dgl login db."
    if dgl-user-is-wizard "$new_wizard"; then
        echo "User $new_wizard is already an wizard."
        exit 0
    fi

    assert-running-as-root
    dgl-user-make-wizard "$new_wizard"

    if dgl-user-is-wizard "$new_wizard"; then
        printf 'Done, %s is now a DGL wizard.\n' "$new_wizard"
        exit 0
    else
        echo "Oops, couldn't make $new_wizard a DGL wizard."
        exit 1
    fi
}

wizard-rm() {
    local ex_wizard="$1"
    dgl-user-exists "$ex_wizard" || \
        abort-saying "Cannot find user $ex_wizard in dgl login db."
    if ! dgl-user-is-wizard "$ex_wizard"; then
        echo "User $ex_wizard is not an wizard, nothing to do."
        exit 0
    fi

    assert-running-as-root
    dgl-user-unmake-wizard "$ex_wizard"

    if ! dgl-user-is-wizard "$ex_wizard"; then
        printf 'Done, %s is now a regular DGL non-wizard user.\n' "$ex_wizard"
        exit 0
    else
        echo -e "Oops, couldn't make $ex_wizard a regular DGL non-wizard user."
        exit 1
    fi
}

case $SUBCOMMAND in
    ls) wizard-ls "$@" ;;
    add) each-do wizard-add "$@" ;;
    rm) each-do wizard-rm "$@" ;;
    *) abort-saying "Unknown usage: $SCRIPT_NAME $SUBCOMMAND"
esac
