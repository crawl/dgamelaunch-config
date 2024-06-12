# dcss-server

> This [README.md](README.md) is based on the automatically translated [README.ko.md](README.ko.md) via ChatGPT.

This script is designed to simplify the deployment and management of a Dungeon Crawl Stone Soup server. It supports the latest Ubuntu image environment and includes as many fork versions (DCSS CA, HellCrawl, GnollCrawl, BloatCrawl2, GoonCrawl, X-Crawl, StoatSoup, KimchiCrawl, BcadrenCrawl) and official release versions (0.11 ~ 0.31) as possible.

### First Run Guide:
#### Prerequisites
* Docker (with Docker Compose)

#### Fast Deploy
```bash
git clone https://github.com/refracta/dcss-server
cd dcss-server/server

# Download pre-built game binaries and configurations
CMD='$SCRIPTS/utils/release.sh download -o -p data -n game-data' docker compose up && docker compose down 
# Run with random ports
docker compose up -d && docker compose logs -f
# Run on specified ports
docker compose -f docker-compose.yml -f docker-compose.ports.yml up -d && docker compose logs -f
```

#### Deploy with Build
```bash
git clone https://github.com/refracta/dcss-server
cd dcss-server/server

# This command is optional; you can download ccache files to speed up compilation.
# Without it, the full build takes over 6 hours on the GitHub Action Runner's ubuntu-24.04 image, but with it, it speeds up to about 45 minutes.
CMD='$SCRIPTS/utils/release.sh download -p /data/ccache -n ccache' docker compose up && docker compose down

# USE_DWEM: Apply https://github.com/refracta/dcss-webtiles-extension-module.
# USE_REVERSE_PROXY: Apply a patch to log the X-Forwarded-For IP.
# COMMAND: "build-all"=build all versions, "build-trunk"=build trunk version only, ""=run the server without building.
USE_DWEM=true USE_REVERSE_PROXY=true CMD='$SCRIPTS/game/install-crawl-versions.sh' docker compose up -d && docker compose logs -f

# If you need to build without downloading images from Docker Hub, use the following command.
CMD='$SCRIPTS/game/install-crawl-versions.sh' docker compose -f docker-compose.yml -f docker-compose.build.yml up -d && docker compose logs -f
```

#### Notes
 - All server data is stored in `server/data/{versionsdb,crawl-master,dgldir,games}`.
 - Access Crawl Webtiles on port 8080, game logs on ports 8081 (Apache) and 8082 (Nginx). SSH access is available on port 2222 (using nemelex:xobeh or the [CAO key](https://crawl.develz.org/cao_key)).
 - You can use [trigger-rebuild.pl](utils/trigger-rebuild.pl) and [auth-save-downloader.pl](utils/auth-save-downloader.pl). (See: [apache.conf](server/scripts/web/conf/apache.conf), [nginx.conf](server/scripts/web/conf/nginx-default.conf))
 - Trunk and some fork builds are executed every 15 minutes. (See: [setup-cron.sh](server/scripts/utils/setup-cron.sh))
 - You can fork this repository to manage personalized build configurations as releases. (See: [release.sh](server/scripts/utils/release.sh), [upload-data.yml](.github/workflows/upload-data.yml))

### Repository Management
* This repository is used for operating crawl.nemelex.cards.
* If you need to add new forks or versions, you can request it via a Pull-Request.

### Upstream Projects
* https://github.com/crawl/dgamelaunch-config
* Scripts necessary for operating a Dungeon Crawl Stone Soup server. `utils/testing-container` contains container environment configurations created for Crawl's CI/CD verification tasks.

* https://github.com/Rytisgit/dgamelaunch-dcss-forks-server
* This project is based on dgamelaunch-config and is designed to easily configure multiple forks in a containerized environment. *This project started based on this project.*

### Thanks to

Thanks to the many developers in the `#crawl-dev` IRC channel, the implementation goals of this project were successfully achieved. 
Special thanks to [gammafunk](https://github.com/gammafunk) for the extensive help with server setup, and to [Sentei](https://github.com/Rytisgit), the developer of [DCSSReplay](https://github.com/Rytisgit/dcssreplay) and maintainer of [dgamelaunch-dcss-forks-server](https://github.com/Rytisgit/dgamelaunch-dcss-forks-server), for monitoring the server setup process and providing invaluable advice and issue resolution.
