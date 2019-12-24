#
# Be sure to run `pod lib lint SwiftWeeklyCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftWeeklyCalendar'
  s.version          = '0.1.0'
  s.summary          = 'Its a weekly calendar like native ios weekly calendar'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    This calendar works like the native iOS weekly calendar, it can be scrolled horizontally and vertically, horizontally if the pull is long scrolls to the next or previous week, if it is short it scrolls to the next or previous day
                       DESC

  s.homepage         = 'https://github.com/mmachado53/SwiftWeeklyCalendar'
  s.screenshots     = 'https://raw.githubusercontent.com/mmachado53/SwiftWeeklyCalendar/develop/readmefiles/explaining1.png'
  #s.screenshots      = 'https://raw.githubusercontent.com/mmachado53/SwiftWeeklyCalendar/develop/readmefiles/demo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mmachado53' => 'mmachado53@gmail.com' }
  s.source           = { :git => 'https://github.com/mmachado53/SwiftWeeklyCalendar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.youtube.com/channel/UCJBubs5ho9coIpr3Ze6V1RA'

  s.ios.deployment_target = '10.0'
  s.swift_versions = '5.0'

  s.source_files = 'SwiftWeeklyCalendar/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftWeeklyCalendar' => ['SwiftWeeklyCalendar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
