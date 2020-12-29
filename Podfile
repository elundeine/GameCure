# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'


target 'CauseCure' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!


  # Pods for CauseCure
	
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod ‘SDWebImageSwiftUI’
  pod 'CodableFirebase'
  
end

post_install do |pi|
pi.pods_project.targets.each do |t|
t.build_configurations.each do |bc|
if bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] == '8.0'
bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
end
end
end
end