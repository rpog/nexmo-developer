---
title: Get Started - Calls 
Tutorial
products: client-sdk/in-app-voice/android
description: "This is a test."
languages:
    - android
---

# Get Startred - Push Notifications

On incoming events, such as when a user recieves a new message, or an incoming call, the user often expects to recieve a push notification.
This guide will explain how to set them up:

## Before you begin

- [Set up a Firebase Cloud Messaging client app on Android]("https://firebase.google.com/docs/cloud-messaging/android/client")



1. In case you haven't, add Firebase to your Android app codebase. More details can be found at the official Firebase documentation, on [this link]("https://firebase.google.com/docs/android/setup").


2. On your app level `build.gradle` file (usually `app/build.gradle`), add the `firebase-messaging` dependency.

Swap `x.y.z` with the latest Cloud Massaging versions number, which can be found [on Firebase website]("https://firebase.google.com/support/release-notes/android")

```groovy
dependencies{
    implementation 'com.google.firebase:firebase-messaging:x.y.z'
}
```

3. On your `AndroidManifest.xml`, add a decleration of a service that extends `FirebaseMessagingService`

```xml
<service android:name=".MyFirebaseMessagingService">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```

4. On your 

```java
/**
 * Called if InstanceID token is updated. This may occur if the security of
 * the previous token had been compromised. Note that this is called when the InstanceID token
 * is initially generated so this is where you would retrieve the token.
 */
@Override
public void onNewToken(String token) {
    Log.d(TAG, "Refreshed token: " + token);

    // If you want to send messages to this application instance or
    // manage this apps subscriptions on the server side, send the
    // Instance ID token to your app server.
    sendRegistrationToServer(token);
}
MyFirebaseMessagingService.java

```

## register a new token

```java

override fun onNewToken(token: String?) {
        token?.let {
            NexmoManager.get().nexmoClient.enablePushNotifications(token, object : NexmoRequestListener<Void> {
                override fun onError(nexmoError: NexmoApiError?) {
                    Log.d(TAG, "$TAG:sendRegistrationToServer:onError() with: $nexmoError")
                }

                override fun onSuccess(void: Void?) {
                    Log.d(TAG, "$TAG:sendRegistrationToServer:onSuccess()")
                }
            })
        }
    }

```





## new message

### is push notification?

NexmoClient.isCommsPushNotification(RemoteMessage.data)


NexmoClient.get().processPushNotification(message.data, listener)


```java
override fun onMessageReceived(message: RemoteMessage?) {
        if (NexmoClient.isCommsPushNotification(message!!.data)) {
//            handleNexmoPushForLoggedInUser(message)
            NexmoClient.get().login("XXX", object : NexmoRequestListener<NexmoUser> {
                override fun onSuccess(p0: NexmoUser?) {
                    NexmoClient.get().processPushNotification(message.data, this@`TestAppMessagingService-copy`)
                }

                override fun onError(p0: NexmoApiError?) {
                    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                }

            })
        }
    }
```