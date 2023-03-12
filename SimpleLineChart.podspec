Pod::Spec.new do |s|
  s.name         = "SimpleLineChart"
  s.version      = "1.0.0"
  s.summary      = "Simple line charts for iOS 📈"
  s.description  = "SimpleLineChart is a simple, lightweight line chart library for iOS. It provides an easy-to-use interface to create customizable line charts with a few lines of code. The library supports customizable styles. It's a great option for developers who need to quickly add line charts to their iOS apps without the overhead of a larger, more complex charting library."
  s.homepage     = "https://github.com/augarte/SimpleLineChart"
  s.screenshots  = "Screenshots/SLC.JPG", "Screenshots/SLC_Styled.JPG"
  s.license      = { :type => "GPL", :file => "LICENSE" }
  s.author       = { "Aimar Ugarte" => "ugarteaimar@gmail.com" }
  s.source       = { :git => "https://github.com/augarte/SimpleLineChart.git", :tag => "v#{s.version}" }
  s.platform      = :ios, "13.0"
  s.swift_version = '5.0'
  s.source_files  = "Sources/SimpleLineChart/**/*"
end
