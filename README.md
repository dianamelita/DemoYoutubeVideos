# DemoYoutubeVideos
A demo application that fetches video information from the Youtube API

## Application Layers
I have split the application into 3 basic layers:
- Model Layer contains two separate objects, one for Video and another for VideoDetails. The reason for this is 
that the Youtube API does not contain all the needed information in one call (the duration property, needed for the "Video details" is only available in the 'videos' response, but not in the 'search' one).
Both model objects implement Decodable and manually decode their information. This was done because the response json is quite nested.
- Service Layer contains two separate services: one tasked with retrieval of all videos belonging to a channel and another, that retrieves the video information for a specific video.
- View Layer contains the View Controllers for both screens and a custom cell implementation. The view layer communicates with the model, as well as the service. 

## Challenges
One of the challenges when developing this app was the duration of the video, coming from the API in an ISO8601 format. This can look for example like "PT2M48S" and it translates to "2 minutes, 48 seconds". For this formatting, I have found an existing implementation on github:

[Swift-ISO8601-DurationParser](https://github.com/leonx98/Swift-ISO8601-DurationParser)

## Pods used
For image download I have used a pod, called SDWedImage, that makes image downloading really simple, having the option to provide a placeholder image:

[SDWebImage](https://github.com/SDWebImage/SDWebImage)

## Possible Improvements
Improvements could be made to the UI, adding a global tint color that is respected throughout the app, adding a search box to perform a search on the videos returned, pull down to refresh on the videos screen and improving the layout of the details screen. 

## Screenshots

Videos screen | Details screen 
---------------|--------------
| ![videos_screen](https://user-images.githubusercontent.com/45895514/61828089-d3cb0500-ae5d-11e9-9c01-aec0625b711d.png) | ![details_screen](https://user-images.githubusercontent.com/45895514/61828125-e3e2e480-ae5d-11e9-909d-8e0d6fef322d.png) 
