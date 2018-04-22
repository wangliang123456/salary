target 'salary-calc' do
  pod 'AFNetworking'
  pod 'Charts', '~> 3.0.4'
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'FMDB', '~> 2.7.2'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.1'
      end
    end
  end
  use_frameworks!
  inhibit_all_warnings!
end
