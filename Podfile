# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iOS-TicketTimer' do
	# Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!
	# Pods for iOS-TicketTimer
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'RxGesture'
	pod 'RxDataSources', '~> 5.0'
	pod 'SnapKit', '~> 5.6.0'
	pod 'KakaoSDKAuth'
	pod 'KakaoSDKUser'
	pod 'KakaoSDKCommon'
	pod 'FSCalendar'
  pod 'Kingfisher', '~> 7.6.2'
end

target 'iOS-TicketTimerTests' do
	inherit! :search_paths
	# Pods for testing
end

target 'iOS-TicketTimerUITests' do
	# Pods for testing
end


post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
