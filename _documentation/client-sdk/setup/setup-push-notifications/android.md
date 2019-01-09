---
title: Setup Nexmo Push Notifications On Android
---

# Get Started - Push Notifications

On incoming events, such as when a user receives a new message, or an incoming call, the user often expects to receive a push notification, if the app isn't active.
This guide will explain how to configure your Android app to receive push notifications from Nexmo Client SDK.

## 1. Setup Firebase project for your app

In case you haven't done that for your Android app, add Firebase to your Android app codebase.
More details can be found at the official Firebase documentation, on [this link]("https://firebase.google.com/docs/android/setup").

## 2. Provision your server key

2.1. Obtain a `jwt_dev`, which is a `jwt` without a `sub` claim. More details can be found [here](/setup/generate-test-credentials#3.-Generate-a-User-JWT).

2.2. Get your `server_api_key` from Firebase console:

On firebase console --> project settings --> CloudMessaging Tab --> `Server key`

2.3. Get your `app_id` from Nexmo Dashboard[TODO]

2.4. Run the following curl command, while replacing `jwt_dev`, `server_api_key`, `app_id` with your own:

```sh

curl -v -X PUT \
   -H "Authorization: Bearer $jwt_dev" \
   -H "Content-Type: application/json" \
   -d "{\"token\":\"$server_api_key\"}" \
   https://api.nexmo.com/v1/applications/$app_id/push_tokens/android

```

## 3. Add Firebase Cloud Messaging to your Android project

On Android Studio, on your app level `build.gradle` file (usually `app/build.gradle`), add the `firebase-messaging` dependency.

Swap `x.y.z` with the latest Cloud Massaging versions number, which can be found [on Firebase website]("https://firebase.google.com/support/release-notes/android")

```groovy
dependencies{
    implementation 'com.google.firebase:firebase-messaging:x.y.z'
}
```

## 4. Implement a Service to receive push notifications

If you don't have one already, create a service that extends `FirebaseMessagingService`. 
Make sure your service is declared on your `AndroidManifest.xml`:

```xml
<service android:name=".MyFirebaseMessagingService">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```

## 5. Enable Nexmo server to send push notifications to your device

```java
// On MyFirebaseMessagingService.kt

override fun onNewToken(token: String?) {
    token?.let {
        NexmoClient.get().enablePushNotifications(token, requestListener)
    }
}

```

## 6. Receive push notifications

Push notifications are received on your implementation of `MyFirebaseMessagingService`, on `onMessageReceived()` method.

You can use `NexmoClient.isNexmoPushNotification(message.data))` to realize whether the message is sent from Nexmo server.

Use `NexmoClient.get().processPushNotification(message.data, listener)` to process the data received from FCM into an easy to use Nexmo object.


For example, on your `MyFirebaseMessagingService`:

```java
 val pushEventListener = object : NexmoPushEventListener {
        override fun onIncomingCall(p0: NexmoCall?, p1: MemberEvent?) {
            TODO("not implemented")
        }

        override fun onNewEvent(p0: NexmoEvent?) {
            TODO("not implemented")
        }

        override fun onError(p0: NexmoApiError?) {
            TODO("not implemented")
        }
    }

    override fun onMessageReceived(message: RemoteMessage?) {
        message?.data?.let {
            if (NexmoClient.isCommsPushNotification(message.data)) {
                NexmoClient.get().processPushNotification(message.data, pushEventListener)
            }

        }
    }

```
