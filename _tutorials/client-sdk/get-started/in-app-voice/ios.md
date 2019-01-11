---
title: Get Started - In App Voice 
Tutorial
products: client-sdk/in-app-voice/iOS
description: "This a tutorial to get started with Nexmo Client In App Voice calls on iOS"
languages:
    - objective-c
---

# Get Started - In App Voice

In this tutorial you'll learn how to use Nexmo Client SDK for iOS, in order to perform an in-app (IP to IP) call.

You will create a simple app to make a call and receive a call.

The app will have 2 buttons, which will login different users: Jane or Joe. After logging in, Jane and Joe will be able to place a call and perform actions such as answer, decline or hangup.

---

## Before you begin

- Make sure you have [created a Nexmo Application.](/setup/generate-test-credentials)

- Make sure you have at least [*2 users* for that Nexmo Application, with valid *JWTs*](/setup/generate-test-credentials)

- [Add Nexmo SDK to your project](/setup/add-sdk-to-you-app/ios)

- [Clone this Github project](https://github.com/Nexmo/Client-Get-Started-InApp-Voice-ObjectiveC)

- On the Github project you cloned, on the Stater app, with XCode:
    
1. Open `IAVAppDefine.h` file and swap the users IDs and tokens:

```objective-c
    #define kInAppVoiceJaneUserId @"JANE_USER_ID" //TODO: swap with a userId for Jane
    #define kInAppVoiceJaneToken @"JANE_TOKEN" //TODO: swap with a token for Jane
    #define kInAppVoiceJoeUserId @"JOE_USER_ID" //TODO: swap with a userId for Joe
    #define kInAppVoiceJoeToken @"JOE_TOKEN" //TODO: swap with a token for Joe
```

2. Open `MainViewController.m` file and make sure the following lines exist:

    * `#import <NexmoClient/NexmoClient.h>` - imports the sdk

    * `@property NXMClient *nexmoClient;` - property for the client instance

    * `@property NXMCall *ongoingCall;` - property for the call instance

---

## 1. Login

Using the Nexmo SDK should start with logging in to `NexmoClient`, using a `jwt` user token.

On production apps, your server would authenticate the user, and would return to the app a [`jwt` with the configurations that fit.](https://developer.nexmo.com/stitch/concepts/jwt-acl).

For testing and getting started purposes, you can [use the Nexmo CLI to generate `jwt`s.](/setup/generate-test-credentials)

Open `MainViewController.m`. Explore the setup methods that were written for you on `viewDidLoad`.

Now locate the following line `#pragma mark - Tutorial Methods` and complete the `setupNexmoClient` method implementation:

```objective-c
- (void)setupNexmoClient {
    self.nexmoClient = [[NXMClient alloc] initWithToken:self.selectedUser.token];
    [self.nexmoClient setDelegate:self];
    [self.nexmoClient login];
}
```

Notice that `self` is set to be the delegate for `NXMClient`. Don't forget to adopt the `NXMClientDelegate` protocol and implement the required methods.

Add the required protocol adoption declaration to the class extension located in the `MainViewController.m` file.  
It should look like this:

```objective-c
@interface MainViewController () <NXMClientDelegate>
```

The `NXMClientDelegate` let you know among other things, if the login was succesful and you can start using the sdk.

Add the following method under the `#pragma mark NXMClientDelegate` line.

```objective-c
- (void)connectionStatusChanged:(NXMConnectionStatus)status reason:(NXMConnectionStatusReason)reason {
    [self setWithConnectionStatus:status];
}
```

At this point you should already be able to run the app and see that you can login successfully with the sdk.

## 2. Start a Call

Let's start a simple In App call. 
If you're logged in as Jane, you will call Joe, and vice versa.

`Call Other` button press is already connected to the `MainViewController`.
Go ahead and Implement the `didCallOtherButtonPress:` method to start a call. It should start the call, and also update the UIViews so that Jane or Joe know the call is in progress:

```objective-c
- (IBAction)didCallOtherButtonPress:(UIButton *)sender {
    self.isInCall = YES;
    [self.nexmoClient call:@[self.otherUser.userId] callType:NXMCallTypeInApp delegate:self completion:^(NSError * _Nullable error, NXMCall * _Nullable call) {
        if(error) {
            self.isInCall = NO;
            self.ongoingCall = nil;
            [self updateCallStatusLabelWithText:@""];
            return;
        }
        self.ongoingCall = call;
        [self setActiveViews];
    }];
}
```

Pay attention that `NSArray` is initialized with `otherUser.userId`. In fact you can have multiple users in a call. However for our tutorial a simple 1 on 1 call should suffice.

As with `NXMClient`, `NXMCall` also receives a delegate which you supplied in  `call:callType:delegate:completion:` method.  
Adopt the `NXMCallDelegate`.  Your extension declaration should look like this:
```objective-c
@interface MainViewController () <NXMClientDelegate, NXMCallDelegate>

```

Copy the following Implementation for the `statusChanged` method of the `NXMCallDelegate` along with the aid methods under the `#pragma mark NXMCallDelegate` line:


```objective-c
- (void)statusChanged:(NXMCallMember *)callMember {
    if([callMember.userId isEqualToString:self.selectedUser.userId]) {
        [self statusChangedForMyMember:callMember];
    } else {
        [self statusChangedForOtherMember:callMember];
    }
}

- (void)statusChangedForMyMember:(NXMCallMember *)myMember {
    [self updateCallStatusLabelWithStatus:myMember.status];
    
    //Handle Hangup

}

- (void)statusChangedForOtherMember:(NXMCallMember *)otherMember {

}
```

`statusChanged:` method notifies on changes that happens to members on the call.  
`statusChangedForOtherMember` and `statusChangedForMyMember` will be updated later when you'll handle call hangup

You can build the project now and make an outgoing call. Next you will implement receiving an incoming call.

> *Note:*
While `NXMCallTypeInApp` is great for simple calls, you can also start a call with customized logic, defined by your backend ([using an NCCO](https://developer.nexmo.com/client-sdk/in-app-voice/guides/ncco-guide) ) just as easy, by choosing `NXMCallTypeServer` as the callType.
>    ```objective-c
>    [self.nexmoClient call:@[callees] callType:NXMCallTypeServer delegate:self completion:^(NSError * _Nullable error, NXMCall * _Nullable call){...}];
>    ```
>This will also allow you to start a phone (PSTN) call, by adding a phone number to the `callees` array.

## 3. Receive incoming call

When Jane calls Joe, Joe should be notified about it, for example, in order to answer or decline the call.

This is done by implementing the optional `incomingCall:` method which is declared in the `NXMClientDelegate`.

Go back to the `#pragma mark NXMClientDelegate` line and add the `incomingCall:' method

```objective-c
- (void)incomingCall:(nonnull NXMCall *)call {
    self.ongoingCall = call;
    [self displayIncomingCallAlert];
}
```

This method takes as a parameter an `NXMCall` object with which you can answer or decline the call.
An alert was implemented for you, to allow the user to choose whether to answer or decline the call.

## 4. Answer a call

Under the `#pragma mark IncomingCall`, implement this method to answer the incoming call:

```objective-c
- (void)didPressAnswerIncomingCall {
    __weak MainViewController *weakSelf = self;
    [weakSelf.ongoingCall answer:self completionHandler:^(NSError * _Nullable error) {
        if(error) {
            [weakSelf displayAlertWithTitle:@"Answer Call" andMessage:@"Error answering call"];
            weakSelf.ongoingCall = nil;
            weakSelf.isInCall = NO;
            [self updateCallStatusLabelWithText:@""];
            [weakSelf setActiveViews];
            return;
        }
        self.isInCall = YES;
        [weakSelf setActiveViews];
    }];
}
```

`answer:completionHandler` accepts an object adopting the `NXMCallDelegate`, and a `completionHandler`, to let you know if an error occurred in the process.  
You already implemented `NXMCallDelegate` on a previous step.

## 5. Decline a call

Similarily, under the `#pragma mark IncomingCall`, implement this method to decline the incoming call:

```objective-c
- (void)didPressDeclineIncomingCall {
    __weak MainViewController *weakSelf = self;
    [weakSelf.ongoingCall decline:^(NSError * _Nullable error) {
        if(error) {
            [weakSelf displayAlertWithTitle:@"Decline Call" andMessage:@"Error declining call"];
            return;
        }

        weakSelf.ongoingCall = nil;
        weakSelf.isInCall = NO;
        [self updateCallStatusLabelWithText:@""];
        [weakSelf setActiveViews];
    }];
}
```

`decline:` accepts a single `completionHandler` parameter to let you know if an error occurred in the process.


## 6. Hangup a call

Once Jane or Joe presses the big red button, it's time to hangup the call. 
Implement `didEndButtonPress:` method and call hangup for myCallMember.

```objective-c
    [self.ongoingCall.myCallMember hangup];
```

Updates for callMember statuses are received in `statusChanged` as part of the `NXMCallDelegate` as you've seen before.  
Update the implementation for `statusChangedForOtherMember` and `statusChangedForMyMember` to handle call hangup.
```objective-c
- (void)statusChangedForMyMember:(NXMCallMember *)myMember {
    [self updateCallStatusLabelWithStatus:myMember.status];
    
    //Handle Hangup
    if(myMember.status == NXMCallMemberStatusCancelled || myMember.status == NXMCallMemberStatusCompleted) {
        self.ongoingCall = nil;
        self.isInCall = NO;
        [self updateCallStatusLabelWithText:@""];
        [self setActiveViews];
    }
}

- (void)statusChangedForOtherMember:(NXMCallMember *)otherMember {
    if(otherMember.status == NXMCallMemberStatusCancelled || otherMember.status == NXMCallMemberStatusCompleted) {
        [self.ongoingCall.myCallMember hangup];
    }
}
```

## handle permissions

For the call to happen, `Audio Permissions` are required. On the `appDelegate` of the sample project, you can find an implementation for the permissions request on `application:didFinishLaunchingWithOptions`.  
To read more about the permissions needed, [see here.](_documentation/client-sdk/setup/add-sdk-to-your-app/ios#Add-Permissions)

---

## Congratulations!

You have implemented your first In App Voice application with the Nexmo Client SDK for iOS.  
Run the app on two simulators and see that you can call, answer, decline and hangup.  
Better yet, run it on a couple of phones using your developer signing and provisioning and start talking!
