CREATOR HUB - FINAL BUILD

Core workflow:
Student signup/login -> profile -> portfolio -> discover collaborations -> apply -> application tracking.
Creator signup/login -> profile -> creator portfolio -> create collaboration -> review applicants -> accept/reject -> complete collaboration -> transfer credits.
After completion, the selected student can rate the creator.
Students can discover creators and like creator profiles.

Permanent uploads:
~/CreatorHubUploads/
Uploads are stored outside Tomcat so redeployment does not delete portfolio files.

Sidebar:
Student: Dashboard, Discover Collaborations, My Applications, Creators, My Portfolio, My Profile, Leaderboard, My Reputation, Logout.
Creator: Dashboard, Create Collaboration, My Collaborations, Applicants, My Portfolio, My Profile, Leaderboard, My Reputation, Logout.

UI fixes:
- Top bar shows only Logout on logged-in pages.
- Sidebar contains no emoji icons.
- Custom Accept/Reject modal replaces browser confirm popup.
- Selected student metric shows 0/1, not the student database ID.
- Applications are managed from My Applications; portfolio pages contain portfolio work only.
- Sidebar arrows use HTML entities to avoid encoding/mojibake issues.

Database:
Database: creator_hub
Existing upgrade.sql contains the required enhanced tables/columns.

Compile:
javac -cp "WEB-INF/lib/*" -d WEB-INF/classes src/com/creatorhub/bean/*.java src/com/creatorhub/dao/*.java

Deploy:
/opt/homebrew/opt/tomcat/libexec/bin/shutdown.sh
rm -rf /opt/homebrew/opt/tomcat/libexec/webapps/CreatorHub
cp -R ~/Desktop/CreatorHub_Enhanced /opt/homebrew/opt/tomcat/libexec/webapps/CreatorHub
/opt/homebrew/opt/tomcat/libexec/bin/startup.sh
