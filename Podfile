# Uncomment this line to define a global platform for your project

platform :ios, '8.0'
use_frameworks!
target 'Eventory' do

  # Pods for Eventory
pod 'Alamofire', '~> 3.0'
pod 'ObjectMapper', '~> 0.17'
pod 'RealmSwift', '~> 2.1.2'
pod 'SwiftTask', '~> 5.0.0'
pod 'DZNEmptyDataSet', '~> 1.8.1'
pod 'SVProgressHUD', '~> 2.1.2'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'Instructions', '~> 0.5'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '2.3'
      end
   end
end
