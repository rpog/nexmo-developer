---
title: Setup Nexmo Application, Users and tokens.
---

# Get Started - Setup Nexmo Application, Users and Tokens

In order to use the Nexmo Client SDK, there are 3 things you will need to setup before getting started:

* **[Nexmo Application](_documentation/conversation/concepts/application)**, which contains configuration for the app that you are building.

* **[Users](_documentation/conversation/concepts/user)** - users who are associated with the Nexmo Application. It's expected that Users will have a one-to-one mapping with your own authentication system.

* **JWTs** ([JSON Web Tokens](https://jwt.io/)) - NexmoClient SDK uses JWTs for authentication. In order for a user to log in and use the SDK functionality, you should provide a JWT per user. JWTs contain all the information the Nexmo platform needs to authenticate requests, as well as information such as the associated Applications, Users and permissions.


All of those may be created by your backend. If you wish to get started and experience using the SDK without any implementation of your backed, this guide will show you how to do so, using CLI.

---

## Before you begin

Make sure you have the following:

* A free Nexmo account - [signup](https://dashboard.nexmo.com)
* [Node.JS](https://nodejs.org/en/download/) and NPM installed
* Install the Nexmo CLI. Run the following on a terminal:

```bash
$ npm install -g nexmo-cli@beta
```

Setup the CLI to use your Nexmo API Key and API Secret. You can get these from the [setting page](https://dashboard.nexmo.com/settings) in the Nexmo Dashboard.

```bash
nexmo setup api_key api_secret
```

## 1. Create a Nexmo application

Create an application within the Nexmo platform.

Run the following command:

```bash
nexmo app:create "My Nexmo App" http://example.com/answer http://example.com/event --type=rtc --keyfile=private.key
```

The output should be similar to this:

```bash
Application created: aaaaaaaa-bbbb-cccc-dddd-0123456789ab
No existing config found. Writing to new file.
Credentials written to /path/to/your/local/folder/.nexmo-app
Private Key saved to: private.key
```

On the first output line is the Application ID. Take a note of it. It will be later referred to as `MY_APP_ID`.

In addition, a private key was cewated. It is used to generate JWTs that are used to authenticate your interactions with Nexmo.


## 2. Create a User

Create a user who will log in to Nexmo Client and participate in the SDK functionality: conversations, calls and so on.

Swap `MY_USER_NAME` with your desired use name, and run the following command on a terminal:

```bash
nexmo user:create name="MY_USER_NAME"
```

The output with the user id, will look as follows:

```sh
User created: USR-aaaaaaaa-bbbb-cccc-dddd-0123456789ab
```

Take a note of the `id` attribute as this is the unique identifier for the user that has been created. It will be  referred to as `MY_USER_ID` on the next step.


## 3. Generate a User JWT

Generate a JWT for the user. 
Remember to swap `MY_APP_ID` and `MY_USER_ID` values in the command:

```bash
nexmo jwt:generate ./private.key sub=MY_USER_ID exp=$(($(date +%s)+86400)) acl='/**' application_id=MY_APP_ID
```

> *Note: The above command sets the expiry of the JWT to one day from now, which is the maximum amount of time. You may change the expiration to a shorted amount of time, or re-grenerate a jwt for the user after the current JWT is expired.*

To read more about the JWT and ACL the SDK uses, [find this guide.](/client-sdk/concepts/jwt-acl)
