target 'salary-calc' do
  pod 'AFNetworking'
  pod 'Charts','~> 3.1.1'
  pod 'Firebase/Core','~>4.4.0'
  pod 'Firebase/AdMob','~>4.4.0'
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
