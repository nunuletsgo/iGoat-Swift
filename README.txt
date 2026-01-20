# iGoat-Swift

OWASP [iGoat-Swift](https://igoatapp.com) is a Learning Tool (Open-Source) for iOS App Pentesting and Security. It was inspired by the WebGoat project. This directory contains the [iGoat-Swift sources](https://github.com/OWASP/iGoat-Swift).

You must have a supported Xcode version installed and then you can use the iGoat-Swift source for Swift and Objective-C to analyze the project with OpenText SAST (Fortify). Perform the translation and scan by running the following commands from the folder that contains iGoat-Swift.xcodeproj:

```
$ sourceanalyzer -b iGoat-Swift -clean
$ sourceanalyzer -b iGoat-Swift xcodebuild clean build -project iGoat-Swift.xcodeproj -sdk iphonesimulator
$ sourceanalyzer -b iGoat-Swift -scan -f iGoat-Swift.fpr
```

See the OpenText SAST (Fortify) User Guide for full details on how to perform translation and scan.

Use Audit Workbench to open the results file iGoat-Swift.fpr. See the OpenText Audit Workbench User Guide for more information about using Audit Workbench. You should see the following vulnerabilities:

## Objective-C

 - Insecure Storage: Insufficient Data Protection
 - Key Management: Hardcoded Encryption Key

## Swift:

 - File Based Cross-Zone Scripting
 - Input Interception: Keyboard Extensions Allowed
 - Insecure Storage: Lacking Data Protection
 - Insecure Transport
 - Insecure Transport: Weak SSL Protocol
 - Key Management: Empty Encryption Key
 - Key Management: Hardcoded Encryption Key
 - Log Forging

 - Password Management: Hardcoded Password
 - Privacy Violation
 - Privacy Violation: Shoulder Surfing
 - Weak Encryption: Insecure Initialization Vector

## Important
Do not make this application accessible outside of your firewall or to people you do not trust. It contains planted vulnerabilities for testing.
