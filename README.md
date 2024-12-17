# dmoj-on-docker

# Create image

```bash
cd site
docker build -t dmoj-site .
```

```bash
cd all
docker build -t local/dmoj-all .
```

# Running examples

- Run site

```bash
docker run --detach --interactive --tty --restart unless-stopped --name dmoj --volume PROBLEMABSOLUTEPATH:/workspace/problems --add-host=host.docker.internal:host-gateway --publish 11000:80 --publish 11001:9999 dmoj-site
```

- Connect judge

```
docker run --detach --restart unless-stopped --name judge1 dmoj --volume PROBLEMABSOLUTEPATH:/problems --volume JUDGECONF:/judge.yml --add-host=host.docker.internal:host-gateway --cap-add=SYS_PTRACE dmoj/judge-tier3:latest run -p 11001 -c /judge.yml host.docker.internal JUDGENAME JUDGEKEY
```

## Ref

- [mariadb-tzinfo-to-sql](https://mariadb.com/kb/en/mariadb-tzinfo-to-sql/)
- [DMOJ docker](https://github.com/Ninjaclasher/dmoj-docker)
