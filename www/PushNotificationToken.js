"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/** The LivePerson Messaging SDK service name (targeted by Cordova). */
var lpSdkService = 'CordovaPushNotification';
//#endregion Types
//#region Helpers
/**
* Directly invoke a method on the LivePerson Messaging SDK.
* @private
* @param {string} action - SDK method name.
* @param {any[]} args - Arguments to pass to the SDK method.
* @param {SdkResultHandler} success - Success callback.
* @param {SdkErrorHandler} error - Error callback.
*/
var callSdk = function (action, args, success, error) {
    if (!window.cordova) {
        return error('Cordova not available');
    }
    window.cordova.exec(success, error, lpSdkService, action, args);
};
/**
* Invoke a LivePerson SDK method and treat the result as a promise.
* @private
* @param {string} action - SDK method name.
* @param {any[]} args - Arguments to pass to the SDK method.
* @returns A promise that resolves to a response from the SDK.
*/
var sdkPromise = function (action, args) {
    return new Promise(function (resolve, reject) {
        callSdk(action, args, resolve, reject);
    });
};
//#endregion Helpers
/**
 * Provides an interface to the LivePerson Messaging SDK.
 */
var PushNotificationToken = /** @class */ (function () {
    function PushNotificationToken() {
    }
    /** Internally tracks whether the SDK has been initialised.
    /**
    * Get the number of unread messages.
    * @returns {Promise<number>}
    */
    PushNotificationToken.prototype.getPushNotificationToken = function () {
        return sdkPromise('get_push_notification_token', []);
    };
    return PushNotificationToken;
}());
exports.PushNotificationToken = PushNotificationToken;
exports.pushNotificationTokenInstance = new PushNotificationToken();
//# sourceMappingURL=PushNotificationToken.js.map