platform :ios, '16.0'

target 'MovieNight-iOS' do
  use_frameworks!

  # Pods for MovieNight-iOS
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseCore'
  pod 'UIImageColors'
  pod 'TransitionButton'
  
  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                 end
            end
     end
  end

end
