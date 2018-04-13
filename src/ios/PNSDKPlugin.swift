import Foundation

@objc(LPMessagingSDKPlugin) class LPMessagingSDKPlugin: CDVPlugin {



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

         if let pushToken = appDelegatePushNotificationToken() {
            
            let tokenString = NSString(data: pushToken, encoding: String.Encoding.utf8.rawValue)
            
            prepareCallback(command)
            .ok(tokenString, keepCallback: true)

        } else{
            prepareCallback(command)
            .ok(0, keepCallback: true)
    }
}

}
