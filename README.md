## Installation

*__This README is outdated__, and the repo has changed drastically, read the Makefile if you know what you're doing*

```bash
make install
```

Add a .bash/extras.sh file with your additional settings, such as:

```bash
git config --global user.name FULLNAME
git config --global user.email EMAIL
git config --global github.user USERNAME
git config --global github.token TOKEN
```

## Features

### Bundled scripts

#### [ack](http://betterthangrep.com/)

Ack, better than grep

#### [markdown](http://daringfireball.net/projects/markdown/)

Markdown to HTML script

#### SSH Expect

Make ssh connection with password and identity file scriptable. Without
identity file one can use sshpass, but for both password and file, this is
needed.

```
sshexp user password path_to_identity_file hostname command
```

#### Track
```
Usage: track [action]

Dead simple time tracking / logging script.

Options:
  -s, --show    Show log entries, takes a couple of different arguments.
                  -s: show the default[20] amount of entries
                  -s 10: show the 10 latest entries
                  -s today: show all entries made today
                  -s time: try to calculate time tracked today

  -f, --find    Filters through log entries with grep.
                  -f Added\ function

  -u, --undo    Undo the last entry addition. Note, you cant undo undoes.

  -h, --help    Displays this output

  *             Everything else passed will be logged, some keywords exist:
                  - if you timestamp a message with HH:MM it will be respected.
                  - if your message is END, it will be used to track time
                    beginning at the previous message.
```

### Useful aliases/functions
- `ip` Output your external IP.
- `server` Start a HTTP server in current path.
- `license` Output a MIT license file.
- `extract` Extract content from a compressed file.
- `bu` Backup current directory to ~/.backup.
- `record_desktop` Begin screenrecording and share the video over HTTP (needs polishing).
- `psgrep` Grep trough running processes.
- `mkcdir` Create a directory and move into it.
- `calc` A proper calculator
- `bf` List the 10 biggest files in the current path.

## Screenshots

All screenshots are taken on a black background, actually there is a 10% alpha
transparency on them, configured for urxvt

#### Full screen

![Full screen](http://i.imgur.com/6kP2O.png)

#### Mutt

![Mutt](http://i.imgur.com/EkUx6.png)

#### Irssi

![Irssi](http://i.imgur.com/PRrEH.png)

#### ls++ & vim

![ls++ & vim](http://i.imgur.com/XWNXB.png)

## Additional suggestions

As this is often used with shell-only accessed computers I'm not including a
font but my personal preference is [Inconsolata](http://levien.com/type/myfonts/inconsolata.html) by Raph Levien.

```bash
mkdir -p ~/.fonts && cd ~/.fonts && wget http://levien.com/type/myfonts/Inconsolata.otf && fc-cache -f -v
```

## Inspired/Stolen by

- [Gianni Chiappetta](https://github.com/gf3/dotfiles)
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Ryan Tomayko](https://github.com/rtomayko/dotfiles)
- [Holman](https://github.com/holman/dotfiles)
- [Jan Moesen](https://github.com/janmoesen/tilde)

and more whom are referenced within the files.
