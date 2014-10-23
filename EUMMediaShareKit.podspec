Pod::Spec.new do |s|
  s.name = 'EUMMediaShareKit'
  s.version = '0.1.0'
  s.license      = {
    :type => "Copyright",
    :text => <<-LICENSE
      All rights reserved.
    LICENSE
  }
  s.summary = 'This is the library for EUM Media Share Kit'
  s.homepage = 'https://github.com/eumlab/EUMMediaShareKit'
  s.author = { 'EUMLab' => 'http://eumlab.com/' }
  s.source = { :git => 'https://github.com/eumlab/EUMMediaShareKit' }
  s.ios.deployment_target = "7.0"

  s.dependency 'Google-API-Client/YouTube'
  s.dependency 'CocoaSoundCloudAPI'
  s.dependency 'CocoaSoundCloudUI' 

  s.requires_arc = true
  s.source_files = 'MediaShareKit/Share/*.{h,m}'
  s.resource = 'MediaShareKit/Share/*.{storyboard}'
  s.public_header_files = 'MediaShareKit/Share/*.h'
  # s.frameworks = 'Foundation', 'UIKit', 'SystemConfiguration'
end
