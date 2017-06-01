Galaxy infrastructure for the ReproHackathon1
=============================================

# Local usage 

- Create the Docker image

    ```
    $ docker build -t reprohackathon .
    ```

- Launch a Docker container

    ```
    $ docker run -d -p 8080:80 reprohackathon
    ```

> Because we've used an Ubuntu 14:04 . We have to modify /etc/default/docker file 
> `DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --storage-driver=devicemapper"`
