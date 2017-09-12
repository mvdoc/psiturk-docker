# psiturk-docker: a docker-compose configuration file to run psiturk with MySQL support.

The docker-compose file runs a standard nginx container, a standard
MySQL container, and an ad-hoc psiturk container. It links them all up,
so that the nginx container serves all the files it can to the
participant of the experiment (delegating what it cannot serve to the
Gunicorn server run by psiturk inside the psiturk container) and so that
psiturk can record data to the MySQL server container.

DISCLAIMER: this is very experimental, it can be improved (see known
issues below), but for the moment it works for me (at least testing it).
Feel free to play with it (and maybe submit PRs so we all benefit from
it? ;) )

## HOW TO

First, make sure that you change `config.txt` as necessary. Importantly,
you'll need to set `adserver_revproxy_host` to either the static IP
address of the machine that your experiment is deployed on or a fully
qualified domain name (without the protocol) that resolves to that IP
address. You'll also need to set `adserver_revproxy_port` to 80. While
psiturk normally runs on port 22362, nginx is a reverse proxy that sits
in front of psiturk since it does a better job of handling traffic and
serving static files, and nginx runs on port 80. It delegates everything
else to psiturk, running on port 22362.

**Important**: If you're only just testing things on a local computer
(*i.e.*, a computer that is not the deployment computer with a static IP
address), you should leave the `adserver_revproxy_host` value set to the
loopback IP address of `127.0.0.1`, which is just another way of
pointing to the computer that you're currently using. This will allow
you to succesfully test and debug the experiment without having to
deploy it on the computer with the static IP address. However, when you
do deploy the experiment, *make sure* that you change
`adserver_revproxy_host` to either the static IP address of the
deployment machine or a fully qualified domain name (without the
protocol) that resolves to that IP address.

Next, install docker and docker-compose. Then run

```
docker-compose up -d
```

This should download the relevant images, build the psiturk image, run
the containers, and link them. By default they are launched in "daemon"
mode (`-d`).

Then, you need to log in into the psiturk container to use the psiturk
shell:

```
docker attach psiturkdocker_psiturk_1
```

or change `psiturkdocker_psiturk_1` with whatever name shows up for the
psiturk container.  After that command, you should be logged into the
container. To test that everything works, try

```
cd psiturk-example psiturk
```

this should launch the psiturk shell. Then cross your fingers and run

```
server on
debug -p
```

if your server is visible in the network, copying and pasting the URL on
the browser should let you try the experiment.

Note: to detach from the container **do not type `exit`**; this will
kill the container (although it might restart automatically, it's not
nice). Instead, press the sequence `ctrl+p ctrl+q` to detach.

## Data and experiments

By default `docker-compose.yml` maps `./exp` in the host to `/psiturk`
in the psiturk container.  (This folder is also mapped to
`/var/www/psiturk-example` in the nginx container, but it is mapped as
read only inside of that container; this is so nginx can serve the
static files from the experiment, delegating the rest to the psiturk
container.) This means that you can put any experiment directory into
`./exp`, then cd into `/psiturk` from within the psiturk container, and
run the psiturk shell.

The global psiturk configuration file is in `./exp/.psiturkconfig`, and
the env variable is set to point there inside the container.

Also, the mysql database is saved under `./data/db`, and the user and
password can be changed by changing the environment variables in
`docker-compose.yml` (remember to change the `database_url` in the
`config.txt` of the example if you do change it).

## Accessing the database through adminer

The `docker-compose.yml` installs `adminer` as a service, which allows
you to check the database
through webpage. You should be able to open the browser and visit
`localhost:8080` to see the page. Insert the username and password, and
you can check when new subjects's data is recorded.

## Known issues

- if you run `server log` from the psiturk shell, it crashes miserably because psiturk wants
xterm installed, but we're not installing it. If you do want to see the log, you can always
log in the container and `cat` or `tail` the `server.log` file.


