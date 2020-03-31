# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'basketballApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for basketballApp
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'CircleAnimatedMenu'
  pod 'JTAppleCalendar'
  pod 'Charts'
  pod 'Device', '~> 3.2.1'
  
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods

    target 'basketballAppUnitTests' do
      inherit! :search_paths
      pod 'Firebase'
    end

    target 'basketballAppIntegrationTests' do
      inherit! :search_paths
      pod 'Firebase'
    end
end
