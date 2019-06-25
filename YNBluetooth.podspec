#
# Be sure to run `pod lib lint HXAppPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HXAppPod'
  s.version          = '1.1.0'
  s.summary          = 'HXAppPod, a library of app. Common classes.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HXAppPod, a library of app. Common classes.Here should be a long long description.
                       DESC

  s.homepage         = 'http://code.59store.com/ios/HXAppPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chen Si' => 'chsasaw@gmail.com' }
  s.source           = { :git => 'git@code.59store.com:ios/HXAppPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'HXAppPod/Classes/**/*.{h,m}'
  
  s.resource_bundles = {
    'HXAppPod' => ['HXAppPod/Assets/**/*', 'HXAppPod/Classes/**/*.{xib,storyboard, lproj}']
  }

  s.public_header_files = 'HXAppPod/Classes/**/*.h'
  s.frameworks = 'UIKit'

  s.requires_arc = true

  s.subspec 'OpenUDID' do |ss|
    ss.source_files = 'HXAppPod/Classes/OpenUDID/*.{h,m}'
    ss.public_header_files = 'HXAppPod/Classes/OpenUDID/*.h'

    ss.requires_arc = false
  end
 

end

