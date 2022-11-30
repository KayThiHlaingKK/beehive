# InstantSearch Native Telemetry


To generate `.proto` specification and Swift telemetry telemetry execute:

```sh
make generate
```

## Telemetry parser tool

Build telemetry parser tool (Swift 5.5 is required)

```sh
make build-parser
```

Parse telemetry base64 encoded gzipped string

```sh
tmparser decode H4sIAAAAAAAAE3ukzXNAVfCEKt8JVZkLqgyPtNkOqIpcUGUEAJ
```

Parse telemetry .csv file with format `ApplicationID, user-agents`:

```sh
tmparser scan path-to-log-file.csv
```
