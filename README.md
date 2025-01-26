# Godot_YT

Some work with Youtube Live API to get livechat comments and take some actions depending on comments (like to vote).


A shell script get json from Youtube API and for some matching patterns got in comments, it sends GET cmd to a specific url of my minimal rust httpserver, witch is also in this repo.


The godot "game" use GET cmd @ specific urls of the minimal rust http to do some actions. (ex: comment "!start" to start the game)


The http rust server is used as some kind of minimalist API/interface.

It's WILD: An sd script collect json from YT api, a mini rust http server parse json a do some actions with it, then godot ask to the mini rust api. (A/B score for a vote actually)
