platform :ios, '16.4'

target 'pomo2' do
  use_frameworks!

  pod 'RealmSwift', '20.0.2'
  pod 'Realm', '20.0.2'
#  pod 'CalculateCalendarLogic'
  pod 'SwiftDate'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end

  # 🔧 rsync に _CodeSignature 除外を追加
  Dir.glob("Pods/Target Support Files/**/*.sh").each do |script|
    text = File.read(script)
    new_text = text.gsub(
      /rsync\s+(--delete\s+)?-av/,
      '\0 --exclude=_CodeSignature'
    )
    File.open(script, "w") { |file| file.puts new_text }
  end
end
