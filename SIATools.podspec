#
# Be sure to run `pod lib lint SIATools.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SIATools"
  s.version          = "0.2.0"
  s.summary          = "SIATools is utilities for Objective-C."
  s.description      = <<-DESC
                       SIATools is a small utility. Some iOS development become comfortable.
                       DESC
  s.homepage         = "https://github.com/siagency/SIATools"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "SI Agency" => "support@si-agency.co.jp" }
  s.source           = { :git => "https://github.com/siagency/SIATools.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SIATools' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Security' , 'QuartzCore'
  s.dependency 'Reachability', '~> 3.0'
  s.dependency 'SIAEnumerator', '~> 0.1.0'
end
