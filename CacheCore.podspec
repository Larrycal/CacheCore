#
# Be sure to run `pod lib lint CacheCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CacheCore'
  s.version          = '0.1.1'
  s.summary          = 'iOS Json 缓存框架'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                基于iOS平台的JSon缓存框架
                       DESC

  s.homepage         = 'https://github.com/Larrycal/CacheCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Larrycal' => 'lyk82465@gmail.com' }
  # s.source           = { :git => 'https://github.com/Larrycal/CacheCore.git' }
  s.source           = { :git => 'https://github.com/Larrycal/CacheCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CacheCore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CacheCore' => ['CacheCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Moya', '~> 11.0.0'
  s.dependency 'ObjectMapper', '~> 3.1'
  s.dependency 'FMDB'
  s.dependency 'CocoaAsyncSocket'
end
