# intraday-stats
Stats on intraday market data

# To execute intraday stats the arguments are

`--hour 21 -d 2 -s EURUSD`

# To execute the R graph part the arguments are

```bash
Rscript plotFrequency.r EURUSD 4 2
```

## Docker

To log in to the container. Swap out the container name

```bash
docker exec -it container_name /bin/bash
```