Pod::Spec.new do |spec|

spec.name         = "YouCanPay"
spec.version      = "0.0.4"
spec.summary      = "The YCPayment iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app."
spec.description  = <<-DESC
The YouCanPay iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app. We provide a powerful and customizable WKWebview that can be used to handle 3DS step and build a fully custom experience.
DESC
spec.homepage     = "https://github.com/NextmediaMa/youcan-pay-ios-sdk"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author             = { "YouCan Pay Team" => "https://pay.youcan.shop/" }
spec.platform     = :ios
spec.ios.deployment_target = "13.0"
spec.swift_version = "5"
spec.source       = { :git => "https://github.com/NextmediaMa/youcan-pay-ios-sdk.git", :tag => "#{spec.version}" }
spec.source_files  = "Sources/YouCanPay/**/*.swift"
spec.resources = "Sources/YouCanPay/resources/*"
spec.dependency "Alamofire", '~> 5.0.0'

end
