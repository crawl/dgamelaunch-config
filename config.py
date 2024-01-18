import logging
try:
    from collections import OrderedDict
except ImportError:
    from ordereddict import OrderedDict

dgl_mode = True

bind_nonsecure = True # Set to false to only use SSL
bind_address = ""
bind_port = 8080

# new_accounts_disabled = True
#new_accounts_hold = True
new_accounts_hold = False
allow_anon_spectate = False

hup_reloads_config = True
load_logging_rate = 30 # seconds, set to 0 to explicitly disable
slow_callback_alert = 0.25 # seconds, set to None to explicitly disable

lobby_url = "http://crawl.akrasiac.org:8080"

logging_config = {
    "filename": "%%CHROOT_WEBDIR%%/run/webtiles.log",
    "level": logging.INFO,
    "format": "%(asctime)s %(levelname)s: %(message)s"
}

enable_ttyrecs = False

password_db = "%%CHROOT_LOGIN_DB%%"

static_path = "%%CHROOT_WEBDIR%%/static"
template_path = "%%CHROOT_WEBDIR%%/templates/"

# Path for server-side unix sockets (to be used to communicate with crawl)
server_socket_path = None # Uses global temp dir

# Server name, so far only used in the ttyrec metadata
server_id = "cao"

# Disable caching of game data files
game_data_no_cache = False

# Watch socket dirs for games not started by the server
watch_socket_dirs = True

templates = dict(
    default = dict(
        name = "DCSS %v",
        show_save_info = True,
        allowed_with_hold = True,
        morgue_path = "%%CHROOT_MORGUEDIR%%/%n/",
        morgue_url = "http://crawl.akrasiac.org/rawdata/%n/",
        ttyrec_path = "%%CHROOT_TTYRECDIR%%/%n/",
        socket_path = "%%CHROOT_WEBDIR%%/sockets",
        ),
    trunk = dict(
        version = "trunk",
        crawl_binary = "/bin/crawl-git-launcher.sh",
        rcfile_path = "%%CHROOT_RCFILESDIR%%/crawl-git/",
        macro_path = "%%CHROOT_RCFILESDIR%%/crawl-git/",
        inprogress_path = "%%CHROOT_INPROGRESSDIR%%-crawl-git/",
        ),
    stable = dict(
        crawl_binary = "/bin/crawl-stable-launcher.sh",
        pre_options = [ "%v" ],
        rcfile_path = "%%CHROOT_RCFILESDIR%%/crawl-%v/",
        macro_path = "%%CHROOT_RCFILESDIR%%/crawl-%v/",
        morgue_path = "%%CHROOT_MORGUEDIR%%/%n/",
        morgue_url = "http://crawl.akrasiac.org/rawdata/%n/",
        inprogress_path = "%%CHROOT_INPROGRESSDIR%%-crawl%r/",
        ),
    stable_seeded = dict(
        template = "stable",
        name = "Seeded %v",
        inprogress_path = "%%CHROOT_INPROGRESSDIR%%-crawl%r-seeded/",
        options = ["-seed"],
        ),
    stable_sprint = dict(
        template = "stable",
        name = "Sprint %v",
        inprogress_path = "%%CHROOT_INPROGRESSDIR%%-crawl%r-sprint/",
        options = ["-sprint"],
        ),
    oldstable = dict(template = "stable", show_save_info = False, allowed_with_hold = False),
    oldstable_seeded = dict(template = "stable_seeded", show_save_info = False, allowed_with_hold = False),
    oldstable_sprint = dict(template = "stable_sprint", show_save_info = False, allowed_with_hold = False),

    olderstable = dict(template = "oldstable", send_json_options = False),
    olderstable_seeded = dict(template = "oldstable_seeded", send_json_options = False),
    olderstable_sprint = dict(template = "oldstable_sprint", send_json_options = False),

    zotdef = dict(
        template = "oldstable",
        name = "Zot Defence %v",
        send_json_options = False,
        options = ["-zotdef"]
        ),
    oldzotdef = dict(template = "zotdef", send_json_options = False),
    )

