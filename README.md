# Apigo Starter Project for iOS #


A framework that gives you access to the powerful Apigo cloud platform from your iOS app. 
For more information about Apigo and its features, see [Apigo Website][apigo.id] and [Apigo Documentations][docs].

## Download
1. Download the latest Apigo framework [here][framework].
2. Then drag `Apigo.framework` into the `Frameworks` sections in your XCode project.
3. Ensure the following frameworks and a library exist in your project :
    - `SystemConfiguration.framework`
    - `Security.framework`
    - `QuartzCore.framework`
    - `CoreLocation.framework`
    - `CoreGraphics.framework`
    - `CFNetwork.framework`
    - `AudioToolbox.framework`
    - `libsqlite3.0.tbd`

## Setup
1. Register first to [Apigo Cloud][cloud]
2. Create an application to get `applicationId` and `clientKey`
3. Add this line below to your `Application` class to initialize Apigo SDK

```swift
Apigo.initialize(withServer: "APIGO_SERVER_URL",
                applicationId: "APIGO_APPLICATION_ID",
                clientKey: "APIGO_CLIENT_KEY")
```

(Optional) You can add some custom setup :

* Enable Apigo SDK debug logging by calling `Apigo.+setLogLevel:` before initialize SDK.
* Apigo `APLogLevel` mode : `none`, `error`, `warning`, `info`, `debug`

Everything is done!

## License
    Copyright (c) 2018, Apigo.
    All rights reserved.

[apigo.id]:https://apigo.id
[docs]:https://apigo.id/docs/
[cloud]:https://customer.apigo.id/
[framework]:https://github.com/apigoid/Apigo-iOS/releases/latest
