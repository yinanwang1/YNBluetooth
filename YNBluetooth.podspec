#
# Be sure to run `pod lib lint YNBluetooth.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YNBluetooth'
  s.version          = '1.0.1'
  s.summary          = 'YNBluetooth, a library of app. Common classes.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
YNBluetooth, a library of app. Common classes.Here should be a long long description.
                       DESC

  s.homepage         = 'https://github.com/yinanwang1/YNBluetooth'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arthur' => 'wangyinan1986@sina.com' }
  s.source           = { :git => 'https://github.com/yinanwang1/YNBluetooth.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'YNBluetooth/Classes/**/*.{h,m}'

  s.public_header_files = 'YNBluetooth/Classes/**/*.h'
  s.frameworks = 'UIKit'

  s.requires_arc = true
 

end

