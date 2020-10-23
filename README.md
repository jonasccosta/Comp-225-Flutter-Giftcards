# Card Safe

## Synopsis:
The goal of this project is to create an app that can store gift cards. This app allows users to input information both manually and through image scraping, making it convenient and accurate for storing gift cards.

The purpose of this project is to better understand the practices involved in developing software. More specifically, working cooperatively as a team to design and create an effective software product for our COMP 225 Software Design and Development class taught by Shilad Sen.

## Architecture:
All the information about the card is stored locally on the user’s device, using a SQLite database.

## Framework:
We are using Flutter inside of Android Studio.

## Testing:
Thank you to all of those who helped us with user testing! Their feedback allowed us to make crucial user interface changes in order to make the app overall easier to operate.

## How to Download and install the app:
1. Download android studio
 - <https://developer.android.com/studio>


2. Download the Flutter SDK from Android Studio
  - A helpful guide for getting it set up can be found here: <https://flutter.dev/docs/get-started/install>


3. Pull github code for this project.
  - <https://github.com/thayes8/Comp-225-Flutter-Giftcards>


4. Make sure the dependencies are up to date in the pubspec.yaml file


   - Do a pub get and a pub upgrade
5. Install the Android Studio Emulator or Enable Developer Settings on your device
    - Emulator : <https://developer.android.com/studio/run/emulator>
    - Developer Settings : <https://developer.android.com/studio/debug/dev-options>


6. Optional:
   If you wish to use the nanonets API for scraping individualized data from gift cards; Go to App.nanonets.com, create a new account to get 100 free API calls, create a new model and follow instructions to train it to grab card number and expiration date from a giftcard in that order. The only things you will need to change in the code is in the Image_Scraping.dart file in the lib folder of the project. You must change the Url string found in the URI.parse() method to be your own personal API url found in your nanonets account in the integrate section code samples. You must then base64 encode the API key found in the same code sample section which can be done at <https://www.base64encode.org/> then put the result from that site into the string next to 'Basic' in place of the long string of characters in the string found in this line: `(request.headers[authorization] = 'Basic UnYxTWdIdDc5bGlhb2ExdUxkQjVaU0FxSkNNZTFIbXo6';)`
Now the app will be set up to scan cards!

## Known Bugs:
After editing a gift card, it can’t be deleted right away. After going back to the home screen and clicking on the delete button again, the card can be successfully deleted.

## Authors:
- Jonathan Neve
- Tommy Hayes
- Jonas Costa
- Kirk Lobban

## Acknowledgements:
Thanks to Professor Shilad Sen, preceptor Richard Tian, classmates at the Software Design and Development Class, and everyone who participated in user testing.