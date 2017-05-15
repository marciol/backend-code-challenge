Benchmarks
=======================

Here live the scripts to benchmark the API.

In order to make use of this scripts you need to have installed [wrk2](https://github.com/giltene/wrk2), a modern tool based on the original `wrk` but with a important improvement, wrk2 produce a constant throughput making possible an really accurate result.

### Distances API

We use real data to make the load test, available in `seeds/distance_locations.txt`, through the advanced lua api offered by wrk2 in order to customize the data we send during the test, so we can take a picture very close of a real production use case. This details in `benchmark/scripts/multiple-distances-data.lua`

In order to run the test execute:

```
benchmark/distance_load_test
```

### Cost API

We use real data to make the load test, available in `seeds/cost_locations.txt`, with almost the same setup described above, but with one more requirement, we need `redis-server` installed as well.

More details in `benchmark/scripts/multiple-costs-data.lua`

In order to run the test execute:

```
benchmark/cost_load_test
```
