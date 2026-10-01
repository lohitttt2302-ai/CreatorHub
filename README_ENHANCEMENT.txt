CREATOR HUB - ENHANCED VERSION
================================

New features:
- Modern bright UI across the main pages
- Student/Creator signup + role-based login
- Student portal and public student profile
- Student skills, bio, LinkedIn and portfolio
- Portfolio file upload (small files, up to about 1.5 MB)
- Application form with suitability pitch, LinkedIn and previous work upload
- Creator can view applicant profile and previous work
- Student -> Creator and Creator -> Student profile likes
- Student leaderboard
- Creator leaderboard
- Collaboration completion workflow
- Creator transfers credits to selected student
- Student credit balance
- Student can rate creator after completed collaboration
- Creator profile displays rating/reviews
- Creator dashboard displays applicants, profiles and portfolio links

DATABASE FIRST
--------------
Run upgrade.sql in phpMyAdmin while using the creator_hub database.

The SQL is designed to preserve the existing tables/data and add the new fields/tables.

PROJECT COMPILE
---------------
From the CreatorHub project folder:

javac -cp "WEB-INF/lib/*" -d WEB-INF/classes src/com/creatorhub/bean/*.java src/com/creatorhub/dao/*.java

DEPLOY TO TOMCAT
----------------
Copy the project JSP/CSS files and compiled classes to your existing Tomcat webapps/CreatorHub folder.

The current local setup used:
 /opt/homebrew/opt/tomcat/libexec/webapps/CreatorHub/

For a full project deployment after backing up the old deployed folder, copy the enhanced project contents there.

FILE UPLOAD NOTE
----------------
The upload UI converts the selected file to Base64 in the browser and saves the decoded file under the deployed application's uploads/ folder. For this PBL version, keep uploads below about 1.5 MB.

PASSWORD NOTE
-------------
The existing project stores passwords as plain text for compatibility with the current Students table and login flow. This enhancement does not silently change that schema.