games = dict([
    ("dcss-git", dict(
        template = "trunk")),
    ("seeded-git", dict(
        template = "trunk",
        name = "Custom seed %v",
        inprogress_path = "%%CHROOT_INPROGRESSDIR%%-crawl-git-seeded/",
        options = ["-seed"])),
    ("descent-git", dict(
        template = "trunk",
        show_save_info = False, # buggy...
        name = "Descent (experimental)",
        inprogress_path = "%%CHROOT_INPROGRESSDIR%%-crawl-git-descent/",
        options = ["-descent"])),
    ("spr-git", dict(
        template = "trunk",
        name = "Sprint %v",
        inprogress_path = "%%CHROOT_INPROGRESSDIR%%-crawl-git-sprint/",
        options = ["-sprint"])),

    ("dcss-0.31", dict(
        template = "stable", version = "0.31",
        name = "DCSS %v (current release)")),
    ("seeded-0.31", dict(template = "stable_seeded", version = "0.31")),
    ("spr-0.31", dict(template = "stable_sprint", version = "0.31")),

    ("dcss-0.30", dict(
        template = "stable", version = "0.30",
        name = "DCSS %v (current release)")),
    ("seeded-0.30", dict(template = "stable_seeded", version = "0.30")),
    ("spr-0.30", dict(template = "stable_sprint", version = "0.30")),

    ("dcss-0.29", dict(template = "stable", version = "0.29")),
    ("seeded-0.29", dict(template = "stable_seeded", version = "0.29")),
    ("spr-0.29", dict(template = "stable_sprint", version = "0.29")),

    ("dcss-0.28", dict(template = "stable", version = "0.28")),
    ("seeded-0.28", dict(template = "stable_seeded", version = "0.28")),
    ("spr-0.28", dict(template = "stable_sprint", version = "0.28")),

    ("dcss-0.27", dict(template = "stable", version = "0.27")),
    ("seeded-0.27", dict(template = "stable_seeded", version = "0.27")),
    ("spr-0.27", dict(template = "stable_sprint", version = "0.27")),

    ("dcss-0.26", dict(template = "stable", version = "0.26")),
    ("seeded-0.26", dict(template = "stable_seeded", version = "0.26")),
    ("spr-0.26", dict(template = "stable_sprint", version = "0.26")),

    ("dcss-0.25", dict(template = "stable", version = "0.25")),
    ("seeded-0.25", dict(template = "stable_seeded", version = "0.25")),
    ("spr-0.25", dict(template = "stable_sprint", version = "0.25")),

    ("dcss-0.24", dict(template = "oldstable", version = "0.24")),
    ("seeded-0.24", dict(template = "oldstable_seeded", version = "0.24")),
    ("spr-0.24", dict(template = "oldstable_sprint", version = "0.24")),

    ("dcss-0.23", dict(template = "oldstable", version = "0.23")),
    ("spr-0.23", dict(template = "oldstable_sprint", version = "0.23")),

    ("dcss-0.22", dict(template = "oldstable", version = "0.22")),
    ("spr-0.22", dict(template = "oldstable_sprint", version = "0.22")),

    ("dcss-0.21", dict(template = "oldstable", version = "0.21")),
    ("spr-0.21", dict(template = "oldstable_sprint", version = "0.21")),

    ("dcss-0.20", dict(template = "oldstable", version = "0.20")),
    ("spr-0.20", dict(template = "oldstable_sprint", version = "0.20")),

    ("dcss-0.19", dict(template = "oldstable", version = "0.19")),
    ("spr-0.19", dict(template = "oldstable_sprint", version = "0.19")),

    ("dcss-0.18", dict(template = "oldstable", version = "0.18")),
    ("spr-0.18", dict(template = "oldstable_sprint", version = "0.18")),

    ("dcss-0.17", dict(template = "oldstable", version = "0.17")),
    ("spr-0.17", dict(template = "oldstable_sprint", version = "0.17")),

    ("dcss-0.16", dict(template = "oldstable", version = "0.16")),
    ("spr-0.16", dict(template = "oldstable_sprint", version = "0.16")),

    ("dcss-0.15", dict(template = "oldstable", version = "0.15")),
    ("spr-0.15", dict(template = "oldstable_sprint", version = "0.15")),
    ("zd-0.15", dict(template = "zotdef", version = "0.15")),

    ("dcss-0.14", dict(template = "oldstable", version = "0.14")),
    ("spr-0.14", dict(template = "oldstable_sprint", version = "0.14")),
    ("zd-0.14", dict(template = "zotdef", version = "0.14")),

    ("dcss-0.13", dict(template = "olderstable", version = "0.13")),
    ("spr-0.13", dict(template = "olderstable_sprint", version = "0.13")),
    ("zd-0.13", dict(template = "oldzotdef", version = "0.13")),

    ("dcss-0.12", dict(template = "olderstable", version = "0.12")),
    ("spr-0.12", dict(template = "olderstable_sprint", version = "0.12")),
    ("zd-0.12", dict(template = "oldzotdef", version = "0.12")),

    ("dcss-0.11", dict(template = "olderstable", version = "0.11")),
    ("spr-0.11", dict(template = "olderstable_sprint", version = "0.11")),
    ("zd-0.11", dict(template = "oldzotdef", version = "0.11")),
    ])

