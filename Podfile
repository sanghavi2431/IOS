# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

# Uncomment this if you want to use static frameworks
# use_frameworks! :linkage => :static

use_frameworks! # Enable dynamic frameworks
use_modular_headers! # Enable modular headers globally

target 'Woloo' do
  pod 'Smartech-iOS-SDK', '~> 3.4.0'
  pod 'SmartPush-iOS-SDK', '~> 3.4.0'
  pod 'SmartechNudges', '~> 9.0.3'

  # Pods for Woloo
  pod 'LayoutHelper'
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'ObjectMapper'
  pod 'NVActivityIndicatorView'
  pod 'SQLite.swift', '~> 0.12.0'
  pod 'GoogleMaps'
  pod 'DLRadioButton', '~> 1.4'
  pod 'GooglePlaces'
  pod 'swiftScan', :git => 'https://github.com/MxABC/swiftScan.git'
  pod 'Firebase/Crashlytics', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  pod 'Firebase/DynamicLinks', :modular_headers => true
  pod 'Firebase/InAppMessaging', :modular_headers => true
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'Cosmos'
  pod 'FSCalendar'
  pod 'razorpay-pod'
  pod 'SwiftyStoreKit'
  pod 'AppsFlyerFramework'
  pod 'KNContactsPicker'
  pod 'Alamofire'
  pod 'netfox'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'AlamofireNetworkActivityLogger'
  pod 'STPopup'
  pod 'ActionSheetPicker-3.0'


  target 'SmartechNSE' do
    pod 'SmartPush-iOS-SDK', '~> 3.4.0'
  end

  target 'SmartechNCE' do
    pod 'SmartPush-iOS-SDK', '~> 3.4.0'
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
      end
    end
  end
end

target 'OnboardingTestCase' do
  inherit! :search_paths

  # Add Firebase to the test target with modular headers
  pod 'Firebase/Crashlytics', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  pod 'Firebase/DynamicLinks', :modular_headers => true
  pod 'Firebase/InAppMessaging', :modular_headers => true
end

target 'OTPVerification' do
  inherit! :search_paths

  # Add Firebase to the test target with modular headers
  pod 'Firebase/Crashlytics', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  pod 'Firebase/DynamicLinks', :modular_headers => true
  pod 'Firebase/InAppMessaging', :modular_headers => true
end


target 'TestsDashboard' do
  inherit! :search_paths

  # Add Firebase to the test target with modular headers
  pod 'Firebase/Crashlytics', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  pod 'Firebase/DynamicLinks', :modular_headers => true
  pod 'Firebase/InAppMessaging', :modular_headers => true
end

target 'TestMore' do
  inherit! :search_paths

  # Add Firebase to the test target with modular headers
  pod 'Firebase/Crashlytics', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  pod 'Firebase/DynamicLinks', :modular_headers => true
  pod 'Firebase/InAppMessaging', :modular_headers => true
end

target 'HomeDashboardTests' do
  inherit! :search_paths

  # Add Firebase to the test target with modular headers
  pod 'Firebase/Crashlytics', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  pod 'Firebase/DynamicLinks', :modular_headers => true
  pod 'Firebase/InAppMessaging', :modular_headers => true
end

target 'TestPeriodTracker' do
  inherit! :search_paths

  # Add Firebase to the test target with modular headers
  pod 'Firebase/Crashlytics', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  pod 'Firebase/DynamicLinks', :modular_headers => true
  pod 'Firebase/InAppMessaging', :modular_headers => true
end
