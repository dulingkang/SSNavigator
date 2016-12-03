Pod::Spec.new do |s|
  s.name = "SSNavigatorFramework"
  s.version = "1.0.0"
  s.summary = "iOS App Navigator"
  s.homepage = "https://github.com/dulingkang/SSNavigatorFramework"
  s.license = 'MIT'
  s.authors = { "Shawn Du" => 'dulingkang@163.com' }

  s.platform = :ios, "7.0"
  s.requires_arc = true
  s.source = { :git => 'https://github.com/dulingkang/SSNavigatorFramework.git', :tag => s.version}
  s.public_header_files = 'SSNavigatorFramework/SSNavigatorFramework.h'
  s.source_files = 'SSNavigatorFramework/SSNavigatorFramework.h'
  s.description = 'This library provides navigator between app and html'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Core'
    ss.public_header_files = 'Core/*.h'
  end

  s.subspec 'Animation' do |ss|
    ss.source_files = 'Animation'
    ss.public_header_files = 'Animation/*.h'
  end

  s.subspec 'JSBridge' do |ss|
    ss.source_files = 'JSBridge'
    ss.public_header_files = 'JSBridge/*.h'
  end

  s.subspec 'NSStringCategory' do |ss|
    ss.source_files = 'NSStringCategory'
    ss.public_header_files = 'NSStringCategory/*.h'
  end

  s.subspec 'Protocol' do |ss|
    ss.source_files = 'Protocol'
    ss.public_header_files = 'Protocol/*.h'
  end

end
