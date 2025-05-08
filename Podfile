platform :ios, '16.4'

target 'pomo2' do
  use_frameworks!

  pod 'RealmSwift', '20.0.2'
  pod 'Realm', '20.0.2'
  pod 'CalculateCalendarLogic'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
