# docker-taskd

This is a [Taskwarrior](https://www.taskwarrior.org/) taskd sync server in an Alpine Linux-based container.

* Git repo: <https://gitlab.com/johnivore/docker-taskd>
* Dockerhub: <https://hub.docker.com/r/johnivore/taskd/>


## Usage

```bash
docker run -d \
    --name=taskd \
    -v /srv/taskd:/var/taskd \
    -p 53589:53589 \
    johnivore/taskd
```

### Example docker-compose

```yml
services:
  taskd:
    image: johnivore/taskd:latest
    container_name: "taskd"
    restart: "unless-stopped"
    volumes:
      - "/srv/taskd:/var/taskd"
    ports:
      - "53589:53589"
    environment:
      # used during certificate generation
      - "EXPIRATION_DAYS=365"                 # default: 365
      - "ORGANIZATION=My awesome company"     # default: ""
      - "CN=sync.example.com"                 # default: localhost.localdomain
      - "COUNTRY=China"                       # default: ""
      - "STATE=Shanghai"                      # default: ""
      - "LOCALITY="                           # default: ""
```

### Certificate generation

Note that the certificate vars are used when generating the sync server's certs,
such as when starting an empty container.  The 'vars' file is built at container boot
time as a convenience when (re-)issuing certs.  See the [taskserver docs](https://taskwarrior.org/docs/taskserver/configure.html) for how to create users, issue certificates, and configure clients.


## License

```
Copyright 2021 John Begenisich

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```
