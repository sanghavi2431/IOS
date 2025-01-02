# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'Woloo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static
  
 pod 'Smartech-iOS-SDK', '~> 3.5.6'
 pod 'SmartPush-iOS-SDK', '~> 3.5.5'
 pod 'SmartechNudges', '~> 9.0.14'

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
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/DynamicLinks'

#  pod 'Firebase'
#  pod 'Firebase/Messaging'
  pod 'Firebase/InAppMessaging'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'Cosmos'
  # pod 'FBSDKLoginKit'
  # pod 'GoogleSignIn'
  pod 'FSCalendar'
  pod 'razorpay-pod'
  pod 'SwiftyStoreKit'
  pod 'FSCalendar'
#  pod 'FacebookSDK' # dont remove this. it is for codeless analytics
  pod 'AppsFlyerFramework'
#  pod 'FBSDKCoreKit'
#  pod 'FBSDKLoginKit'
#  pod 'FBSDKShareKit'
  #  pod 'FBSDKPlacesKit'
  #  pod 'FBSDKMessengerShareKit'
#
#  pod 'FBSDKCoreKit', '~> 8.0.0'
#  pod 'FBSDKLoginKit', '~> 8.0.0'
#  pod 'FBSDKShareKit', '~> 8.0.0'
#  pod 'FBSDKGamingServiceKit', '~> 8.0.0'
  pod 'KNContactsPicker'
  pod 'Alamofire'
 pod 'netfox'
 pod 'SwiftyJSON', '~> 4.0'
pod 'AlamofireNetworkActivityLogger'


target 'SmartechNSE' do
pod 'SmartPush-iOS-SDK', '~> 3.5.5'
end

target 'SmartechNCE' do
pod 'SmartPush-iOS-SDK', '~> 3.5.5'
end



post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
      end
    end
  end



end
