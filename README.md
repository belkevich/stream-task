NSURLSession bug
===

#### About

This project contains two applications for iOS and macOS. That should demonstrate strange behavior of [NSURLSession](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/).

#### 1. `NSURLSession` doesn't release delegate after `NSURLSessionStreamTask` created on macOS

After `streamTaskWithHostName:port:` call `invalidateAndCancel` stop working. `URLSession:didBecomeInvalidWithError:` will not be called. And delegate will not be released.

Start iOS app and run steps from 1 to 6. You will see the log:
```
StreamTask-ios[9314:315321] create
StreamTask-ios[9314:315321] run
StreamTask-ios[9314:315321] Capturing streams...
StreamTask-ios[9314:315321] Streams are captured
StreamTask-ios[9314:315321] Cancelling stream task...
StreamTask-ios[9314:315321] URL Session invalidate...
StreamTask-ios[9314:316823] URLSession become invalid with error:
(null)
StreamTask-ios[9314:315321] URL Session delegate wait for release...
StreamTask-ios[9314:315321] URL Session released delegate
```

Then run same steps for the macOS app:
```
StreamTask-mac[9331:318999] create
StreamTask-mac[9331:318999] run
StreamTask-mac[9331:318999] Capturing streams...
StreamTask-mac[9331:318999] Cancelling stream task...
StreamTask-mac[9331:318999] URL Session invalidate...
StreamTask-mac[9331:318999] URL Session delegate wait for release...
StreamTask-mac[9331:318999] Streams are captured
```

#### 2. `NSURLSession` doesn't release delegate if `NSURLSessionStreamTask` created but streams is not captured

After `streamTaskWithHostName:port:` call `invalidateAndCancel` works only if `captureStreams` method called.

Start iOS app and run steps 1 - 6 **except step 3 (Capture Streams)**
```
StreamTask-ios[9450:337676] create
StreamTask-ios[9450:337676] run
StreamTask-ios[9450:337676] Cancelling stream task...
StreamTask-ios[9450:337676] URL Session invalidate...
StreamTask-ios[9450:337676] URL Session delegate wait for release...
```

#### 3. `NSURLSessionStreamTask`'s method `cancel` does nothing

After `cancel` method called `URLSession:task:didCompleteWithError:` will not be called.

Run iOS or macOS app create session (1), run task (2), cancel stream task (4) and nothing happens.
```
StreamTask-ios[9463:340258] create
StreamTask-ios[9463:340258] run
StreamTask-ios[9463:340258] Cancelling stream task...
```
