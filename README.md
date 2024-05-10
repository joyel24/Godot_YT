# Godot_YT

Some work with Youtube Live API to get livechat comments and take some actions depending on comments (like to vote).
A shell script get json from api and for some matching patterns got in comments, it sends GET cmd to a specific url of my minimal rust httpserver, witch is also in this repo.
The godot "game" use GET cmd @ specific urls of the minimal rust http to do some actions. (ex: comment "!start" to start the game)
