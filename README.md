Roommate finder for students and alumni at UT Austin.

# Beta Release README

## Contributions:
    Lindsey Thompson (%)
    Maria Ocanas (%)
        * Implemented Card Swiping
            - Created card objects to hold profile information, pulling information such as name, occupation, etc
            - Add animation functionality which goes through the database information and updates swiping records
        * Swiping Functionality with Firebase
            - Updated database model to reflect swiping records and update user information
                - If users "like" another user, the information will be stored, which is then compared to the other user's swiping records
                - All matches are recorded and prompted to start a conversation with eachother
         * Button Updates for Swiping
            - Changed the button functionality on the swiping page in order to match the swiping mechanics, including animation and database updating
            
    Michelle Gu (%)
        * Designed database
            - Wrote some example JSON
            - Updated models accordingly
        * Settings functionality
            - Account settings -- Change password, Logout button, Delete account, Began FB/Google connection
            - Notifications -- Update user input values to Firebase
            - Discovery
                - Update user input values to Firebase
                - Created select all lists for filters that update to Firebase
        * Profile Creation updates
            - Update user, location, gender, and university data to Firebase
            - Added default settings
            - Fixed invalid login bug
    Pearl Xie (%)
        * Maps View Controller during Profile Creation 
            - Ability to search for a location on map 
            - Add a placemark to list of cities willing to relocate to 
            - Show list of cities that have been added (up to 3)
            - Click on a city button to remove it from list
            - Update adding/removing cities into Firebase
        * Profile Creation View Controller
            - Updated the text field with the locations set via map from the data in Firebase
            - Disabled user ability to input into that text field
        * Maps View Controller via Settings
            - Pulling current location preferences via Firebase and displaying them (TODO)
            - Ability to edit and update future locations (aka everything you can do in the above controller, you can do here)

## Deviations:
    * Maps (Pearl):
        - Only allowing users to set up to three future locations for simplicity (also who looks for relocations for that many different places anyway)
        - Might not implement an option to bring up Maps during Swiping because unsure of the purpose it would serve. Seeing other users' exact locations on a map might come with privacy issues. Also not sure how much it would help or matter when searching for a roommate.
    
## Notes:
    * Please run on an iPhone XS! 
    * Things we didn't plan for this release but are aware of:
        * Maps (Pearl):
            - Error checking that will be left for Final Release:
                1. Placing a placemark in the exact location. Currently all search capabilities of a location is handled by Apple's MapKit, but it's not exactly the most accurate. If you search for Boston, it places you nearly in the
                2. Setting the initial map view to the user's location as opposed to having it hardcoded to San Francisco right now Atlantic ocean. Not sure how I can fix that but it'd be worth looking into for Final Release.
            - Other that will be attempted for Final Release:
                1. Allowing users to set a radius of how far they want to search for housing around a certain pinpoint. Making it a stretch goal because it would also come with calculating the distance between two users' coordinates and radiuses and determining if they'd be compatible to appear in each others' swipe searches. This is also dependent on Maria's portion of Swiping.
         * Swiping (Maria):
            - Error checking that will be left for Final Release:
                1. After all cards are swiped through, the app will crash upon continually pressing the yes/no buttons. This can be fixed by adding a notification once the database has been traversed and will be implemented for Final.
            - Populating the Profile Cards and profile page left for Final Release:
                1. The card labels are not being pulled from the database, apart from the name. This is a simple pull from the database once we establish that some fields are mandatory, so as to not cause conflict with nil values.
                2. Right now the user is unable to view the prosepctive roommate's profile fully. For the final release, we plan on implementing a view specifically for this, much like the user's own profile view, so that all the information can be displayed upon selecting the card displayed. 
                3. We do not hold profile pictures in Firebase as of yet, so for the final release we plan on implementing this storage and pulling these pictures into the cards to replace the stock image currently there.


# Alpha Release README

## Contributions:
    Lindsey Thompson (35%)
        * Learned about UI and design/styling
        * Created VCs classes, screens, and segues for Home, Messaging, Onboarding, Profile, Swipe
            * Added general styling for app
        * Learned about custom nav and created custom nav bar
    Maria Ocanas (20%)
        * Created all settings screens and segues
    Michelle Gu (25%)
        * Account Creation with Firebase
        * Added Firebase functionality and worked on model for Profile Creation screens
        * Added logic to VC classes
    Pearl Xie (20%)
        * Created Profile Edit screen
        * Added Firebase functionality and worked on model for Profile Creation screens
        * Added logic to VC classes

## Deviations:
    * Did not create the following view controllers:
        * View a profile through Messages (Still figuring out custom navigation)
        * Card swiping (Still figuring out custom navigation)
        * Running out of cards to swipe shows a map from the Home view (Card swiping is not yet working)
        * Login screen does not go directly to Swipe -- Profile gets recreated every time (Still working on custom navigation)
    * Note: Account creation/Login -- alerts/user error checking are not functional due 
            to a Window hierarchy problem, However, we included debugging in beta, and if
            done correctly, account creation and login are fully functional.
            When testing, please sign up first using a valid email address and strong
            password. During profile creation, fill in at least your name and birthday to avoid errors later.

