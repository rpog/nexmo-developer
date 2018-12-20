---
title: Get Started - Add Nexmo Client SDK To Your Android App 
products: client-sdk/in-app-voice/in-app-messaging/android
description: "Setup required before getting started to use Nexmo Client SDK for Android"
languages:
    - android
---

# Get Started - Add Nexmo Client SDK To Your App

Let's get started with Nexmo SDK on your Android app! Here is all the details on how to set it up:

## Create a Nexmo Application

A [Nexmo application]("https://developer.nexmo.com/concepts/guides/applications") contains the required configuration for your project. You can create an application using the [Nexmo CLI]("https://github.com/Nexmo/nexmo-cli"), or via this [dashboard page]("ADD LINK").

## Create Nexmo Users

- Make sure you have at least 2 users for that Nexmo Application

## Create User Tokens (JWT)


## Add The SDK To Your Android App

### Add Dependencies

- On your project level `build.gradle` file 

- On your app level `build.gradle` file 


### Init NexmoClient

Before being able to use a NexmoClient instance, you should initialize it.


```java
 loginListener = object : NexmoLoginListener {
            override fun onLoginStateChange(eLoginState: NexmoLoginListener.ELoginState, eLoginStateReason: NexmoLoginListener.ELoginStateReason) {
                //TODO
            }

            override fun onAvailabilityChange(eAvailability: NexmoLoginListener.EAvailability, nexmoConnectionState: NexmoConnectionState) {
                //TODO
            }
        }
        NexmoClient.init(context, loginListener)
```

`onLoginStateChange()` recieve updates on the login and authentication state of the user.
While `onAvailabilityChange()` recieves updates on the connectivity status to the SDK. 

### Login NexmoClient

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

## What's next? 
After these steps you are ready to use the Nexmo SDK functionalities.
Feel free to explore them.