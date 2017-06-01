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
