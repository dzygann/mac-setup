# mac-setup

This is a WIP and I don't know when I'm done :D

This is a repository for my macOS setup. It fits to my requirements and can be a helpful guideline for you, too. If
something doesn't fit to your setup feel free to make adjustments or if you find a more general solution, you are also
invited to make a pull request.

## Objectives

I want to achieve an automatic way to install the applications I need for my environment. This will be extendable by
adding the name of the application in a configuration file.

This will be less error-prone and accelerate the initial setup to start with your machine the things you want to
achieve.

## Table of Content

WIP

## Prerequisites

WIP

### Caution

If you have already a `.zshrc` file in the home directory, it could be overridden. For safety reasons, you should create
a backup of the affected files.

## How to Use

The `bootstrap.sh` script is the starting point. It should have execution rights to be able to do his work. The script
will copy the `.zsh_aliases` and the `.zshrc` file to the home directory. The `brew` will start the job and install
every application defined in the `brew_apps.txt` file and in the `brew_cask_apps.txt` file. Then `brew` is used again to
run the MariaDB as a service, so that we can instantly use it.

## iTerm2

The first thing I do is to change the Scrollback Buffer to unlimited. There is nothing more annoying than to see that
the stack trace is cut off, and you need to rerun the error. You can find the toggle under the
tab `Profiles -> Terminal`
on the right side of the textbox.

If you are interested to change the appearance of the iTerm window, you can do so. To see what kind of themes are
available go to the settings of the app and click on the appearance button. There is a Theme dropdown where you can
choose the one what you like most. I prefer the `minimal` theme.

You can also change the fore and background color of the terminal. There is a color preset under
the `Profiles -> Colors` tab. On the bottom right you can decide which one you like most.

One last thing I do is to change the font size. You can find the setting in the `Profile -> Text` tab. It's located
under the Font label. Change the size value to whatever fits to you.

## jenv

`jenv` is a tool to handle different versions of Java. In Linux it's way more easy to handle different version,
but `jenv` gives us the ability to switch between different versions, too. One of the most difficult things on macOS is
that it puts the Java files in weird locations. To figure out where your current Java installation is located you can
try to use the following command:

```
/usr/libexec/java_home -V
```

The output could show the location `/Library/Java/JavaVirtualMachines/sapmachine-11.jdk/Contents/Home`. The output can
be
used to add this version to `jenv` with this command:

```shell
jenv add /Library/Java/JavaVirtualMachines/sapmachine-11.jdk/Contents/Home
```

The openjdk installed by homebrew points to a different location. You will find it here `/opt/homebrew/opt/`. Run this
command to add it to `jenv`:

```shell
jenv add /opt/homebrew/opt/openjdk
```

You can also add older versions from `openjdk` like the version 11 by using the command:

```shell
jenv add /opt/homebrew/opt/openjdk@11
```

To check if the version is installed correctly use this command `jenv versions`. Depend on the installations steps you
did, the output should print sth like:

```shell
* system (set by /Users/denis/.jenv/version)
  11.0
  11.0.18
  openjdk64-11.0.18
```

To verify if everything is fine run `jenv doctor`. You will get an output like that:

```shell
[OK]	No JAVA_HOME set
[OK]	Java binaries in path are jenv shims
[OK]	Jenv is correctly loaded
```

If you see some `[ERROR]` instead of the `[OK]` try `.source ~/.zshrc` or reopen your shell, then the `[ERROR]`
message/s should disappear.

No `JAVA_HOME` set is not good, even if the output says it is `[OK]`. To set the env variable we need to enable the
export plugin by run `jenv enable-plugin export`. Now, we can execute the `jenv doctor` command again. The output looks
better:

```shell
[OK]	JAVA_HOME variable probably set by jenv PROMPT
[OK]	Java binaries in path are jenv shims
[OK]	Jenv is correctly loaded
```

This seems to be ok, but we are still not at the end of the journey. If I run `jenv version` I get this weird
output `system (set by /Users/dzygann/.jenv/version)`. This is still not the right Java version. The last step is to
set desired Java version in the local or global `jenv` variable. First, take a look which Java versions are
available `jenv version`. The output will look like sth:

```shell
* system (set by /Users/dzygann/.jenv/version)
  11.0
  11.0.18
  openjdk64-11.0.18
```

To set the global variable run `jenv global openjdk64-11.0.18` and the output of `jenv version` changes
to `openjdk64-11.0.18 (set by /Users/dzygann/.jenv/version)`. The command with the local argument creates
a `.java-version` file which contains the selected version. If `jenv` finds that file it will use the specified version.

## MariaDB

To auto-start the MariaDB the `bootstrap.sh` script uses the `brew services start mariadb`. Now the MariaDB is running
even if the machine restarts.

### Create Schema

Connect to the MariaDB server via `sudo mariadb -uroot -p` and create a new schema:

```mariadb
CREATE SCHEMA `testdb` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
```

### Create User and Privileges

Now, let's create a user and give him some rights

```mariadb
CREATE USER 'dzygann'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON testdb.* TO 'dzygann'@'localhost';
```

Finally, it's necessary to flush the privileges to take effect of the changes:

```mariadb
FLUSH PRIVILEGES;
```

### Drop Schema

### Optional step

Optionally, you can run `sudo mysql_secure_installation`. It will ensure, that you at least was asked to configure the
right things. 





