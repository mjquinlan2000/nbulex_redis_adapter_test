# RedixTest

This is a test of the nebulex redis adapter against kubernetes deployments of the redis cluster

# Prerequisites

Install [helm](https://helm.sh/docs/intro/install/)
Install [Docker](https://docs.docker.com/get-docker/)
Install [kubectl](https://kubernetes.io/docs/tasks/tools/)
Install [minikube](https://minikube.sigs.k8s.io/docs/start/)

# Deploying the cluster

Start minikube

`minikube start`

Add the bitnami helm repository

`helm repo add bitnami https://charts.bitnami.com/bitnami`

Update your helm charts

`helm repo update`

Install a redis cluster and wait a few minutes for it to come up

`helm install redis-cluster bitnami/redis-cluster --set usePassword=false`

Deploy the [sample application](https://hub.docker.com/repository/docker/mjquinlan2000/redix-test/general) from the project dir

`kubectl apply -f k8s`

In a separate terminal watch the services:

`watch kubectl get pods -o wide`

# Test it

In another terminal, exec into the redix-test pod to pull up an iex terminal

`kubectl exec -it redix-test-[HASH] -- bin/redix_test remote`

Start putting things into the cache and reading them to make sure it works

```elixir
RedixTest.Cache.put("hello", "world")
RedixTest.Cache.get("hello")
```

In another terminal perform a rollout of the redis cluster

`kubectl rollout restart statefulset redis-cluster`

While this is happening, continue to try and read/write to the cache. Notice at some point you get the error:

```
** (Redix.ConnectionError) the connection to Redis is closed
    (redix 1.2.2) lib/redix.ex:514: Redix.command!/3
    (nebulex_redis_adapter 2.2.0) lib/nebulex_redis_adapter/redis_cluster.ex:62: anonymous fn/7 in NebulexRedisAdapter.RedisCluster.exec!/5
    (elixir 1.14.4) lib/enum.ex:2468: Enum."-reduce/3-lists^foldl/2-0-"/3
    (nebulex_redis_adapter 2.2.0) lib/nebulex_redis_adapter.ex:857: NebulexRedisAdapter.execute_query/3
    (nebulex_redis_adapter 2.2.0) lib/nebulex_redis_adapter.ex:761: anonymous fn/5 in NebulexRedisAdapter.execute/4
    (telemetry 1.2.1) /build/deps/telemetry/src/telemetry.erl:321: :telemetry.span/3
    iex:88: (file)
```

You can fix this error by running this in your iex terminal

`NebulexRedisAdapter.RedisCluster.ConfigManager.setup_shards(RedixTest.Cache)`

