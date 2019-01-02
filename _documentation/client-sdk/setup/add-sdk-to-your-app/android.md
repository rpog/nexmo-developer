---
title: Add Nexmo Client SDK To Your Android App 
---

# Get Started - Add Nexmo Client SDK To Your App

Let's get started with Nexmo SDK on your Android app! Here are all the details on how to set that up:

## Create a Nexmo Application

A [Nexmo application]("https://developer.nexmo.com/concepts/guides/applications") contains the required configuration for your project. You can create an application using the [Nexmo CLI]("https://github.com/Nexmo/nexmo-cli"), or via this [generator webpage]("ADD LINK").

## Create Nexmo Users

- Make sure you have at least 2 users for that Nexmo Application

## Create User Tokens (JWT)

---

## Add The SDK To Your Android App

Open Android Studio with your Android project codebase

### Add Dependencies

- On your app level `build.gradle` file (usually `app/build.gradle`), add the sdk  dependency:

```groovy

dependencies {
    implementation 'com.nexmo.android:client-sdk:0.6.11'
}

```

- On your project level `build.gradle` file, add the maven repository

```groovy

buildscript {
    repositories {
        maven {
            url "https://artifactory.ess-dev.com/artifactory/gradle-dev-local"
        }
    }
    //...
}

allprojects {
    repositories {
        ...
        maven {
            url "https://artifactory.ess-dev.com/artifactory/gradle-dev-local"
        }
    }
}

```

### Add Permissions

On your `AndroidManifest.xml` add the required permissions:

```xml
 <manifest ...>

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.PROCESS_OUTGOING_CALLS" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />

    <application>
    ...
    </>
 </>
```

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

`onLoginStateChange()` receives updates on the login and authentication status of the user.
While `onAvailabilityChange()` receives updates on the connectivity status to the SDK's functionality.

### Login NexmoClient

After initialzing `NexmoClient`, you should log in to it, using a `jwt` user token.

On production apps, your server would authenticate the user, and would return to a `jwt` to the app.
You can read more about generating the `jwt` [here](_documentation/client-sdk/concepts/kwt-acl).

For testing and onboarding, you can use the `jwt` generated for you on the dashboard.

Swap the token to log in the relevant user.

```java
    NexmoClient.get().login(token, loginListener)
```

After the login succeeds, the logged in user will be available via `NexmoClient.get().getUser()`.

---

Congratulations! you're all set.

## What's next?

After these steps you are ready to use the Nexmo SDK functionalities.
Feel free to explore them.
