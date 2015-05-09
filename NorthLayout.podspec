Pod::Spec.new do |s|
  s.name             = "NorthLayout"
  s.version          = "0.1.0"
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
  s.source_files = 'Classes/**/*'
  s.ios.frameworks = 'UIKit'
  s.requires_arc = true
end
