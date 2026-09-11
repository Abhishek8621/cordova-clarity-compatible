import Cordova
import Foundation
import Clarity

@objc(ClarityPlugin)
class ClarityPlugin: CDVPlugin {

    private func mapLogLevel(_ level: String) -> LogLevel {
        switch level {
        case "Verbose":
            return .verbose
        case "Debug":
            return .debug
        case "Info":
            return .info
        case "Warning":
            return .warning
        case "Error":
            return .error
        default:
            return .none
        }
    }

    private func parseIsIonic(_ value: Any?) -> Bool {
        if value is NSNull || value == nil {
            return false
        }
        if let number = value as? NSNumber {
            return number.boolValue
        }
        if let string = value as? String {
            return string == "true" || string == "1"
        }
        return false
    }

    private func runOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }

    private func optionalString(_ value: Any?) -> String? {
        guard let value = value else { return nil }
        if value is NSNull { return nil }
        guard let string = value as? String else { return nil }
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func makePluginResult(status: CDVCommandStatus, message: Any) -> CDVPluginResult {
        if message is NSNull {
            return CDVPluginResult(status: status)
        }
        if let string = message as? String {
            return CDVPluginResult(status: status, messageAs: string)
        }
        if let intValue = message as? Int {
            return CDVPluginResult(status: status, messageAs: intValue)
        }
        return CDVPluginResult(status: status, messageAs: String(describing: message))
    }

    private func sendSuccess(_ command: CDVInvokedUrlCommand, message: Any) {
        let result = makePluginResult(status: CDVCommandStatus_OK, message: message)
        commandDelegate.send(result, callbackId: command.callbackId)
    }

    private func sendFailure(_ command: CDVInvokedUrlCommand, message: String) {
        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
        commandDelegate.send(result, callbackId: command.callbackId)
    }

    @objc(initialize:)
    func initialize(_ command: CDVInvokedUrlCommand) {
        guard let projectId = optionalString(command.arguments.count > 0 ? command.arguments[0] : nil) else {
            sendFailure(command, message: "Missing projectId")
            return
        }

        let logLevelValue = optionalString(command.arguments.count > 2 ? command.arguments[2] : nil) ?? "None"
        let logLevel = mapLogLevel(logLevelValue)
        let isIonic = command.arguments.count > 3 ? parseIsIonic(command.arguments[3]) : false
        let applicationFramework: ApplicationFramework = isIonic ? .ionic : .cordova

        runOnMain {
            let config = ClarityConfig(
                projectId: projectId,
                logLevel: logLevel,
                applicationFramework: applicationFramework
            )
            let initialized = ClaritySDK.initialize(config: config)

            if initialized {
                self.sendSuccess(command, message: "Clarity initialized.")
            } else {
                self.sendFailure(
                    command,
                    message: "Failed to initialize Clarity, domain may not be allowed. Please check logs for more details!"
                )
            }
        }
    }

    @objc(pause:)
    func pause(_ command: CDVInvokedUrlCommand) {
        runOnMain {
            ClaritySDK.pause()
            if ClaritySDK.isPaused() {
                self.sendSuccess(command, message: "Clarity paused.")
            } else {
                self.sendFailure(command, message: "Failed to pause Clarity, please check logs for more details!")
            }
        }
    }

    @objc(resume:)
    func resume(_ command: CDVInvokedUrlCommand) {
        runOnMain {
            ClaritySDK.resume()
            if !ClaritySDK.isPaused() {
                self.sendSuccess(command, message: "Resume succeeded.")
            } else {
                self.sendFailure(command, message: "Failed to resume Clarity, please check logs for more details!")
            }
        }
    }

    @objc(isPaused:)
    func isPaused(_ command: CDVInvokedUrlCommand) {
        runOnMain {
            self.sendSuccess(command, message: ClaritySDK.isPaused() ? 1 : 0)
        }
    }

    @objc(setCustomUserId:)
    func setCustomUserId(_ command: CDVInvokedUrlCommand) {
        guard let customUserId = optionalString(command.arguments.count > 0 ? command.arguments[0] : nil) else {
            sendFailure(command, message: "Custom user id cannot be empty.")
            return
        }

        runOnMain {
            if ClaritySDK.setCustomUserId(customUserId) {
                self.sendSuccess(command, message: "Setting custom user id succeeded.")
            } else {
                self.sendFailure(command, message: "Setting custom user id failed, please check logs for more details!")
            }
        }
    }

    @objc(setCustomSessionId:)
    func setCustomSessionId(_ command: CDVInvokedUrlCommand) {
        guard let customSessionId = optionalString(command.arguments.count > 0 ? command.arguments[0] : nil) else {
            sendFailure(command, message: "Custom session id cannot be empty.")
            return
        }

        runOnMain {
            if ClaritySDK.setCustomSessionId(customSessionId) {
                self.sendSuccess(command, message: "Setting custom session id succeeded.")
            } else {
                self.sendFailure(command, message: "Setting custom session id failed, please check logs for more details!")
            }
        }
    }

    @objc(setCustomTag:)
    func setCustomTag(_ command: CDVInvokedUrlCommand) {
        guard let key = optionalString(command.arguments.count > 0 ? command.arguments[0] : nil) else {
            sendFailure(command, message: "Custom tag key cannot be empty.")
            return
        }
        guard let value = optionalString(command.arguments.count > 1 ? command.arguments[1] : nil) else {
            sendFailure(command, message: "Custom tag value cannot be empty.")
            return
        }

        runOnMain {
            if ClaritySDK.setCustomTag(key: key, value: value) {
                self.sendSuccess(command, message: "Setting custom tag succeeded.")
            } else {
                self.sendFailure(command, message: "Setting custom tag failed, please check logs for more details!")
            }
        }
    }

    @objc(getCurrentSessionId:)
    func getCurrentSessionId(_ command: CDVInvokedUrlCommand) {
        runOnMain {
            if let sessionId = ClaritySDK.getCurrentSessionId() {
                self.sendSuccess(command, message: sessionId)
            } else {
                self.sendSuccess(command, message: NSNull())
            }
        }
    }

    @objc(getCurrentSessionUrl:)
    func getCurrentSessionUrl(_ command: CDVInvokedUrlCommand) {
        runOnMain {
            if let sessionUrl = ClaritySDK.getCurrentSessionUrl() {
                self.sendSuccess(command, message: sessionUrl)
            } else {
                self.sendSuccess(command, message: NSNull())
            }
        }
    }
}
