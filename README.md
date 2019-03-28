Roommate finder for students and alumni at UT Austin.

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

