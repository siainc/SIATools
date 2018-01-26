#
# Be sure to run `pod lib lint SIATools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SIATools'
  s.version          = '0.3.0'
  s.summary          = 'SIATools is utilities for Objective-C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SIATools is a small utility. Some iOS development become comfortable.
                       DESC

  s.homepage         = 'https://github.com/siagency/SIATools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "SI Agency" => "support@si-agency.co.jp" }
  s.source           = { :git => 'https://github.com/siagency/SIATools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SIATools/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SIATools' => ['SIATools/Assets/*.png']
  # }

  s.public_header_files = 'SIATools/Classes/**/*.h'
  s.frameworks = 'Security' , 'QuartzCore'
  s.dependency 'SIAEnumerator', '~> 0.3.0'
end
