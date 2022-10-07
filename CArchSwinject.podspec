Pod::Spec.new do |spec|
    spec.name       = "CArchSwinject"
    spec.version      = "1.0.0"
    spec.summary      = "Библиотека для добавления зависимостей через Layout и Storybooard"
    spec.description  = <<-DESC
    Классы для автоматического добавления модулей в контейнер зависимостей
    DESC
    spec.license      = { :type => "MIT", :file => "LICENSE" }
    spec.author       = { "Ayham Hylam" => "Ayham Hylam" }
    spec.homepage     = "https://github.com/ayham-achami/CArchSwinject"
    spec.source       = {
        :git => "git@github.com:ayham-achami/CArchSwinject.git",
        :tag => spec.version.to_s
    }
    spec.frameworks   = ["Foundation", "UIKit"]
    spec.source_files = "Sources/**/*.{swift,h,m}"
    spec.ios.deployment_target = "13.0"
    spec.requires_arc = true
    spec.swift_versions = ['5.0', '5.1']
    spec.pod_target_xcconfig = { "SWIFT_VERSION" => "5" }
    spec.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }
    spec.dependency 'CArch'
    spec.dependency 'Swinject'
end
