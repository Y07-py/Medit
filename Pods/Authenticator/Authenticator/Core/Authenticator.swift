//
//  Authenticator.swift
//  Authenticator
//
//  Created by Quan Li on 2020/3/10.
//

import Foundation
import LocalAuthentication

open class Authenticator{
    public static let shared = Authenticator()
    
    private init(){}
    private lazy var context:LAContext? = {
        return LAContext()
    }()
    
    /// 允许的重复使用的时间
    public var allowableReuseDuration:TimeInterval?{
        didSet{
            guard let duration = allowableReuseDuration else {
                return
            }
            if #available(iOS 9.0, *) {
                self.context?.touchIDAuthenticationAllowableReuseDuration = duration
            }
        }
    }
}


public extension Authenticator{
    /// 检查当前是否可以在设备上执行生物特征认证。
    class var canAuthenticate:Bool {
        var isBiometricAuthenticationAvailable = false
        var error: NSError? = nil
        if LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isBiometricAuthenticationAvailable = (error == nil)
        }
        return isBiometricAuthenticationAvailable
    }
    
    /// 判断当前设置是否具有FaceID(注意：这不会检查设备是否可以执行生物特征认证)
    class var isFaceIdDevice:Bool {
        let context = LAContext()
        _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        if #available(iOS 11.0, *) {
            return context.biometryType == .faceID
        }
        return false
    }
    
    /// 是否支持Face
    class var faceIDAvailable:Bool {
        let context = LAContext()
        var error: NSError?
        
        let canEvaluate = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if #available(iOS 11.0, *) {
            return canEvaluate && context.biometryType == .faceID
        }
        return canEvaluate
    }
    
    /// 是否支持TouchId
    class var touchIDAvailable:Bool {
        let context = LAContext()
        var error: NSError?
        
        let canEvaluate = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if #available(iOS 11.0, *) {
            return canEvaluate && context.biometryType == .touchID
        }
        return canEvaluate
    }
}


public extension Authenticator{
    /// FaceID,TouchID验证
    /// - Parameters:
    ///   - reason: 请求验证的原因
    ///   - fallbackTitle:当验证出现失败时，弹出出现的后备的验证方式(如输入密码)。 如果设置为空字符串，该按钮将被隐藏。当此属性保留为零时，将使用默认标题“输入密码”。
    ///   - cancelTitle:取消按钮
    ///   - completion: 完成回调
    class func authenticateWithBioMetrics(reason: String, fallbackTitle: String? = "", cancelTitle: String? = "", completion: @escaping (Result<Bool, AuthenticationError>) -> Void) {
        // 原因
        let reasonString = reason.isEmpty ? defaultBiometricAuthenticationReason : reason
        
        // 上下文
        var context: LAContext!
        if Authenticator.shared.isReuseDurationSet {
            context = Authenticator.shared.context
        }else {
            context = LAContext()
        }
        context.localizedFallbackTitle = fallbackTitle
        
        // 取消按钮标题
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = cancelTitle
        }
        
        // 验证
        Authenticator.shared.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
    }
    
    /// 设备密码验证(后备验证方式)
    /// - Parameters:
    ///   - reason: 请求验证的原因
    ///   - cancelTitle: 取消标题
    ///   - completion: 回调
    class func authenticateWithPasscode(reason: String, cancelTitle: String? = "", completion: @escaping ((Result<Bool, AuthenticationError>) -> ())) {
        
        // 原因
        let reasonString = reason.isEmpty ? defaultPasscodeAuthenticationReason : reason
        
        let context = LAContext()
        
        // 取消按钮标题
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = cancelTitle
        }
        
        // 验证
        if #available(iOS 9.0, *) {
            Authenticator.shared.evaluate(policy: .deviceOwnerAuthentication, with: context, reason: reasonString, completion: completion)
        } else {
            // 早期版本
            Authenticator.shared.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
        }
    }
}


// MARK:- 私有方法
extension Authenticator {
    /// 获取身份验证原因以在身份验证时显示
    private static var defaultBiometricAuthenticationReason:String {
        return faceIDAvailable ? kFaceIdAuthenticationReason : kTouchIdAuthenticationReason
    }
    
    /// 多次尝试失败后，输入设备密码时获取密码验证原因显示。
    private static var defaultPasscodeAuthenticationReason:String {
        return faceIDAvailable ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
    }
    
    /// 检查是否设置了allowableReuseDuration
    private var isReuseDurationSet:Bool {
        guard allowableReuseDuration != nil else {
            return false
        }
        return true
    }
    
