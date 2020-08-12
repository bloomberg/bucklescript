Special tests for super errors (the pretty error display)

Follow CONTRIBUTING.md and run the integration test:

```sh
BS_TRAVIS_CI=1 npm install -g .
```

To get a production bsc binary the test script will use.

Then, run `node ./jscomp/build_tests/super_errors/input.js` to check the tests against previous snapshots.
Run `node ./jscomp/build_tests/super_errors/input.js update` to update the snapshots (assuming you've made some changes to super errors' display and/or messages)