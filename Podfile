# Uncomment this line to define a global platform for your project

platform :ios, '8.0'
swift_version = '3.0'
use_frameworks!
target 'Eventory' do

# Pods for Eventory
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git',:branch => 'master'
pod 'ObjectMapper', '~> 2.2.0'
pod 'RealmSwift', '~> 2.1.2'
pod 'SwiftTask', :git => 'https://github.com/ReactKit/SwiftTask', :branch => 'swift/3.0'
pod 'DZNEmptyDataSet', '~> 1.8.1'
pod 'SVProgressHUD', '~> 2.1.2'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'Instructions', :git => 'https://github.com/ephread/Instructions',:branch => 'master'
pod 'BFPaperTabBarController'
pod 'SwiftyJSON', '~> 3.1.1'
pod 'iRate'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