    /// 验证
    private func evaluate(policy: LAPolicy, with context: LAContext, reason: String, completion: @escaping (Result<Bool, AuthenticationError>) -> ()) {
        
        context.evaluatePolicy(policy, localizedReason: reason) { (success, err) in
            DispatchQueue.main.async {
                if success {
                    completion(.success(true))
                }else {
                    let errorType = AuthenticationError.initWithError(err as! LAError)
                    completion(.failure(errorType))
                }
            }
        }
    }
}


public extension Result where Success == Bool,Failure == AuthenticationError{
    var isSuccess:Bool{
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    var error:AuthenticationError?{
        switch self {
        case .success(_):
            return nil
        case .failure(let err):
            return err
        }
    }
}



public enum AuthenticationError: Error {
    //用户验证失败
    case failed
    //用户取消
    case canceledByUser
    //当验证出现失败时，弹出出现的后备的验证方式(如输入密码)
    case fallback
    //系统取消
    case canceledBySystem
    //没有设置密码
    case passcodeNotSet
    //设备不支持FaceID或者TouchID
    case biometryNotAvailable
    //该设备未设置FaceID或者TouchID，请用户设置FaceID或者TouchID
    case biometryNotEnrolled
    //由于有太多的失败尝试，FaceID或者TouchID现在被锁定。需要输入设备密码才能解锁。先使用FaceID或者TouchID认证，
    //当出现多次失败后使用密码认证(authenticateWithPasscode)
    case biometryLockedout
    //其他
    case other
    
    public static func initWithError(_ error: LAError) -> AuthenticationError {
        switch Int32(error.errorCode) {
        
        case kLAErrorAuthenticationFailed:
            return failed
            
        case kLAErrorUserCancel:
            return canceledByUser
            
        case kLAErrorUserFallback:
            return fallback
            
        case kLAErrorSystemCancel:
            return canceledBySystem
            
        case kLAErrorPasscodeNotSet:
            return passcodeNotSet
            
        case kLAErrorBiometryNotAvailable:
            return biometryNotAvailable
            
        case kLAErrorBiometryNotEnrolled:
            return biometryNotEnrolled
            
        case kLAErrorBiometryLockout:
            return biometryLockedout
            
        default:
            return other
        }
    }
    
    public var message:String {
        let isFaceIdDevice = Authenticator.isFaceIdDevice
        switch self {
        case .canceledByUser, .fallback, .canceledBySystem:
            return ""
        case .passcodeNotSet:
            return isFaceIdDevice ? kSetPasscodeToUseFaceID : kSetPasscodeToUseTouchID
        case .biometryNotAvailable:
            return kBiometryNotAvailableReason
        case .biometryNotEnrolled:
            return isFaceIdDevice ? kNoFaceIdentityEnrolled : kNoFingerprintEnrolled
        case .biometryLockedout:
            return isFaceIdDevice ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
        default:
            return isFaceIdDevice ? kDefaultFaceIDAuthenticationFailedReason : kDefaultTouchIDAuthenticationFailedReason
        }
    }
}



let kBiometryNotAvailableReason = "生物识别身份验证不适用于此设备。"

/// ****************  Touch ID  ****************** ///

let kTouchIdAuthenticationReason = "确认您的指纹以进行身份验证。"
let kTouchIdPasscodeAuthenticationReason = "由于尝试失败的次数过多，Touch ID现在被锁定。 输入密码以解锁Touch ID。"

/// Touch ID 错误描述
let kSetPasscodeToUseTouchID = "请设置设备密码以使用Touch ID进行身份验证。"
let kNoFingerprintEnrolled = "设备中没有指纹。 请转到设备设置->触摸ID和密码并注册您的指纹。"
let kDefaultTouchIDAuthenticationFailedReason = "Touch ID无法识别您的指纹。 请使用您注册的指纹再试一次。"

/// ****************  Face ID  ****************** ///

let kFaceIdAuthenticationReason = "确认Face ID以进行身份验证。"
let kFaceIdPasscodeAuthenticationReason = "由于失败的尝试过多，现在Face ID已被锁定。 输入密码以解锁Face ID。"

/// Face ID 错误描述
let kSetPasscodeToUseFaceID = "请设置设备密码以使用Face ID进行身份验证。"
let kNoFaceIdentityEnrolled = "设备中没有Face ID。 请转到设备设置->Face ID和密码并设置您的Face ID。"
let kDefaultFaceIDAuthenticationFailedReason = "Face ID无法识别您的脸部。 请用您设置的Face ID再试一次。"
