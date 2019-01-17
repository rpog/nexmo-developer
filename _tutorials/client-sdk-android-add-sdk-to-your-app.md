---
title: How to Add the Nexmo Client SDK to your Android App
products: client-sdk
description: This tutorial shows you how to add the Nexmo Client SDK to your Android application.
languages:
    - Java
---

# How to Add the Nexmo Client SDK to your Android App

Let's get started with Nexmo SDK on your Android app!

## Prerequisites

The SDK supports min Android API level 16.

## Add The SDK To Your Android Project

Open Android Studio with your Android project codebase.

### Add Dependencies

1. On your app level `build.gradle` file (usually `app/build.gradle`), add the sdk  dependency:

    ```groovy
    dependencies {
        implementation 'com.nexmo.android:client-sdk:0.7.26'
    }

    ```

2. On your project level `build.gradle` file, add the maven repository:

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

## Add Permissions

To use the in app voice features, you should add audio permissions:

1. On your `AndroidManifest.xml` add the required permissions:

    ```xml
    <manifest ...>

        <uses-permission android:name="android.permission.INTERNET" />
        <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
        <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
        <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />

        <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
        <uses-permission android:name="android.permission.RECORD_AUDIO" />
        <uses-permission android:name="android.permission.PROCESS_OUTGOING_CALLS" />
        <uses-permission android:name="android.permission.READ_PHONE_STATE" />

        <application>

        </>
    </>
    ```

2. For devices running Android version M (API level 23) or higher, you should add a request for the dangerous permissions required:

    ```java
    android.Manifest.permission.READ_PHONE_STATE, android.Manifest.permission.RECORD_AUDIO, android.Manifest.permission.PROCESS_OUTGOING_CALLS
    ```

    Read more about requesting runtime permissions on Android [here]("https://developer.android.com/training/permissions/requesting")

## Using NexmoClient On Your App

### Init NexmoClient

Before being able to use a `NexmoClient` instance, you should initialize it:

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

### Login NexmoClient

After initializing `NexmoClient`, you should log in to it, using a `jwt` user token. [in the topic on JWTs and ACLs](/client-sdk/concepts/jwt-acl).

Swap the token to log in the relevant user:

```java
    NexmoClient.get().login(token, loginListener)
```

After the login succeeds, the logged in user will be available via `NexmoClient.get().getUser()`.

## Conclusion

You added the Nexmo Client SDK to your Android app, initilized and logged in to a `NexmoClient` instance. You're all set to use `NexmoClient.get()` in your app, and utilize the NexmoClient SDK functionalities.
