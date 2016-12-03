Pod::Spec.new do |s|
  s.name = "SSNavigato"
  s.version = "1.0.0"
  s.summary = "iOS App Navigator"
  s.homepage = "https://github.com/dulingkang/SSNavigatorFramework"
  s.license = 'MIT'
  s.authors = { "Shawn Du" => 'dulingkang@163.com' }

  s.platform = :ios, "7.0"
  s.requires_arc = true
  s.source = { :git => 'https://github.com/dulingkang/SSNavigatorFramework.git', :tag => s.version}
  s.source_files = 'SDWebImage/*.{h,m}'
s.description = 'This library provides a category for UIImageView with support for remote '

end
