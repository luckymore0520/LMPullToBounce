Pod::Spec.new do |s|

  s.name         = "LMPullToBounce"
  s.version      = "0.0.1"
  s.summary      = "The Objective-C version of PullToBounce. Supports iOS 7.0+."
  s.description  = <<-DESC
                   An elegant “pull to refresh” animation, written in Objective-C, 
                   DESC
  s.homepage     = "https://github.com/luckymore0520/LMPullToBounce"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "luckymore0520" => "njuluckwang@gmail.com" }
  s.social_media_url   = "http://weibo.com/u/2274597140"
  s.platform     = :ios, '7.0'

  s.source       = { :git => "http://luckymore0520/LMPullToBounce.git", :tag => "0.0.1" }
  s.source_files  = "LMPullToBounce", "LMPullToBounce/**/*.{h,m}"
  s.frameworks = 'Foundation', 'UIKit'  


end
