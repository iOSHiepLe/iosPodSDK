Pod::Spec.new do |spec|
  spec.name         = 'iosPodSDK'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/iOSHiepLe/iosPodSDK.git'
  spec.authors      = { 'Hiep Le' => 'hieplemobile@gmail.com' }
  spec.summary      = 'test embedded sdk'
  spec.source       = { :git => 'https://github.com/iOSHiepLe/iosPodSDK.git', :tag => 'v0.0.1' }
  spec.source_files = 'Tixngo/*.{swift}'
  spec.vendored_frameworks = 'app_settings.xcframework', 'App.xcframework', 'ScreenShieldKit.xcframework', 'beacon.xcframework', 'contacts_service.xcframework', 'core.xcframework', 'DTTJailbreakDetection.xcframework', 'Flutter.xcframework', 'FlutterPluginRegistrant.xcframework', 'FMDB.xcframework', 'libphonenumber.xcframework', 'KeychainSwift.xcframework', 'libPhoneNumber_iOS.xcframework', 'path_provider_ios.xcframework', 'safe_device.xcframework', 'screenshot_protection.xcframework', 'shared_preferences_ios.xcframework', 'sqflite.xcframework', 'url_launcher_ios.xcframework', 'video_player_avfoundation.xcframework', 'wakelock.xcframework', 'wallet_suppression.xcframework', 'webview_flutter_wkwebview.xcframework' 
  spec.dependency 'KontaktSDK', '~> 3.0.4'
end
