---
title: Add Nexmo Client SDK To Your iOS App 
---

# Get Started - Add Nexmo Client SDK To Your iOS App

Let's get started with Nexmo SDK on your iOS app! Here are all the details on how to set that up:

## Prerequisites

To use the Nexmo SDK for iOS, you will need to have the following installed:

* Xcode 10 or later
* iOS 10 or later

## Add The SDK To Your iOS Project

Open XCode with your iOS project.

You can either install the SDK via CocoaPods or directly:

### CocoaPods

1. Open your project's `PodFile`

2. Under your target add the `NexmoClient` pod. Replace `TargetName` with your actual target name.

   ```ruby
   target 'TargetName' do
       pod 'NexmoClient'
   end
   ```

   > *Note:* Make sure the pod file has the public CocoaPod specs repository source.

3. Install the Pod by opening terminal and running the following command:

```ruby
   $ cd 'Project Dir'
   $ pod update
   ```

   where `Project Dir` is the path to the parent directory of the `PodFile`

4. Open the `xcworkspace` with XCode and disable `bitcode` for your target.

5. In your code, import the `NexmoClient` library:  
    **Swift**
    ```swift
    import NexmoClient  
    ```

    **Objective-C**
    ```objective-c
    #import <NexmoClient/NexmoClient.h>;
    ```

### Frameworks

1. Download the Nexmo SDK and add it to your project

2. Open the `xcworkspace` with XCode and disable `bitcode` for your target.

3. In your code, import the NexmoClient library:  
    **Swift** 
    ```swift
    import NexmoClient  
    ```

    **Objective-C**
    ```objective-c
    #import <NexmoClient/NexmoClient.h>;
    ```

## Add Permissions

To use the in app voice features, you should add audio permissions:

1. In your `Info.plist` add a new row with 'Privacy - Microphone Usage Description' and a description for using the microphone. For example `Audio Calls`.

2. In your code add a request for Audio Permissions  

**swift**:
```swift

import AVFoundation

func askAudioPermissions() {
    AVAudioSession.sharedInstance().requestRecordPermission { (granted:Bool) in
        NSLog("Allow microphone use. Response: %d", granted)
    }
}
```

**objective-c**:

```objective-c
#import <AVFoundation/AVAudioSession.h>

- (void)askAudioPermissions {
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        [[AVAudioSession sharedInstance] requestRecordPermission: ^ (BOOL granted)
        {
        NSLog(@"Allow microphone use. Response: %d", granted);
        }];
    }
}

```

---

## Using NXMClient On Your App

### Login

1. Create a `NXMClient` object and login with a `jwt` user token. You can read more about generating the `jwt` [here](_documentation/client-sdk/concepts/jwt-acl).

**Swift**
```swift
let client = NXMClient(token: "your token")
client?.setDelegate(self)
client?.login()
```

**Objective-C**
```objective-c
NXMClient *client = [[NXMClient alloc] initWithToken:@"your token"];
[client setDelegate:self];
[client login];
```

> *Note*: self should implement `NXMClientDelegate` protocol.  

On a succesfull login, The following delegate method is called with `NXMConnectionStatusConnected`.

**Swift**
```swift
func loginStatusChanged(_ user: NXMUser?, loginStatus isLoggedIn: Bool, withError error: Error?)
```

**Objective-C**
```objective-c
- (void)connectionStatusChanged:(NXMConnectionStatus)status reason:(NXMConnectionStatusReason)reason;
```

After the login succeeds, the logged in user will be available via:


### Get current user info
**Swift**
```swift
let user = client.user
```

**Objective-C**
```objective-c
NXMUser *user = client.user;
```

## Congratulations!

You added the Nexmo Client SDK to your iOS app, and logged in to a `NXMClient` instance. You're all set to use that `NXMClient` client in your app, and utilize the NexmoClient SDK functionalities.
