Pod::Spec.new do |s|

  s.name = "DropDown"
  s.version = "0.1.5"
  s.summary = "A Material Design drop down"

  s.description = <<-DESC
                   This drop down is to overcome the loss of usability and user experience due to the UIPickerView. Material Design did a good job there so this drop down is very inspired by it. It appears at the right location instead of the bottom of the screen as default with UIPickerView and if possible, all options are displayed at once.
                   DESC

  s.homepage = "https://github.com/kevin-hirsch/DropDown"
  s.screenshots = "https://github.com/kevin-hirsch/DropDown/blob/master/Screenshots/1.png?raw=true", "https://github.com/kevin-hirsch/DropDown/blob/master/Screenshots/2.png?raw=true"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "kevin-hirsch" => "kevin.hirsch.be@gmail.com" }
  s.social_media_url = "http://twitter.com/kevinh6113"

  s.platform = :ios, '7.0'
  s.source = {
    :git => "https://github.com/Tzoani/DropDown.git",
    :tag => s.version.to_s
  }

  s.source_files = "DropDown/src", "DropDown/src/**/*.{h,m}", "DropDown/helpers", "DropDown/helpers/**/*.{h,m}"
  s.resources = "DropDown/resources/*.{png,xib}"
  s.requires_arc = true

end