#dgl_status_file = "%%CHROOT_WEBDIR%%/run/status"
dgl_status_file = "%%DGL_CHROOT%%/dgl-shared/status"

# Set to None not to read milestones
milestone_file = [
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.10/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.10/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.10/saves/milestones-zotdef",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.11/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.11/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.11/saves/milestones-zotdef",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.12/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.12/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.12/saves/milestones-zotdef",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.13/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.13/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.13/saves/milestones-zotdef",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.14/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.14/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.14/saves/milestones-zotdef",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.15/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.15/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.15/saves/milestones-zotdef",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.16/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.16/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.17/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.17/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.18/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.18/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.19/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.19/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.20/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.20/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.21/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.21/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.22/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.22/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.23/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.23/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.24/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.24/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.25/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.25/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.26/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.26/saves/milestones-sprint",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.27/saves/milestones",
    "%%CHROOT_CRAWL_BASEDIR%%/crawl-0.27/saves/milestones-sprint",
    "%%CHROOT_CRAWL_GAMEDIR%%/saves/milestones",
    "%%CHROOT_CRAWL_GAMEDIR%%/saves/milestones-sprint"
]

status_file_update_rate = 30

recording_term_size = (80, 24)

max_connections = 200

# Script to initialize a user, e.g. make sure the paths
# and the rc file exist. This is not done by the server
# at the moment.
init_player_program = "/bin/init-webtiles.sh"

ssl_options = None # No SSL
# ssl_options = {
#     "certfile": "/etc/ssl/private/s-z.org.crt",
#     "keyfile": "/etc/ssl/private/s-z.org.key",
#     "ca_certs": "/etc/ssl/private/sub.class1.server.ca.pem"
# }
# ssl_address = ""
# ssl_port = 8443

connection_timeout = 600
max_idle_time = 5 * 60 * 60

# Seconds until stale HTTP connections are closed
# This needs a patch currently not in mainline tornado.
http_connection_timeout = 600

kill_timeout = 15 # Seconds until crawl is killed after HUP is sent

nick_regex = r"^[a-zA-Z0-9]{3,20}$"
max_passwd_length = 20

# crypt() algorithm, e.g. "1" for MD5 or "6" for SHA-512; see crypt(3).
# If false, use traditional DES (but then only the first eight characters
# are significant).
crypt_algorithm = "6"
# If crypt_algorithm is true, the length of the salt string to use. If
# crypt_algorithm is false, a two-character salt is used.
crypt_salt_length = 16

login_token_lifetime = 7 # Days

uid = int("%%DGL_UID%%")  # If this is not None, the server will setuid to that (numeric) id
gid = int("%%DGL_GID%%")  # after binding its sockets.

umask = None # e.g. 0077

chroot = "%%DGL_CHROOT%%"

pidfile = "%%CHROOT_WEBDIR%%/run/webtiles.pid"
daemon = True # If true, the server will detach from the session after startup

player_url = "http://crawl.akrasiac.org/scoring/players/%s.html"
