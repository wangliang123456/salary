target 'salary-calc' do
  pod 'AFNetworking', '~> 3.0'
  pod 'Charts'
  pod 'ChartsRealm'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
  use_frameworks!
  inhibit_all_warnings!
end