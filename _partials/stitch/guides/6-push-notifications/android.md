---
title: Android
platform: android
---

# Showing Push Notifications from Stitch in your Android app

The Nexmo Stitch SDK for Android offers the feature of showing push notifications when an event is fired in a conversation. You can get a notification for the following events:

- The logged in user is invited to a conversation.
- The logged in user is invited to an audio enabled conversation.
- A Text Event is sent to a conversation the logged in user is a part of.
- An image is sent to a conversation the logged in user is a part of.

## Prerequisites

To receive push notifications, you'll have to set up your project with [Firebase Cloud Messaging (FCM)](https://firebase.google.com/docs/cloud-messaging/). You can do so by following their setup instructions for [Adding Firebase to Your Android Project](https://firebase.google.com/docs/android/setup). After FCM is added to the project we'll continue in the ["//TODO"](//TODO$LINK) section.

## Firebase

### Add Firebase Cloud Messaging dependencies to the app

Add This to `build.gradle`

```groovy
//build.gradle
  dependencies {
    ...
    classpath 'com.google.gms:google-services:4.0.0'
  }
```

and this to `app/build.gradle`

```groovy
//app/build.gradle

dependencies {
  ...
  implementation 'com.google.firebase:firebase-messaging:17.3.0'
}

// ADD THIS AT THE BOTTOM
apply plugin: 'com.google.gms.google-services'
```

Ensure you downloaded a [`google-services.json` file](https://support.google.com/firebase/answer/7015592) and placed it in your in your project's module folder, typically `app/`.

### Firebase services

#### `FirebaseMessagingService`

Note that the firebase docs recommend that you use `FirebaseMessagingService` instead of `FirebaseInstanceIdService` as the latter [is deprecated](https://firebase.google.com/docs/reference/android/com/google/firebase/iid/FirebaseInstanceIdService). The rest of this tutorial will use the `FirebaseMessagingService`.

When a new token is fetched from `FirebaseMessagingService`, the token needs to be passed to the `conversationClient`. We can do that by creating a new instance of the `FirebaseMessagingService` and overriding `onNewToken()`.

```java
class StitchFirebaseMessagingService : FirebaseMessagingService() {
    val TAG = "Messaging Service: "
    val conversationClient = Stitch.getInstance(this.applicationContext).client

    override fun onNewToken(p0: String?) {
        super.onNewToken(p0)
        Log.d(TAG, "Refreshed token: $p0")
        conversationClient.pushDeviceToken = p0
    }
}
```

#### BroadcastReceiver

The Stitch API will send push notifications to users' devices when there's an incoming image, invitation, or text event. The Push Notifications can be handled subclassing a `BroadcastReceiver`. We'll need to override `onReceive()` and inspect the contents of the incoming `bundle` within the `intent`. The `PushNotification` class within the SDK contains several constants we can use to determine the type of incoming Push Notification.

```java
const val NOTIFICATION_CHANNEL_ID = "misc"
const val NOTIFICATION_CHANNEL_NAME = "Miscellaneous"
const val NOTIFICATION_ID = 1

class StitchPushReceiver : BroadcastReceiver() {
    private val TAG = StitchPushReceiver::class.java.simpleName

    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d(TAG, "onReceive")
        val bundle = intent?.extras

        if (context != null && bundle != null
                && intent.action == PushNotification.CONVERSATION_PUSH_ACTION
                && bundle.containsKey(PushNotification.CONVERSATION_PUSH_TYPE)) {

            handlePush(bundle, context) 
        }
    }

    private fun handlePush(bundle: Bundle?, context: Context) {
        val type = bundle?.getString(PushNotification.CONVERSATION_PUSH_TYPE)
        when(type) {
            PushNotification.ACTION_TYPE_IMAGE -> handleImage(bundle, context)
            PushNotification.ACTION_TYPE_TEXT -> handleText(bundle, context)
            PushNotification.ACTION_TYPE_INVITE -> handleInvite(bundle, context)
            else -> { throw IllegalArgumentException("unhandled push notification type") }
        }
    }
}
```

Now that we're able to determine the event that sent the Push Notification, we can deserialize the `bundle` the `BroadcastReceiver` has received. Note that we have to do a bit of manual deserialization for incoming invitations since `Invitation` doesn't inherit from `Event` nor implement `Parcelable`. Thus, we'll create a `data class PushInvitation` at the bottom of the `StitchPushReceiver.kt` file.

The `showNotification()` method is responsible for delivering the notification to the user's device. In this method, the notification will be constructed. If the device is running Oreo or later, we can also include the [notification channel](https://developer.android.com/training/notify-user/channels).

```java

class StitchPushReceiver : BroadcastReceiver() {
    //...continued from above...

    private fun handleInvite(bundle: Bundle, context: Context) {
        val invitation = PushInvitation(
                senderMemberId = bundle.getString(PushNotification.ACTION_TYPE_INVITED_BY_MEMBER_ID),
                conversationName = bundle.getString(PushNotification.ACTION_TYPE_INVITE_CONVERSATION_NAME),
                senderUsername = bundle.getString(PushNotification.ACTION_TYPE_INVITED_BY_USERNAME),
                invitedMember = bundle.getParcelable(Member::class.java.simpleName),
                conversationId = bundle.getString(PushNotification.ACTION_TYPE_INVITE_CONVERSATION_ID)
        )
        showNotification(context, "Invitation from ${invitation.senderUsername} to ${invitation.conversationName}")
    }

    private fun handleText(bundle: Bundle, context: Context){
        val text = bundle.getParcelable(Text::class.java.simpleName) as Text
        showNotification(context, "${text.member.name}: ${text.text}")
    }

    private fun handleImage(bundle: Bundle, context: Context) {
        val image = bundle.getParcelable(Image::class.java.simpleName) as Image
        showNotification(context, "New image from ${image.member.name}")
    }

    private fun showNotification(context: Context, payload: String) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val notificationBuilder = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID).apply {
                setContentTitle("Nexmo Stitch Notification")
                //max characters for a push notification is 4KB or about 1000 characters
                setContentText(payload.substring(0, Math.min(1000, payload.length)))
                setAutoCancel(true)
                setVibrate(longArrayOf(0, 100, 100, 100, 100, 100))
                setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
                setSmallIcon(R.drawable.ic_send_black_24dp)
        }

        //On Android versions starting with Oreo (SDK version 26), any local notification your app is trying to build needs to be attached to a NotificationChannel
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = NotificationChannel(NOTIFICATION_CHANNEL_ID,
                    NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT)
            notificationManager.createNotificationChannel(notificationChannel)
        }
        // Build and issue the notification. All pending notifications with same id will be canceled.
        notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build())
    }
}

data class PushInvitation constructor(val senderMemberId: String, val conversationName: String,
                                      val senderUsername: String, val invitedMember: Member, val conversationId: String)
```

#### `AndroidManifest`

Don't forget to register the `StitchFirebaseMessagingService` and `StitchPushReceiver` in the `AndroidManifest`. You'll also need to include the required permissions.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.nexmo.push_notifications">

    <!-- Needed for Stitch SDK -->
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- Needed for Push Notification features -->
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

   <application
     ...>

        <service android:name=".utils.StitchFirebaseMessagingService">
            <intent-filter>
                <action android:name="com.google.firebase.INSTANCE_ID_EVENT" />
            </intent-filter>
        </service>

        <receiver android:name=".utils.StitchPushReceiver">
            <intent-filter>
                <action android:name="com.nexmo.sdk.conversation.PUSH" />
                <category android:name="com.nexmo.conversation.test" />
            </intent-filter>
        </receiver>

  </application>
```

### Provision your server key with Nexmo Stitch

For this next step we'll need three things. The server key from Firebase, your Nexmo application's ID, and a JWT without a `sub` field- we'll call that your _application token_. We're going to provision your Firebase server key to the Nexmo Stitch API, using your application ID as an identifier and the application token for authentication. First, retrieve your Firebase server key from the [Firebase console](https://console.firebase.google.com/) and click on the project you created, or create a new one if you haven't. Then continue with these steps:

1. click the settings icon/cog wheel next to your project name at the top of the new Firebase Console
2. Click <kbd>Project settings</kbd>
3. Click on the <kbd>Cloud Messaging</kbd> tab
4. The key is right under <kbd>Server Key</kbd>

Let's go to our terminal and store that Firebase server key as a bash variable:

```sh
$ FIREBASE_SERVER_KEY=AAAA...........
```

Now that we have our server key, we can retrieve our Nexmo Application ID from the [Nexmo Dashboard](https://dashboard.nexmo.com/voice/your-applications) or by using the [Nexmo CLI](https://github.com/Nexmo/nexmo-cli#applications).

```sh
$ nexmo apps:list
```

Alternatively, you can create a new application [follow steps in quickstart 1](//TODO$LINK).

We'll also store the Application ID as a bash variable:

```sh
$ APPLICATION_ID=aaaaaaaa-bbbb-cccc-dddd-0123456789ab
```

Finally, using our application ID and and private.key that was generated when we first created the Nexmo Application, we can create the application token. You should navigate to the directory the `private.key` file is in and then run the following command:

```sh
$ APPLICATION_TOKEN=$(nexmo jwt:generate private.key application_id=$APPLICATION_ID)
$ echo $APPLICATION_TOKEN
```

After you've successfully ran the command. Verify for yourself that the JWT generated is correct. You can visit [jwt.io](jwt.io) and paste in your the output of `APPLICATION_TOKEN`. Make sure that the payload has the `application_id` property.

What we've done is create a master JWT that has access to all endpoints for your Nexmo application. Don't share this JWT! We're going to use this JWT to authenticate your request to the Nexmo API endpoint to upload your Firebase server key.

The final set up step is to upload the Firebase server key. Assuming that you still have the previous bash variables in your session you can run the following command:

```sh
curl -v -X PUT \
   -H "Authorization: Bearer $APPLICATION_TOKEN" \
   -H "Content-Type: application/json" \
   -d "{\"token\":\"$FIREBASE_SERVER_KEY\"}" \
   https://api.nexmo.com/v1/applications/$APPLICATION_ID/push_tokens/android
```

If you see `HTTP/2 200` in the response from the curl request then your Firebase server key was successfully uploaded!

## LoginActivity

When a user logs in to the SDK's `ConversationClient`, we'll register the push device token from Firebase and enable push notifications on this device.

```java
    private void registerPushNotifications() {
        //replace with ?
        /*
        FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener( MyActivity.this,  new OnSuccessListener<InstanceIdResult>() {
             @Override
             public void onSuccess(InstanceIdResult instanceIdResult) {
                   String newToken = instanceIdResult.getToken();
                   Log.e("newToken",newToken);

             }
         });
         */
        if (!TextUtils.isEmpty(FirebaseInstanceId.getInstance().getToken())) {
            Log.d(TAG, "Firebase " + FirebaseInstanceId.getInstance().getToken() + " token");

            conversationClient.setPushDeviceToken(FirebaseInstanceId.getInstance().getToken());
            conversationClient.enableAllPushNotifications(true, new RequestHandler<Void>() {
                @Override
                public void onSuccess(Void result) {
                    logAndShow("push enabled!");
                }
                @Override
                public void onError(NexmoAPIError error) {
                    logAndShow("Error with push" + error.getMessage());
                }
            });

        } else {
            Log.d(TAG, "FCM not registered yet");
        }
    }
```


## Try it out
