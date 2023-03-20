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

### Additional configuration for oh-my-zsh

If you are using `oh-my-zsh` you could want to use `zsh-autosuggestion`. This tool predicts your next commands you
want to enter to the terminal. For very long commands it could be that you want to change the some arguments. Or
you want to remove some words from the command in a easy way. For that reason, you have to change `Key Mappings`.
You can find them under the `Settings -> Profiles -> Keys -> Key Mapping`. There you have to search for the
`⌥ ←` and `⌥→` Mappings. Double click on the backword key mapping and change the `Esc+` to `b` and for the forward
key mapping to `f`. Now it is possible to jump forward and backwards by using the shortcuts for words in the
predicted command.

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

## nmap

The Network Mapper (nmap) is a tool to discover the network. It scans IP addresses and its ports and creates a report
at the end. By analyzing the report you can find out which devices are connected to the network, discover the open ports
and services and detect vulnerabilities.

To run a simple scan in your local network you can run the command:

```shell
nmap 192.168.178.0/24
```

After a while you will get a report with all found devices and its open ports. An entry consists the following
information:

```shell
Nmap scan report for 192.168.178.2
Host is up (0.0088s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT    STATE SERVICE
22/tcp  open  ssh
80/tcp  open  http
```

To get a full list of devices in the network in a fast manner you could use the `-sL` argument. The response contains a
list of names and the IP addresses in parentheses if it could find a device. Otherwise, it returns the IP only:

```shell
...
Nmap scan report for my-device (192.168.178.2) # finding
Nmap scan report for 192.168.178.3 # nothing found
...
```

If you want to act more quietly, you can add the `-sS` arguments. These arguments change the analysis behaviour of nmap,
so that it doesn't complete the 3-way-handshake. It seems for the destination device, that send SYN/ACK signal bit to
the source device get lost. Run the command `sudo nmap -sS 192.168.178.2` and you will get a similar result as above.
The disadvantage of this method is, that it is slower and could deliver less information about a device.

To get more information about the device you're scanning you could add the `-O` argument. This triggers nmap to figure
out what kind of OS is the other device running on. Run `sudo nmap -O 192.168.178.2` and check if the response matches
to your expectations. In my case it did:

```shell
Nmap scan report for my-device (192.168.178.2)
Host is up (0.0055s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE    SERVICE
22/tcp   open     ssh
80/tcp   open     http
MAC Address: 00:5A:10:B8:98:67 (Asus)
Device type: general purpose
Running: Linux 4.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:4 cpe:/o:linux:linux_kernel:5
OS details: Linux 4.15 - 5.6
Network Distance: 1 hop

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 4.33 seconds
```

Another feature of `nmap` is to figure out the version of the service which is running on the device. It doesn't work
for all services, but it does a good work for that one it knows. This is an example response of `scanme.nmap.org`:

```shell
nmap -sV scanme.nmap.org
Starting Nmap 7.93 ( https://nmap.org ) at 2023-03-20 12:39 CET
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.17s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 992 closed tcp ports (conn-refused)
PORT      STATE    SERVICE      VERSION
22/tcp    open     ssh          OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
53/tcp    open     domain?
80/tcp    open     http         Apache httpd 2.4.7 ((Ubuntu))
135/tcp   filtered msrpc
139/tcp   filtered netbios-ssn
445/tcp   filtered microsoft-ds
9929/tcp  open     nping-echo   Nping echo
31337/tcp open     tcpwrapped
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 46.99 seconds
```

In this way you could use the nmap to find outdated versions of a service and update them accordingly.

The most time-consuming scanning is with the  `-A` option. This scan contains the OS detection, version detection,
script scanning, and traceroute. Try this command and check out the response `nmap -A scanme.nmap.org`


