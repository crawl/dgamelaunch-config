# dgamelaunch-config

This is a collection of scripts to manage a dgamelaunch
(http://nethackwiki.com/wiki/Dgamelaunch) install, all run from an
umbrella `dgl` script.

These are still very incomplete, WIP.

Currently available commands:

1. Update your dgamelaunch config from the repository:
   ```
   $ sudo dgl publish --confirm
   ```

2. Change a dgl user's password:
   ```
   $ sudo dgl passwd johndoe
   ```

3. Update Crawl alpha build from git master:
   ```
   $ dgl update-trunk
   ```

4. Remove stale Crawl alpha versions:
   ```
   $ dgl remove-trunks
   ```

5. Run dgl-whereis inotify daemon:
   ```
   $ sudo dgl crawl-inotify-dglwhere
   ```

   This inotify daemon monitors the dgamelaunch in-progress dirs to keep
   track of active players, and monitors their morgue directories for
   changes to their .where files. When a .where changes, the daemon reads
   it and writes a human-readable .dglwhere file in the same directory.

   You may configure dgamelaunch to show this .dglwhere information
   using the dgamelaunch extra_info_file option.

   You may also run the crawl-inotify-dglwhere script standalone (without
   the rest of the dgamelaunch-config setup) by starting it as:

      sudo -u dgl perl crawl-inotify-dglwhere.pl <dgldir> <morguedir>

Note: Some of these commands will probably change names soon.

The ultimate goal for this project is to become a one-stop shop for
all your dgamelaunch+Crawl needs, starting from installing dgamelaunch
itself

# TODO

1. `dgl install-dgl` command to fetch and install the latest dgamelaunch.

2. `dgl create-chroot` command to set up a basic chroot jail with all the
   fixtures dgamelaunch wants (dgamelaunch already has a skeleton script
   that can serve as a basis, although this is unfortunately NetHack-biased).

3. Support for installing different games, including fetching their sources
   from their respective source repositories, compiling, installing into the
   chroot, etc.
   ```
   dgl install crawl master`
   dgl install nethack 3.4.3`
   ```
   Etc.

   Installing a game should also (eventually) add a suitable entry to
   the various menu files and update the dgamelaunch config
   appropriately.

4. Support for tracking development versions of games (such as Crawl
   master) using a system similar to CDO's for creating versioned
   directories, migrating saves to newer versions, and deleting old
   versions with no remaining save games.

5. Module system so that management of say, crawl-git is a
   self-contained module. Each module should be able to contribute dgl
   commands and provide files that will be installed to the chroot or
   root filesystem.

6. Each dgl command that affects the machine or chroot should update a
   manifest. The manifest could be a file or a directory containing
   multiple manifest files.

   Given a manifest, I should be able to install dgamelaunch-config
   on a brand new machine and use one dgl command to recreate the manifest.

   For instance, something like:
   `dgl replicate-manifest <path-to-manifest>`

   The manifest should include information like this:
   * What dgamelaunch version is installed, and from where (install-dgl module)
   * chroot configuration: what binaries and libraries have been installed
     into the chroot, with the exception of game binaries, i.e. the state of
     the chroot minus games (chroot module)
   * Game configuration (handled by the various game modules)
