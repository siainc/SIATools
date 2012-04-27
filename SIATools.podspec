Pod::Spec.new do |s|
  s.name         = "SIATools"
  s.version      = "0.1.0"
  s.license      = { :type => 'BSD', :file => 'LICENSE' }
  s.summary      = "SIATools is utilities for Objective-C."
  s.homepage     = "https://github.com/siagency/SIATools"
  s.author       = 'SI Agency Inc'
  s.requires_arc = true
  s.platform     = :ios, '5.1.1'
  s.source       = { :git => "https://github.com/siagency/SIATools.git", :tag => "0.1.0" }
#  s.source       = { :git => "https://github.com/siagency/SIATools.git", :commit => "a3c869ae4ad5a2a456172b75bbf6a8fae74f13fc" }
  s.source_files  = 'SIATools/*.{h,m}'

  s.subspec 'Extensions' do |ss|
    ss.source_files = 'SIATools/Extensions/*.{h,m}'
    ss.frameworks = 'Security' , 'QuartzCore'
  end
  s.subspec 'Blocks' do |ss|
    ss.source_files = 'SIATools/Blocks/*.{h,m}'
    ss.dependency 'SIATools/Extensions'
  end
  s.subspec 'Operation' do |ss|
    ss.source_files = 'SIATools/Operation/*.{h,m}'
    ss.dependency 'SIATools/Extensions'
    ss.dependency 'Reachability', '~> 3.0'
  end
  s.subspec 'UI' do |ss|
    ss.source_files = 'SIATools/UI/*.{h,m}'
    ss.dependency 'SIATools/Extensions'
  end
end
