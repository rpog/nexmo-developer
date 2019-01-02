---
title: Add Nexmo Client SDK To Your iOS App 
---

# Get Started - Add Nexmo Client SDK To Your App

Let's get started with Nexmo SDK on your Android app! Here are all the details on how to set that up:

## Prerequisites

To use the Nexmo SDK for iOS, you will need to have the following installed:

* Xcode 10 or later
* iOS 10 or later

## Import the SDK to your iOS project

### CocoaPods

1. Open your project's `PodFile`

2. Under your target add the `NexmoClient` pod. Replace `TargetName` with your actual target name.

   ```ruby
   target 'TargetName' do
       pod 'NexmoClient'
   end
   ```
   * Replace `Target Name` with your project's target.
   * Make sure the pod file has the public CocoaPod specs repository source.

4. Install the Pod by opening terminal and running the following command:

   ```ruby
   $ cd 'Project Dir'
   $ pod update
   ```
   where `Project Dir` is the path to the parent directory of the `PodFile`

5. Open the `xcworkspace` with XCode and disable `bitcode` for your target.

6. In your code, import the NexmoClient library:  
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

### Permissions
1. **Audio Permissions**  
    * In your code add a request for Audio Permissions  
        **swift**:   
        ```swift
        import AVFoundation
        ```
        ```swift
        func askAudioPermissions() {
            AVAudioSession.sharedInstance().requestRecordPermission { (granted:Bool) in
                NSLog("Allow microphone use. Response: %d", granted)
            }
        }
        ```
        **objective-c**: 
        ```objective-c
        #import <AVFoundation/AVAudioSession.h>
        ```
        ```objective-c
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
    * In your Info.plist add a new row with 'Privacy - Microphone Usage Description' and a description for using the microphone. For example `Audio Calls`.



    ## Getting Started
As part of the authentication process, the nexmo client requires a jwt token with the [proper credentials](DevRel:LinkForNDPExplanationRegardingTokensAndAuthentication).  
For ease of access, we advise to set up a Web Service to generate a unique Identity Token for each user on request.

### Login
Create a NXMClient object and login with a token.  
**Swift**
```swift
let client = NXMClient()
client.setDelegate(self)
client.login(withAuthToken: "your token")
```

**Objective-C**
```objective-c
NXMClient *client = [NXMClient new];
[client setDelegate:self];
[client loginWithAuthToken:@"your token"];
```
where `"your token"` is the string format of the jwt for the user you wish to log in.  
**Note:** self should implement the `NXMClientDelegate` protocol.  
At the end of a succesfull login process, The following delegate method is called with isLoggedIn = true, now you can use the client.

**Swift**
```swift
func loginStatusChanged(_ user: NXMUser?, loginStatus isLoggedIn: Bool, withError error: Error?)
```

**Objective-C**
```objective-c
- (void)loginStatusChanged:(nullable NXMUser *)user loginStatus:(BOOL)isLoggedIn withError:(nullable NSError *)error;
```

if an error occured, isLoggedIn = false, and more details about the error are present in the error object.

### Logout
Logout using the nexmo client.  
**Swift**
```swift
client.logout()
```

**Objective-C**
```objective-c
[client logout];
```
**Note:**  At the end of a succesfull logout the loginstatuschanged method is called with isLoggedIn = false. If an error occured, isLoggedIn = true, and more details about the error are present in the error object.

### Get current user info
**Swift**
```swift
let user = client.user
```

**Objective-C**
```objective-c
NXMUser *user = client.user;
```
**Note:** this method returns nil if no user is currently logged in.
