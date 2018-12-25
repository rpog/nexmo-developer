---
title: Get Started - Calls 
Tutorial
products: client-sdk/in-app-voice/android
description: "This is a test."
languages:
    - android
---

# Get Startred - Calls

In this tutorial you'll learn how to use Nexmo Client SDK for Android, in order to perform an in-app call.

You will create a simple app that can call and recieve calls.

The app will have 2 buttons, to login as 2 different users: Jane and Joe. After logging in, the user can call the other user, or to call a pstn number.

[//TODO: add gif]


## Before you begin

- Make sure you have created a Nexmo Application.

- Make sure you have at least 2 users for that Nexmo Application

- Add Nexmo SDK to your project.

---
*Note * you can clopne the sample project from github, that has most of the boilerplate code prepared. 


## 1. Login
Using the Nexmo SDK should start with logging in to `NexmoClient`, using a `jwt` user token.

On production apps, your server would authenticate the user, and would return to a `jwt` to the app. 
You can read more about generating the `jwt` [here]("https://developer.nexmo.com/stitch/concepts/jwt-acl").

For testing and getting started purposes, you can use the `jwt` generated for you on the dashboard. 

Swap the token to log in the relevant user.

```java
    NexmoClient.get().login(token, loginListener)
```

When the login succeeds, `loginListener.onSucceed()` will be called, with the logged in User. You can save a reference to it in order to access it later on. 

```java
loginListener = new NexmoRequestListener<NexmoUser>() {
            @Override
            public void onError(NexmoApiError nexmoApiError) {
                // handle login error
            }

            @Override
            public void onSuccess(NexmoUser user) {
                // handle 'user' login success
            }
        });
```



## 2. Call
To start a call, simply use the method `NexmoClient.call(callees)`

### Starting an in-app call

If you logged in as Jane, we can start an in-app call to Joe, and vice versa:

```java
    ArrayList<String> callees = new ArrayList();
    callees.add(otherUserId);

    NexmoClient.get().call(callees);
```

### Starting a phone call

You can also start a phone (pstn) call just as easy, by adding the phone number to the `callees` list.

**Note** on your backend, there is some work you should do to support that. see here for more info.["TODO"]

```java
    ArrayList<String> callees = new ArrayList();
    callees.add(phoneNumber);

    NexmoClient.get().call(callees);
```

## 3. Register to incoming events

When Jane calls Joe, Joe should be notified about it, for example, in order to answer the call.

Joe registers to incoming events, and implements `onIncomingCall()`.
Whenever Joe is called - this method will be called, with the Call object

```java
public static NexmoIncomingCallListener incomingCallListener = new NexmoIncomingCallListener() {
        @Override
        public void onIncomingCall(NexmoCall call) {
            currentCall = call;
            appContext.startActivity(new Intent(appContext, IncomingCallActivity.class));
            
        }
    };
```

## 4. Answer a call
Once a Joe recieves the incoming call, answering is as simple as:


## register to call status

When B answered the call, we want B to know about it. Register to callEvents:
To read more about call statuses

## Hangup
Call.hangup()
