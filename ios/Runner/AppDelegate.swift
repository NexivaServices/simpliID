import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var blurEffectView: UIVisualEffectView?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Enable screenshot prevention for iOS
    enableScreenshotPrevention()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func enableScreenshotPrevention() {
    // Add observer for screenshot detection
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenshotTaken),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )
    
    // Add observers to blur screen during screen recording
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )
    
    // Add observers for app state changes to hide sensitive content
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(hideContent),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(showContent),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
  }
  
  @objc private func screenshotTaken() {
    // Log screenshot attempt
    print("Screenshot attempt detected!")
    // Note: iOS doesn't allow blocking screenshots, but we can detect them
  }
  
  @objc private func screenCaptureChanged() {
    if UIScreen.main.isCaptured {
      print("Screen recording detected!")
      hideContent()
    } else {
      showContent()
    }
  }
  
  @objc private func hideContent() {
    guard let window = UIApplication.shared.windows.first else { return }
    
    if blurEffectView == nil {
      let blurEffect = UIBlurEffect(style: .light)
      let blurView = UIVisualEffectView(effect: blurEffect)
      blurView.frame = window.bounds
      blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      blurView.tag = 999
      window.addSubview(blurView)
      blurEffectView = blurView
    }
  }
  
  @objc private func showContent() {
    blurEffectView?.removeFromSuperview()
    blurEffectView = nil
  }
}
