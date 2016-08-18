Pod::Spec.new do |spec|
  spec.name = 'JWCache'
  spec.version = '0.0.1'
  spec.summary = 'Simple in memory and on disk cache.'
  spec.description  = 'Simple in memory and on disk cache for iOS and Mac OS X.'
  spec.homepage = 'http://gitlab.txxia.com:81/wangjunwu/JWCache.git'
  spec.author = { 'Jeffery Wang' => 'weiwu.ms@gmail.com' }
  spec.source = { :git => 'http://gitlab.txxia.com:81/wangjunwu/JWCache.git', :tag => "v#{spec.version}" }
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.ios.deployment_target = '7.0'
  spec.ios.frameworks = 'Foundation', 'UIKit'
  spec.ios.source_files = ['JWCache/JWCache.{h,m}', 'JWCache/JWCache+Private.{h,m}', 'JWCache/JWCache+Image.{h,m}']

  spec.watchos.deployment_target = '2.0'
  spec.watchos.frameworks = 'Foundation', 'WatchKit'
  spec.watchos.source_files = ['JWCache/JWCache.{h,m}', 'JWCache/JWCache+Private.{h,m}', 'JWCache/JWCache+Image.{h,m}']

  spec.osx.deployment_target = '10.9'
  spec.osx.frameworks = 'Foundation'
  spec.osx.source_files = ['JWCache/JWCache.{h,m}', 'JWCache/JWCache+Private.{h,m}']
end
