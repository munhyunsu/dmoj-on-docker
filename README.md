# dmoj-on-docker

# Create image

```bash
cd site
docker build -t dmoj-site .
```

# Explamples

```bash
docker run --detach --interactive --tty --name dmoj -p 11000:80 -p 11001:9999 dmoj-site
```

```bash
docker run --name judge1 --volume /home/harny/Github/Problems:/problems --volume /home/harny/Github/Problems/conf.d/Judge1.yml:/problems/judge.yml --cap-add=SYS_PTRACE --add-host=host.docker.internal:host-gateway dmoj/judge-tier3:latest run -p 11001 host.docker.internal

docker run --name judge1 --volume /home/harny/Github/Problems:/problems --cap-add=SYS_PTRACE --add-host=host.docker.internal:host-gateway dmoj/judge-tier3:latest run -p 11002 -c /problems/judge.xml host.docker.internal

docker container stop judge1; docker container rm judge1
```
