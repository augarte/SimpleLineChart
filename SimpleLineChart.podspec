Pod::Spec.new do |spec|
  spec.name         = "SimpleLineChart"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of SimpleLineChart."
  
  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "http://github.com/augarte/SimpleLineChart"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Aimar Ugarte" => "ugarteaimar@gmail.com" }

  spec.platform     = :ios, "13.0"

  spec.source       = { :git => "http://github.com/augarte/SimpleLineChart.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Sources/*.swift"
  spec.exclude_files = "Classes/Exclude"

end
