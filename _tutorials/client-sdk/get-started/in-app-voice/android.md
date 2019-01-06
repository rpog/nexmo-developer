---
title: Get Started - In App Voice 
Tutorial
products: client-sdk/in-app-voice/android
description: "This a tutorial to get started with Nexmo Client In App Voice calls on Android"
languages:
    - android
---

# Get Startred - In App Voice

In this tutorial you'll learn how to use Nexmo Client SDK for Android, in order to perform an in-app (IP to IP) call.

You will create a simple app that can call and recieve calls.

The app will have 2 buttons, to login as 2 different users: Jane and Joe. After logging in, the user can call the other user, or to call a pstn (phone) number.

[//TODO: add gif]


## Before you begin

- Make sure you have [created a Nexmo Application.](/setup/generate-test-credentials)

- Make sure you have at least [*2 users* for that Nexmo Application, with valid *JWTs*](/setup/generate-test-credentials)

- Add Nexmo SDK to your project. [//TODO: add link?]

- Clone this Github project [//TODO: add link]

---

Open `NexmoHelper` class and swap the users ID and tokens.

```java
    String USER_ID_JANE = "USR-XXX"; //TODO: swap with the UserId you generated for Jane
    String USER_ID_JOE = "USR-XXX"; //TODO: swap with the UserId you generated for Jane
    String JWT_JANE = "PLACEHOLDER";//TODO: swap with the JWT you generated for Jane
    String JWT_JOE = "PLACEHOLDER"; //TODO: swap with the JWT you generated for Joe
```

## 1. Login
Using the Nexmo SDK should start with logging in to `NexmoClient`, using a `jwt` user token.

On production apps, your server would authenticate the user, and would return to a `jwt` to the app. 
You can read more about generating the `jwt` [here]("https://developer.nexmo.com/stitch/concepts/jwt-acl").

For testing and getting started purposes, you can use the `jwt` generated for you on the dashboard. 

Open `LoginActivity`. It already has 2 button handlers:`onLoginJaneClick(...)` and `onLoginJoeClick(...)`. 
Each calls the `loginToSdk(...)` method, with a diffrent parameter - the corresponding `jwt`.
When the login is successful, the logged in `NexmoUser` returns. 
For convenience, save a reference to `NexmoUser` on `NexmoHelper`, and then, start `CreateCallActivity`.

Complete the `loginToSdk()` method implementation:

```java
   void loginToSdk(String token) {
        NexmoClient.get().login(token, new NexmoRequestListener<NexmoUser>() {

            @Override
            public void onError(NexmoApiError nexmoApiError) {}

            @Override
            public void onSuccess(NexmoUser user) {
                NexmoHelper.user = user;

                Intent intent = new Intent(getBaseContext(), CreateCallActivity.class);
                startActivity(intent);
                finish();
            }
        });
    }
```


## 2. Start a Call

Let's start a simple In App call. 
If you logged in as Jane, you will call Joe, and vice versa.

Open `CreateCallActivity` and complete the prepared `onInAppCallClick()` handler:

```java
public void onInAppCallClick(View view) {
    List<String> callee = new ArrayList<>();
    callee.add(getOtherUserName());

    NexmoClient.get().call(callee, NexmoCallHandler.IN_APP, callListener);
}

String getOtherUserName() {
    return NexmoHelper.user.getName().equals(NexmoHelper.USER_NAME_JANE) ? NexmoHelper.USER_NAME_JOE : NexmoHelper.USER_NAME_JANE;
}
```

When the call creation is successful, save the `NexmoCall` on `NexmoHelper`, for convenience, and start `OnCallActivity`.

```java
NexmoRequestListener<NexmoCall> callListener = new NexmoRequestListener<NexmoCall>() {
        @Override
        public void onError(NexmoApiError nexmoApiError) { }

        @Override
        public void onSuccess(NexmoCall call) {
            NexmoHelper.currentCall = call;
            
            Intent intent = new Intent(CreateCallActivity.this, OnCallActivity.class);
            startActivity(intent);
        }
    };
```
*** Note:
While `NexmoCallHandler.IN_APP` is create for simple calls, you can also start a call with customized logic, defined by your backend (by an NCCO [//TODO add link] just as easy, by choosing `NexmoCallHandler.SERVER` as the CallHandler.

```java
NexmoCient.call(callees, NexmoCallHandler.SERVER, listener)
```

This will also allow you to start a phone (PSTN) call, by adding a phone number to the `callees` list. To read more about that, see here: [//TODO add link]


## 3. Register to incoming events

When Jane calls Joe, Joe should be notified about it, for example, in order to answer or decline the call.

Therefore, Joe should register to incoming events, and implement `onIncomingCall()`.
Whenever Joe is called to - `onIncomingCall()` is called, with the incoming Call object. 

For simplicity, you will accept incoming calls only on `CreateCallActivity`. 
Open `CreateCallActivity` and create the `NexmoIncomingCallListener` to save the refrence to the incoming call on `NexmoHelper`, and start `IncomingCallActivity`:


```java
NexmoIncomingCallListener incomingCallListener = new NexmoIncomingCallListener() {
        @Override
        public void onIncomingCall(NexmoCall call) {

            NexmoHelper.currentCall = call;
            startActivity(new Intent(CreateCallActivity.this, IncomingCallActivity.class));
        }
    };
```

You should register and unregister the listener, on this case, on `onCreate()` and `onDestroy`, as such:

```java
@Override
protected void onCreate(@Nullable Bundle savedInstanceState) {
    //...

    NexmoClient.get().addIncomingCallListener(incomingCallListener);
}

@Override
protected void onDestroy() {
    NexmoClient.get().removeIncomingCallListeners();
    super.onDestroy();
}

```

## 4. Answer a call

Once Joe recieves the incoming call, incredibley simple.
Open `IncomingCallActivity`, and complete the prepared `onAnswer()` button handler, to start `OnCallActivity` after a successful answer:

```java
 public void onAnswer(View view) {
        NexmoHelper.currentCall.answer(new NexmoRequestListener<NexmoCall>() {
            @Override
            public void onError(NexmoApiError nexmoApiError) { }

            @Override
            public void onSuccess(NexmoCall call) {
                startActivity(new Intent(IncomingCallActivity.this, OnCallActivity.class));
                finish();
            }
        });
    }


```

## Hangup
`onHangup()` handler, allow Joe to reject the call. Complete the implementation on `IncomingCallActivity`, to finish the activity:

```java
 public void onHangup(View view) {
        NexmoHelper.currentCall.hangup(new NexmoRequestListener<NexmoCall>() {
            @Override
            public void onError(NexmoApiError nexmoApiError) { }

            @Override
            public void onSuccess(NexmoCall call) {
                finish();
            }
        });
    }

```


## register to call status
If Joe hangs up the call, Jane should know about it, and finish `OnCallActivity`.
The same way, if Jane decides to hangup before Joe answered, Joe should know about it and finish `IncomingCallActivity`.

To be notified on the different call statuses, you should register to `CallEvents`. 
`FinishOnCallEnd` is a simple `NexmoCallEventListener` that will finish the current activity if the call is completed or canceled.

Register to its instance, to address the usecases mentioned above.
On both `OnCallActivity` and `IncomingCallActivity`, add:

```java
    NexmoCallEventListener callEventListener = new FinishOnCallEnd(this);

@Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        //...

        NexmoHelper.currentCall.addCallEventListener(callEventListener);
    }


    @Override
    protected void onDestroy() {
        NexmoHelper.currentCall.removeCallEventListener(callEventListener);
        super.onDestroy();
    }

```

>*Note:* to read more about call statuses, see here [//TODO]


## handle permissions

For devices running Android 6.0 (API level 23) and higher, creating and operation on calls requires requesting runtime permissions.
To simplify the implementation on this tutorial, `BaseActivity` checks the permissions on every Activity's `onStart()` and `onStop()`.
To read more about the permissions needed, read here [TODO]

---

#Congratulations!

You have implemented your first In App Voice application with Nexmo Client SDK for Android.
