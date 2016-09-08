Pod::Spec.new do |s|
  s.name             = "NorthLayout"
  s.version          = "2.2.0"
  s.summary          = "Autolayout Visual Format Helper"
  s.description      = <<-DESC
                       fast path to autolayout using the Visual Format like `autolayout("H:|-[label]-|")`
                       DESC
  s.homepage         = "https://github.com/banjun/NorthLayout"
  s.license          = 'MIT'
  s.author           = { "banjun" => "banjun@gmail.com" }
  s.source           = { :git => "https://github.com/banjun/NorthLayout.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/banjun'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Classes/**/*'
  s.ios.frameworks = 'UIKit'
  s.osx.frameworks = 'AppKit'
  s.requires_arc = true
end
