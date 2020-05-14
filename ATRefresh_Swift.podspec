
Pod::Spec.new do |s|
  s.name             = 'ATRefresh_Swift'
  s.version          = '0.0.3'
  s.summary          = 'Some classes and class category commonly used in iOS rapid development'
  s.description      = <<-DESC
                       Some classes and class category commonly used in iOS rapid development.
                       DESC
  s.homepage         = 'http://blog.cocoachina.com/227971'
  s.license          = 'MIT'
  s.author           = { 'tianya2416' => '1203123826@qq.com' } 
  s.source           = { :git => 'https://github.com/tianya2416/ATRefresh_Swift.git', :tag => s.version }
  s.swift_version    = '5.0'
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source_files     = 'Source/*.{h,swift}'
  
  s.dependency       'Alamofire', '~> 4.9.1'
  s.dependency       'DZNEmptyDataSet', '~> 1.8.1'
  s.dependency       'KVOController','~> 1.2.0'
  s.dependency       'MJRefresh','~> 3.4.3'
  
  s.public_header_files = 'Source/ATRefresh_Swift-Bridging-Header.h'
end




