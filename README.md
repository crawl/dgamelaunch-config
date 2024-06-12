# dcss-server

> This [README.md](README.md) is based on the automatically translated [README.ko.md](README.ko.md) via ChatGPT.

This script is designed to simplify the deployment and management of a Dungeon Crawl Stone Soup server, allowing for easy setup and maintenance. It supports as many fork versions (DCSS CA, HellCrawl, GnollCrawl, BloatCrawl2, GoonCrawl, X-Crawl, StoatSoup, KimchiCrawl, BcadrenCrawl) and official release versions (0.11 ~ 0.31) as possible in a latest Ubuntu image environment.

### First Run Guide:
#### Prerequisites
* Docker (with Docker Compose)

#### Fast Deploy
```bash
git clone https://github.com/refracta/dcss-server
cd dcss-server/server

# Download pre-built game binaries and configurations
docker compose run --rm -e CMD='$SCRIPTS/utils/release.sh download -o -p data -n game-data' dcss-server
# Run with random ports
docker compose up -d && docker compose logs -f
# Run with specified ports
docker compose -f docker-compose.yml -f docker-compose.ports.yml up -d && docker compose logs -f
```

#### Deploy with Build
```bash
git clone https://github.com/refracta/dcss-server
cd dcss-server/server

# If you need to build without downloading the image from Docker Hub, you can use the following command.
docker compose build

# This command is optional. You can download ccache files to speed up the compilation process.
# Without it, the full build takes over 6 hours based on the ubuntu-24.04 image of the GitHub Action Runner. With it, the build time is reduced to about 45 minutes.
docker compose run --rm -e CMD='$SCRIPTS/utils/release.sh download -p /data/ccache -n ccache' dcss-server

# USE_DWEM: Apply https://github.com/refracta/dcss-webtiles-extension-module.
# USE_REVERSE_PROXY: Apply a patch to log the X-Forwarded-For IP.
# CMD: Can be used to run scripts inside the container.
# "$SCRIPTS/game/install-crawl-versions.sh"=Build all crawl versions, "$SCRIPTS/game/install-trunk.sh"=Build only the trunk version, ""=Run the server immediately without building (if existing build data is present).
docker compose run --rm -e CMD='$SCRIPTS/game/install-crawl-versions.sh' dcss-server
USE_DWEM=true USE_REVERSE_PROXY=true docker compose up -d && docker compose logs -f
```

#### Notes
 - All server data is stored in `server/data/{config,versionsdb,crawl-master,dgldir,games}`.
 - The `config` folder is created by cloning the contents of this repository at the image build time. If you pre-set this folder with the contents of this repository (or a modified fork), the container will use those contents for configuration. You can modify the scripts in [server/scripts](server/scripts) to change the server settings.
 - The `versiondb` folder stores the database files containing the version information of the built games.
 - The `crawl-master` folder stores game settings, Milestones, Morgue, etc.
 - The `dgldir` folder stores data used by `dgamelaunch`.
 - The `games` folder stores the built game binaries.
 - You can access the crawl webtiles on port `8080`, game logs on ports `8081 (Apache)` and `8082 (Nginx)`. SSH access is available on port 2222 (using `nemelex:xobeh` or the [CAO key](https://crawl.develz.org/cao_key)).
 - You can use [trigger-rebuild.pl](utils/trigger-rebuild.pl) and [auth-save-downloader.pl](utils/auth-save-downloader.pl). (Refer to: [apache.conf](server/scripts/web/conf/apache.conf), [nginx.conf](server/scripts/web/conf/nginx-default.conf))
 - Trunk and some fork builds are executed every 15 minutes. (Refer to: [setup-cron.sh](server/scripts/game/setup-cron.sh))
 - You can fork this repository to manage personalized build configurations as releases. (Refer to: [release.sh](server/scripts/utils/release.sh), [upload-data.yml](.github/workflows/upload-data.yml))

### Repository Management
* This repository is used for operating crawl.nemelex.cards.
* If you need to add a new fork or version, you can request it via a Pull-Request.

### Upstream Projects
* https://github.com/crawl/dgamelaunch-config
* Scripts necessary for operating a Dungeon Crawl Stone Soup server. The `utils/testing-container` contains a container environment configuration created for CI/CD verification tasks of Crawl.

* https://github.com/Rytisgit/dgamelaunch-dcss-forks-server
* This project is based on dgamelaunch-config and is designed to easily configure multiple forks in a containerized environment. *This project was started based on this project.*

### Thanks to

Thanks to the many developers in the `#crawl-dev` IRC channel, the implementation goals of this project were successfully achieved. 
Special thanks to [gammafunk](https://github.com/gammafunk) for his help with server setup, and to [Sentei](https://github.com/Rytisgit), the developer of [DCSSReplay](https://github.com/Rytisgit/dcssreplay) and maintainer of [dgamelaunch-dcss-forks-server](https://github.com/Rytisgit/dgamelaunch-dcss-forks-server), for monitoring the server setup process and providing invaluable advice and issue resolution.