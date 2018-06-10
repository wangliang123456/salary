target 'salary-calc' do
  pod 'AFNetworking'
  pod 'Charts','~> 3.1.1'
  pod 'Google-Mobile-Ads-SDK'
  pod 'Firebase/Core'
  pod 'FMDB', '~> 2.7.2'
  platform :ios, '9.3'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
  use_frameworks!
  inhibit_all_warnings!
end
