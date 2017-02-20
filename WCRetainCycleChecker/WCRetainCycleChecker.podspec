Pod::Spec.new do |s|
  s.name         = 'WCRetainCycleChecker'
  s.version      = '1.0.0'
  s.summary      = "Check retain-cycle in UIViewController's subclass automatically."
  s.author       = { "王策" => "634692517@qq.com" }
  s.homepage     = "https://github.com/HaloWang/WCRetainCycleChecker"
  s.platform     = :ios, "7.0"
  s.source       = { :path => '.' }
  s.source_files = "*.{h,m}"
end
