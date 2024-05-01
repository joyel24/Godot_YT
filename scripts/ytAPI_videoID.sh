API_key=""
client_id=""
client_secret=""
redirect_uri="http://127.0.0.1:8080"
livestread_id=""

if true
then
	/Applications/Firefox.app/Contents/MacOS/firefox "https://accounts.google.com/o/oauth2/auth?client_id=$client_id&redirect_uri=$redirect_uri&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube&response_type=code&include_granted_scopes=true&access_type=offline&state=state_parameter_passthrough_value"
	RUST_YT/target/debug/RUST_YT
	code=$(cat code.txt)
	echo code $code
	access_token=$(curl -s -X POST https://oauth2.googleapis.com/token -d "code=$code&client_id=$client_id&client_secret=$client_secret&redirect_uri=$redirect_uri&access_type=offline&grant_type=authorization_code" | jq -r .access_token)
	echo $access_token > access_token.txt
	echo access_token $access_token
fi
last_message_id=0
access_token=$(cat access_token.txt)
#curl -s "https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet&mine=true&key=$API_key" --header "Authorization: Bearer $access_token" --header 'Accept: application/json' --compressed > chat_id.txt
url -s https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet&id=$livestread_id&key=API_key --header "Authorization: Bearer $access_token" --header 'Accept: application/json' --compressed
chat_id=$(cat chat_id.txt | jq -r '.items[0].snippet.liveChatId')
#echo chat_id $chat_id
while true
	
	#do curl -s 'https://youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=KicKGFVDUjBvTm5ObU5JX0x6Nk0ckVHUkU&part=snippet&key=$API_key' --header "Authorization: Bearer $access_token" --header 'Accept: application/json' --compressed > json.txt
	do curl -s "https://youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$chat_id&part=snippet&key=$API_key" --header "Authorization: Bearer $access_token" --header 'Accept: application/json' --compressed > json.txt
	
	total_msg=$(( $(jq -r '.pageInfo.totalResults' json.txt)-1 ))
	if [[ $last_message_id < $total_msg ]]; then
		if [[ $last_message_id == 0 ]]; then
			bash -c "echo -n 0:" ; channel_id=$(jq -r ".items[0].snippet.authorChannelId" json.txt) ; channel_url=$(curl -s https://www.googleapis.com/youtube/v3/channels\?id\=$channel_id\&part\=snippet\&key\=$API_key | jq -r ".items[].snippet.customUrl" | cut -c 2- ) ; zsh -c "echo -n $channel_url:" ; jq -r ".items[0].snippet.textMessageDetails.messageText" json.txt ; last_message_id=1 #if [[ $total_msg > 0 ]]; then last_message_id=1 ;fi
		else
			for ((i = last_message_id=1; i <= total_msg ; i=i+1)); do bash -c "echo -n $i:" ; channel_id=$(jq -r ".items[$i].snippet.authorChannelId" json.txt) ; channel_url=$(curl -s https://www.googleapis.com/youtube/v3/channels\?id\=$channel_id\&part\=snippet\&key\=$API_key | jq -r ".items[].snippet.customUrl" | cut -c 2- ) ; zsh -c "echo -n $channel_url:" ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt; done
			last_message_id=$((total_msg))
			sleep 5
		fi
	fi
	#echo last: $last_message_id
	#echo tot : $total_msg
done



