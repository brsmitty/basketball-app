# basketball-app
# Overview #
  - The project follows a rough Model-View-Controller setup, with most emphasis on views and controllers. 
  - Files that inherit from UITableViewCell 
    - The “view” in MVC
    - Follow …ViewCell naming convention
    - All visual elements are represented as tables, these files control the view of these tables
    - Two functions common in most of these files: 
        - awakeFromNib
          - Initialization
        - setSelected
            - Change the state of the cell to be selected, may change appearance/initiate transitions
   - Files that inherit from UIViewController
      - The “C” in MVC
      - Follow …ViewController naming convention
      - Handles logic, interactions, and actions, updates views to match
      - Common function
        - viewDidLoad()
          - Controls necessary information when initializing
          - Usually overridden
  - Storyboard files (Main and LaunchScreen)
      - Visual files that control interactions between screens, segues, and display how each screen is connected to the others
      - Shows and controls positioning of visual assets
  - Other files
    - Files that do not follow naming conventions are either models to be reference by view and controller files, or unfinished
# List of folders/files included #
  - TeamSummary
    - Includes files for the game summary page
  - CalendarViews 
    - Include files for the calendar icon (on season summary and game summary page)
  - SeasonSummary
    - Include files for the season summary page
  - BoxScores
    - Includes file for box score icon (four arrows pointing outwards (on season summary and game summary page))
  - Performance
    - Seems to control overall menu function. Switches between pages.
  - Asset
    - Image assets to use for visual
  - ScheduleManager
    - Include files to schedules games
  - PlayerManager
    - Include files to create and manages players
  - Lineup
    - Include files for the player lineups
  - Login
    - Include files for login page
  - Playbook
    - Include files for inserting a playbook pdf into the playbook page
  - LoginTextField
    - Creates a text field for the login screen
  - Unfiled
    - AppDelegate
      - Handles all app functionality with background idle and foreground termination
    - FireRoot
      - Handles the connection to Firebase
    - DropDownTableViewCell
      - Creates a drop down menu for viewing the tables
    - GameViewController
      - Handles the game page (basketball icon)
    - ShotChartViewController
      - Handles the shot chart view
    - FreethrowViewController
      - Handles the free throw view
    - DefaultUITextField
      - Sets the fonts, color, and size for the texts fields
    - TimerTest
      - Testing out the timer in the basketball icon page
    - SettingsViewController
      - Handles the view for the settings page
    - BenchViewController
      - Handles the bench view in basketball icon page
    - DropDownViewController
      - Handles logout functionality
    - UIImageViewExtension
      - Controls animation
    - BenchTableViewCell
      - Controls view of bench table
    - Action
      - Initialize the players in the basketball icon page
    - Possession
      - Appends possession to the player in basketball icon page
    - DBApi
      - Interaction with database
    - AdminSettingsViewController
      - Handels the admin settings page
    - UserAuthUITests
      - Test cases for user authentication
    - gestureUITests
      - Test cases for touching the screen
    - subPlayersUITests
      - Test cases for players
    - lineupUITests
      - Test cases for player lineup
    - playerManageTests
      - Test cases for managing players
    - lineupManageTests
      - Test cases for managing the player lineups
    - loginUnitTests
      - Test cases for logging in
    - basketballAppUnitTests
      - Test cases for overall app
    - basketballAppIntegrationsTests
      - Test cases for integrating KPI, player management, playbook, performance page, and basketball icon page

# Known Bugs #
  - TeamSummaryViewController
    - In openSettings, issue with tapping three dots to open settings screen. will crash with fatal error
    - In closeSettings, issue when tapping game summary while already on game summary page, will crash with fatal error

# Running instructions  (For more detailed explanation, please refer to the hand off documentation) #

1. Download zip file from Google Drive (https://drive.google.com/file/d/1OAQZ3qYI7v58MaxzdZZpEeL89J_1nxdp/view?usp=sha ring)
2. Optional: Move the zip file somewhere else on your computer.
3. Unzip the file.
4. Open XCode.
a. We have been working off of XCode 12. If you don’t have XCode 12 you will need to update the application from the App Store.
5. In XCode, click “Open a project file” and browse to where you put the basketball-app folder and select open.
6. Once the project opens, you may need to install the emulator we use to run it. 
    - Go to the top of the bar and click on the device that is listed there
    - If iPad Air 2 (12.0) is available, select that. 
    - If not, you need to download it
    - Click on that box again.
    - Browse to the bottom of the list of simulators and select “Download Simulators”.
    - Click the download button for iOS 12.0.
    - Once it downloads you should be able to select iPad Air 2 (12.0) from the list of simulators
7. Click on Source Control in the top bar of the page.
a. Click on Pull…
b. Scroll down and find the branch named “origin/master” and pull it.
c. Every time we make new changes and you want to see them you will have to redo this step.
8. To run the app press the play button in the top left that is next to the simulator button
from earlier.
a. A new window will open up that is an iPad running the app. You may have to click the rotate screen button to get it to be landscape view.
b. Create an account on the login screen.
c. You’re in!
9. To stop the app, you can just close the window the simulator is running in.
