# dcss-server

> The [README.md](README.md) document was automatically translated using ChatGPT to create [README.ko.md](README.ko.md).

This script is designed to simplify the deployment and management of a Dungeon Crawl Stone Soup server. It includes as many fork versions (DCSS CA, HellCrawl, GnollCrawl, BloatCrawl2, GoonCrawl, X-Crawl, StoatSoup, KimchiCrawl, BcadrenCrawl) and official release versions (0.11 ~ 0.31) as possible in a modern Ubuntu image environment.

### First Run Guide:
#### Prerequisites
* Docker (with Docker Compose)
* Note: To use the download feature of the release.sh script, `jq` and `curl` must be installed in the environment. (You can install them in a Debian environment using `apt install jq curl -y`.)

#### Fast Deploy
```bash
git clone https://github.com/refracta/dcss-server
cd dcss-server/server

# Download pre-built game binaries and configurations
sudo ./release.sh download -o -p data -n game-data
# Run with random ports
docker compose up -d && docker compose logs -f
# Run with specified ports
docker compose -f docker-compose.yml -f docker-compose.ports.yml up -d && docker compose logs -f
```

#### Deploy with Build
```bash
git clone https://github.com/refracta/dcss-server
cd dcss-server/server

# This command is optional. You can download ccache files to speed up the compilation process.
# Without it, the full build takes over 6 hours based on the ubuntu-24.04 image of the GitHub Action Runner, but with it, it speeds up to about 45 minutes.
./release.sh download -p data/ccache -n ccache

# USE_DWEM: Applies the use of https://github.com/refracta/dcss-webtiles-extension-module.
# USE_REVERSE_PROXY: Applies a patch to log the X-Forwarded-For IP.
# COMMAND: "build-all"=builds all versions, "build-trunk"=builds only the trunk version, ""=runs the server without building.
USE_DWEM=true USE_REVERSE_PROXY=true COMMAND=build-all docker compose up -d && docker compose logs -f

# If you need to build without downloading images from Docker Hub, you can use the following command.
COMMAND=build-all docker compose -f docker-compose.yml -f docker-compose.build.yml up -d && docker compose logs -f
```

#### Notes
 - All server data is stored in `server/data/{versionsdb,crawl-master,dgldir,games}`.
 - You can access Crawl Webtiles on port 8080, game logs on ports 8081 (Apache) and 8082 (Nginx), and SSH on port 2222. (You can connect using nemelex:xobeh or the [CAO key](https://crawl.develz.org/cao_key))
 - You can use [trigger-rebuild.pl](utils/trigger-rebuild.pl) and [auth-save-downloader.pl](utils/auth-save-downloader.pl). (See: [httpd.conf](server/httpd.conf), [nginx-default.conf](server/nginx-default.conf))
 - Builds for the trunk and some forks are executed every 15 minutes. (See: [setup-cron.sh](server/setup-cron.sh))
 - You can fork this repository to manage personalized build configurations as releases. (See: [release.sh](server/release.sh), [upload-data.yml](.github/workflows/upload-data.yml))

### Repository Management
* This repository is used for operating crawl.nemelex.cards.
* If you need to add a new fork or version, you can request it via a Pull-Request.

### Upstream Projects
* https://github.com/crawl/dgamelaunch-config
* Scripts necessary for operating a Dungeon Crawl Stone Soup server. `utils/testing-container` contains a container environment configuration created for Crawl's CI/CD verification tasks.

* https://github.com/Rytisgit/dgamelaunch-dcss-forks-server
* This project is based on dgamelaunch-config and is designed to easily configure multiple forks in a containerized environment. *This project was started based on this project.*

### Thanks to

Thanks to the many developers in the `#crawl-dev` IRC channel, the implementation goals of this project were successfully achieved. 
In particular, I would like to thank [gammafunk](https://github.com/gammafunk) for their help with server setup, and [Sentei](https://github.com/Rytisgit), the developer of [DCSSReplay](https://github.com/Rytisgit/dcssreplay) and maintainer of [dgamelaunch-dcss-forks-server](https://github.com/Rytisgit/dgamelaunch-dcss-forks-server), for monitoring the server setup process and providing invaluable advice and issue resolution.