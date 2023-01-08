Pod::Spec.new do |s|
  s.name         = "SimpleLineChart"
  s.version      = "0.0.1"
  s.summary      = "Simple line charts for iOS 📈"
  
  # s.description  = <<-DESC
  #                 DESC

  s.homepage     = "https://github.com/augarte/SimpleLineChart"
  # s.screenshots  = "", ""
  s.license      = { :type => "GPL", :file => "LICENSE" }
  s.author       = { "Aimar Ugarte" => "ugarteaimar@gmail.com" }
  s.source       = { :git => "https://github.com/augarte/SimpleLineChart.git", :tag => "v#{s.version}" }

  s.platform      = :ios, "13.0"
  s.swift_version = '5.0'
  s.source_files  = "Sources/SimpleLineChart/**/*"
end
