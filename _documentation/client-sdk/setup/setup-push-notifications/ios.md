## Push Notifications

The SDK uses push notifications to receive certain events for when the app is not active.  
To allow Nexmo to send notifications to your app, create a push certificate for your app through your Apple developer account and [upload it to the nexmo push service](DevRel:LinkHowToUploadACertificateForPushService).

Obtain your SSL client certificate from Apple.

### Integrating Regular Push
Nexmo push is sent silently to allow the developer control over what is presented to the user.  
To Receive silent push notifications in your app use the following steps.
1. Enable push notifications for your app.  
    * In XCode under your target, open Capabilities and enable Push Notifications
    * In XCode under your target, open Capabilities and enable background modes with remote notifications selected

2.  Register for device token  
    In your app delegate implement the following delegate method to receive a device token.  
    **Swift**
    ```objective-c
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    ```
    **Objective-C**
    ```objective-c
    - (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
    ```

3. Handle incoming push
    In your app delegate adopt the UNUserNotificationCenterDelegate  
    Implement the following delegate method and add the the code to handle an incoming push notification  
    **Swift**
    ```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if(client.isNexmoPush(userInfo: userInfo)) {
            client.processNexmoPush(userInfo: userInfo) { (error: Error?) in
                //Code
            }
        }
    }
    ```

    **Objective-C**
    ```objective-c
        - (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
            if([client isNexmoPushWithUserInfo:userInfo]) {
                [client processNexmoPushWithuserInfo:userInfo completion:^(NSError * _Nullable error) {
                    //Code
                }];
            }
    }
    ```
    **note**: For the SDK to process the push properly the client should be logged in.

4. Enable nexmo push notifications through a logged in SDK client
    
    **Swift**
    ```swift
    client.enablePushNotifications(withDeviceToken: 'deviceToken', isPushKit: false, isSandbox: 'isSandbox') { (error: Error?) in 
        //Code    
    }
    ```

    **Objective-C**
    ```objective-c
    [client enablePushNotificationsWithDeviceToken:'deviceToken' isPushKit:NO isSandbox:'isSandbox' completion:^(NSError * _Nullable error) {
                    //Code
                }];
    ```

    * `'isSandbox'` is YES/true for an app using the apple sandbox push servers and NO/false for an app using the apple production push servers.  
    * `'deviceToken'` is the token received in `application:didRegisterForRemoteNotificationsWithDeviceToken:`

### Integrating Voip Push
A voip push allows for a better experience when receiving notifications including receiving notifications even when the app is terminated.  
To receive voip push notifications follow the following steps.
1. Enable voip push notifications for your app.  
    * In XCode under your target, open Capabilities and enable Push Notifications
    * In XCode under your target, open Capabilities and enable background modes with Voice over IP selected

2. Import push kit, adopt PKPushRegistryDelegate and sign to voip notifications  
    **Swift**
    ```swift
    func registerForVoIPPushes() {
        self.voipRegistry = PKPushRegistry(queue: nil)
        self.voipRegistry.delegate = self
        self.voipRegistry.desiredPushTypes = [PKPushTypeVoIP]
    }
    ```

    **Objective-C**
    ```objective-c
    - (void) registerForVoIPPushes {
        self.voipRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
        self.voipRegistry.delegate = self;
        
        // Initiate registration.
        self.voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    }
    ```

3. Implement the following delegate method and add the the code to handle an incoming voip push notification  
    **Swift**
    ```swift
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if(client.isNexmoPush(userInfo: payload.dictionaryPayload)) {
            client.processNexmoPush(userInfo: payload.dictionaryPayload) { (error: Error?) in
                //Code
            }
        }
    }
    ```

    **Objective-C**
    ```objective-c
    - (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion {
        if([client isNexmoPushWithUserInfo: payload.dictionaryPayload]) {
            [client processNexmoPushWithUserInfo:payload.dictionaryPayload completion:^(NSError * _Nullable error) {
                //Code
            }];
        }
    }
    ```
    **note**: For the SDK to process the push properly the client should be logged in. 

4. Enable nexmo push notifications through a logged in SDK client  
    **Swift**
    ```swift
    client.enablePushNotifications(withDeviceToken: 'deviceToken', isPushKit: true, isSandbox: 'isSandbox') { (error: Error?) in 
        //Code    
    }
    ```

    **Objective-C**
    ```objective-c
    [client enablePushNotificationsWithDeviceToken:'deviceToken' isPushKit:YES isSandbox:'isSandbox' completion:^(NSError * _Nullable error) {
                    //Code
                }];
    ```
    * `'isSandbox'` is YES/true for an app using the apple sandbox push servers and NO/false for an app using the apple production push servers.  
    * `'deviceToken'` is the token received in `application:didRegisterForRemoteNotificationsWithDeviceToken:`
