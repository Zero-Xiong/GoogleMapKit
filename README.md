GoogleMapKit

Self learn Google Map IOS SDK Development

Dart (https://www.dartlang.org/)

Let’s go over the steps for running the server:

1.  Download the server code (https://github.com/domesticmouse/places-api-key-proxy).

2.  To install Dart, you’ll use Homebrew. Homebrew is a package manager for mac that allows simple installation of various packages. If you do not already have it installed, open Terminal and run:
 
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

3.  When Homebrew is done installing, run the following command in Terminal:
    brew tap dart-lang/dart

4.  Install Dart by running the following command in Terminal:
    brew install dart

5.  Next, locate the path where you downloaded the server code to, and open it in terminal:
    cd [PATH_TO_SERVER_CODE]

6.  Install the server code by running the following in Terminal:
    pub install

7.  Finally, run the server with the following command:
    pub run bin/main.dart -k [YOUR_API_KEY] -p 10000

Replace YOUR_API_KEY with the server key you created earlier


SwiftyJSON

pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'

