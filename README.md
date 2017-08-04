# psiturk-docker A docker-compose configuration file to run psiturk with
MySQL support.

The docker-compose file runs a standard MySQL container and an ad-hoc
psiturk container, links them up, and psiturk should magically talk to
the MySQL server.

DISCLAIMER: this is very experimental, it can be improved (see known
issues below), but for the moment it works for me (at least testing it).
Feel free to play with it (and maybe submit PRs so we all benefit from
it? ;) )

## HOW TO Install docker and docker-compose. Then run

``` docker-compose up -d ````

This should download the relevant images, build the psiturk image, run
the containers, and link them. By default they are launched in "daemon"
mode (`-d`).

Then, you need to log in into the psiturk container to use the psiturk
shell:

``` docker attach psiturkdocker_psiturk_1 ```

or change `psiturkdocker_psiturk_1` with whatever name shows up for the
psiturk container.  After that command, you should be logged into the
container. To test that everything works, try

``` cd psiturk-example psiturk ```

this should launch the psiturk shell. Then cross your fingers and run

``` server on debug -p ```

if your server is visible in the network, copying and pasting the URL on
the browser should let you try the experiment.

Note: to detach from the container **do not type `exit`**; this will
kill the container (although it might restart automatically, it's not
nice). Instead, press the sequence `ctrl+p ctrl+q` to detach.

## Data and experiments By default `docker-compose.yml` maps `./exp` in
the host to `/psiturk` in the psiturk container.  Thus, you can put any
experiment directory into `./exp`, then cd into that within the
container, and run the psiturk shell.

The global psiturk configuration file is in `./exp/.psiturkconfig`, and
the env variable is set to point there inside the container.

Also, the mysql database is saved under `./data/db`, and the user and
password can be changed by changing the environment variables in
`docker-compose.yml` (remember to change the `database_url` in the
`config.txt` of the example if you do change it).

## Accessing the database through adminer The `docker-compose.yml`
installs `adminer` as a service, which allows you to check the database
through webpage. You should be able to open the browser and visit
`localhost:8080` to see the page. Insert the username and password, and
you can check when new subjects's data is recorded.

## Known issues

- if you run `server log` from the psiturk shell, it crashes miserably because psiturk wants
xterm installed, but we're not installing it. If you do want to see the log, you can always
log in the container and `cat` or `tail` the `server.log` file.


