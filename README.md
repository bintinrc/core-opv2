## Running the tests

<hr>

From terminal:

```
$ ./gradlew runCucumber -Ptags="@wip"
```

From IntelliJ Run/Debug Configuration:

```
runCucumber -Ptags="@wip"
```

## Tips

<hr>

For running test in **local**, these environment variables can help you by adding them to
the `.env` file:*

```
QA_PARALLEL=1
QA_ENV=core-qa-sg
QA_HEADLESS=<true/false>
```

*but, **please don't commit and push them**