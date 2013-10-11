platform :ios, '7.0'

# Link with our unit test target, otherwise it will not build successfully.
link_with ['TCGoogleStreetView', 'TCGoogleStreetViewTests']

pod 'Google-Maps-iOS-SDK', '~> 1.5.0'
pod 'SDWebImage', '~> 3.5'

# Add OCMock for our unit test target only.
target 'TCGoogleStreetViewTests' do
    pod 'OCMock', '~> 2.2.1'
end