fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios make_pull_request
```
fastlane ios make_pull_request
```
Create PR with release changes
### ios make_release
```
fastlane ios make_release
```
Create new release on github
### ios make_publish_pod
```
fastlane ios make_publish_pod
```
Publish to version of cocoapods

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
