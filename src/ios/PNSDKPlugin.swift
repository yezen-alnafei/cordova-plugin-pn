import Foundation
import UserNotifications

@objc(LPMessagingSDKPlugin) class LPMessagingSDKPlugin: CDVPlugin {
    
    static var pnToken: String?
    
    override func pluginInitialize() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
            }
        } else {
            let settings : UIUserNotificationSettings = UIUserNotificationSettings(types:UIUserNotificationType(rawValue: UIUserNotificationType.RawValue(UInt8(UIUserNotificationType.alert.rawValue)|UInt8(UIUserNotificationType.sound.rawValue))), categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // Prepare a callback to trigger a response to the JS consumer when native commands have finished
    func prepareCallback(_ from: CDVInvokedUrlCommand) -> LPCordovaCallback {
        return LPCordovaCallback(delegate: commandDelegate, command: from)
    }
    
    // Native fetching of push tokens
    // Requires AppDelegate to be hooked into the Cordova build
    func appDelegatePushNotificationToken() -> Data? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate.pnToken
        }
        
        return nil
    }

    // MARK: Public API methods
    @objc func get_push_notification_token(_ command: CDVInvokedUrlCommand) {
        if (LPMessagingSDKPlugin.pnToken != nil) {
            prepareCallback(command)
            .ok(LPMessagingSDKPlugin.pnToken, keepCallback: true)

        } else{
            prepareCallback(command)
            .ok(0, keepCallback: true)
        }
    }
}

extension AppDelegate{
   
    open override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }

        LPMessagingSDKPlugin.pnToken = token
        
        print("Permission granted with push notification Token: \(token)")
    }
    
   open override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}
