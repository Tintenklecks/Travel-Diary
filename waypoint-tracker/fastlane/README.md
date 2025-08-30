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
### ios check
```
fastlane ios check
```
Pre Check des Projekts
### ios createCertificate
```
fastlane ios createCertificate
```
Check and Generate certificates
### ios tests
```
fastlane ios tests
```
Run UI Tests
### ios release
```
fastlane ios release
```
Create release version and upload to testflight
### ios frameAndUpload
```
fastlane ios frameAndUpload
```
Just frame it and upload screenshots
### ios uploadScreenshots
```
fastlane ios uploadScreenshots
```
Upload screenshots
### ios screenshots
```
fastlane ios screenshots
```
Generate new localized screenshots

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
