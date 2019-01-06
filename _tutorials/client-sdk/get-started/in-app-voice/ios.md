---
title: Get Started - In App Voice 
Tutorial
products: client-sdk/in-app-voice/iOS
description: "This a tutorial to get started with Nexmo Client In App Voice calls on iOS"
languages:
    - objective-c
---

# Get Startred - In App Voice

In this tutorial you'll learn how to use Nexmo Client SDK for iOS, in order to perform an in-app (IP to IP) call.

You will create a simple app to make a call and recieve a call.

The app will have 2 buttons, which will login different users: Jane or Joe. After logging in, Jane and Joe will be able to place a call and perform actions such as answer, decline or hangup.

[//TODO: add gif]


## Before you begin

- Make sure you have [created a Nexmo Application.](/setup/generate-test-credentials)

- Make sure you have at least [*2 users* for that Nexmo Application, with valid *JWTs*](/setup/generate-test-credentials)

- [Add Nexmo SDK to your project.](/setup/add-sdk-to-you-app/ios)

- Clone this Github project [//TODO: add link]

---

Open `IAVAppDefine.h` class and swap the users IDs and tokens.

```objective-c
    #define kInAppVoiceJaneUserId @"JANE_USER_ID" //TODO: swap with a userId for Jane
    #define kInAppVoiceJaneToken @"JANE_TOKEN" //TODO: swap with a token for Jane
    #define kInAppVoiceJoeUserId @"JOE_USER_ID" //TODO: swap with a userId for Joe
    #define kInAppVoiceJoeToken @"JOE_TOKEN" //TODO: swap with a token for Joe
```

The `LoginViewController` holds two buttons for you to select which user should login. 

## 1. Login
Using the Nexmo SDK should start with a `NexmoClient` login, using a `jwt` user token.

On production apps, your server would authenticate the user, and would return to a `jwt` to the app. 
You can read more about generating the `jwt` [here]("https://developer.nexmo.com/stitch/concepts/jwt-acl").

For testing and getting started purposes, you can use the `jwt` generated for you on the dashboard. 

Open `MainViewController.m`. Explore the setup methods that were written for you on `viewDidLoad`.

Complete the `setupNexmoClient` method implementation:

```objective-c
- (void)setupNexmoClient {
    self.nexmoClient = [[NXMClient alloc] init];
    [self.nexmoClient setDelegate:self];
    [self.nexmoClient loginWithAuthToken:self.selectedUser.token];
}
```

Notice that `self` is set to be the delegate for `NXMClient`. Don't forget to adopt the `NXMClientDelegate` protocol and implement the required methods.

Add the required protocol adoption declaration to the class extension located in the `MainViewController.m` file. It should look like this:

```objective-c
@interface MainViewController () <NXMClientDelegate>
```

The `NXMClientDelegate` let you know among other things, if the login was succesfull and you can start using the sdk. 

Add the following methods under the `#pragma mark NXMClientDelegate` line.

```objective-c
#pragma mark NXMClientDelegate
- (void)connectionStatusChanged:(BOOL)isOnline {
    //Socket network status changed
}

- (void)loginStatusChanged:(nullable NXMUser *)user loginStatus:(BOOL)isLoggedIn withError:(nullable NSError *)error {
    if(error) {
        [self displayAlertWithTitle:@"Login Error" andMessage:@"Error performing login. Please make sure your credentials are valid and your device is connected to the internet"];
        
        return;
    }
    
    [self setWithIsConnected:YES];
}

- (void)tokenRefreshed {
    //User succesfully refreshed token.
}
```

At this point you should already be able to run the app and see that you can login succesfully with the sdk.

## 2. Start a Call

Let's start a simple In App call. 
If you're logged in as Jane, you will call Joe, and vice versa.

`Call Other` button press is connected to the `MainViewController`, in your behalf.
Go ahead and Implement the `didCallOtherButtonPress:` method to start a call. It should start the call, and also update the UIViews so that Jane or Joe know the call is in progress:

```objective-c
- (IBAction)didCallOtherButtonPress:(UIButton *)sender {
    self.isInCall = YES;
    [self.nexmoClient call:@[self.otherUser.userId] callType:NXMCallTypeInApp delegate:self completion:^(NSError * _Nullable error, NXMCall * _Nullable call) {
        if(error) {
            self.isInCall = NO;
            self.ongoingCall = nil;
            return;
        }
        self.ongoingCall = call;
        [self setActiveViews];
    }];
}
```

Pay attention that `NSArray` is initialized with `otherUser.userId`. In fact you can have multiple users participating in a call. However for our tutorial a simple 1 on 1 call should suffice.

As with `NXMClient`, `NXMCall` also receives a delegate which you supplied in  `call:callType:delegate:completion:` method.  

Implement the required methods for the `NXMCallDelegate` under the `#pragma mark NXMCallDelegate` line:


```objective-c
- (void)statusChanged:(NXMCallParticipant *)participant {
    if(![participant.userId isEqualToString:self.selectedUser.userId]) {
        return;
    }

    [self updateCallStatusLabelWithStatus:participant.status];

    if(participant.status == NXMParticipantStatusCancelled || participant.status == NXMParticipantStatusCompleted) {
        self.ongoingCall = nil;
        self.isInCall = NO;
        [self setActiveViews];
    }
}
```

`statusChanged:` method notifies on changes that happens to members on the call.

> *Note:*
While `NXMCallTypeInApp` is great for simple calls, you can also start a call with customized logic, defined by your backend (by an NCCO [//TODO add link] just as easy, by choosing `NXMCallTypeServer` as the callType.

```objective-c
[self.nexmoClient call:@[callees] callType:NXMCallTypeServer delegate:self completion:^(NSError * _Nullable error, NXMCall * _Nullable call){...}];
```

This will also allow you to start a phone (PSTN) call, by adding a phone number to the `callees` array. To read more about that, see here: [//TODO add link]


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
            [weakSelf setActiveViews];
            return;
        }
        
        [weakSelf setActiveViews];
    }];
}
```

`answer:completionHandler` accepts an object adopting the `NXMCallDelegate`, and a `completionHandler`, to let you know if an error occured in the process.  
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
        [weakSelf setActiveViews];
    }];
}
```

`decline:` accepts a single `completionHandler` parameter to let you know if an error occured in the process.


## 6. Hangup a call

Once Jane or Joe presses the big red button, it's time to hangup the call. 
Implement `didEndButtonPress:` method and call hangup for myCallMember.

```objective-c
    [self.ongoingCall.myCallMember hangup];
```
Remember that last `if` statment we added when receiving call participant statuses? when we hangup the status of our participant changes accordingly so we know we are no longer part of the call.
```objective-c
if(callMember.status == NXMCallMemberStatusCancelled || callMember.status == NXMPCallMemberStatusCompleted) {
        self.ongoingCall = nil;
        self.isInCall = NO;
        [self setActiveViews];
    }
```
>*Note:* to read more about call statuses, see here [//TODO]


## handle permissions

For the call to happen, `Audio Permissions` are required. We have added a request for audio permissions in the `appDelegate`, in the implemetation of `application:didFinishLaunchingWithOptions`.  
To read more about the permissions needed, read here [TODO]

---

#Congratulations!

You have implemented your first In App Voice application with the Nexmo Client SDK for iOS.