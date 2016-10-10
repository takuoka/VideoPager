#
# Be sure to run `pod lib lint VideoPager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VideoPager'
  s.version          = '0.1.0'
  s.summary          = 'Swipable Paging Video UI. and some control components is available.'

  s.homepage         = 'https://github.com/entotsu/VideoPager'
  # s.screenshots     = 'https://github.com/entotsu/VideoPager/blob/master/sample_gif/1.gif?raw=true'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Takuya Okamoto' => 'blackn.red42@gmail.com' }
  s.source           = { :git => 'https://github.com/entotsu/VideoPager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/taku_oka'

  s.ios.deployment_target = '8.0'

  s.source_files = 'VideoPager/Classes/**/*', 'VideoPager/Classes/*'
  s.resources    = "VideoPager/Assets/*.xcassets"

  # s.resource_bundles = {
  #   'VideoPager' => ['VideoPager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'

  s.frameworks = 'AVFoundation'

  # s.dependency 'Player'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
