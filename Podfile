# Sources
source 'https://github.com/CocoaPods/specs.git'

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

def common_pods
  # Control
  pod 'SwiftLint'
  # Architecture
  pod 'CArch', :git => 'https://github.com/ayham-achami/CArch.git', :branch => 'mainline'
  # Dependency injection
  pod 'Swinject'
end

target 'CArchSwinject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for CArchSwinject
  common_pods
  target 'CArchSwinjectTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods
  end
end

target 'Playground' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Common
  common_pods
  # Pods for Playground
end
