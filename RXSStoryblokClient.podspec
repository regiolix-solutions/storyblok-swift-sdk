#
# Be sure to run `pod lib lint RXSStoryblokClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RXSStoryblokClient'
  s.version          = '0.1.8'
  s.summary          = 'A lightweight pure Swift SDK for the Storyblok Content Delivery and Management APIs'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'This is a Swift SDK/Wrapper around the Storyblok Delivery API and the Storyblok Management API. The purpose of this Pod is to make using said APIs easier, quicker and more readable.'
                       DESC

  s.homepage         = 'https://github.com/regiolix-solutions/storyblok-swift-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Medweschek Michael' => 'michael@regiolix.at' }
  s.source           = { :git => 'https://github.com/regiolix-solutions/storyblok-swift-sdk.git', :tag => '0.1.8' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.0'

  s.source_files = 'Sources/**/*.swift'
  
  # s.resource_bundles = {
  #   'RXSStoryblokClient' => ['RXSStoryblokClient/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
