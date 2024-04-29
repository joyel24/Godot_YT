API_key=""
client_id=""
client_secret=""
redirect_uri="http://127.0.0.1:8080"


if false
then
	/Applications/Firefox.app/Contents/MacOS/firefox "https://accounts.google.com/o/oauth2/auth?client_id=$client_id&redirect_uri=$redirect_uri&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube&response_type=code&include_granted_scopes=true&access_type=offline&state=state_parameter_passthrough_value"
	RUST_YT/target/debug/RUST_YT
	code=$(cat code.txt)
	echo code $code
	access_token=$(curl -s -X POST https://oauth2.googleapis.com/token -d "code=$code&client_id=$client_id&client_secret=$client_secret&redirect_uri=$redirect_uri&access_type=offline&grant_type=authorization_code" -H 'X-Origin: https://explorer.apis.google.com' -H 'Connection: keep-alive' | jq -r .access_token)
	#access_token="ya29.a0Ad52N3-vA4rB2BOF8BplwHqNmnm67G8I23HnZQ6TWY03rGnxxVWzoGtj08s0HBGhHVsgbafnPx1L5tVzEySu3ybvI-vR_cuE_QTQYeKFA1fAE-9WG3m7tvdaLaJ4diK6g_rhN0J3YX1QtVfjOV01eASMvr-9jUarFmbw4aCgYKAXkSARMSFQHGX2MiC0q6WNV8OmKjp7s1aEw8bg0174"
	echo $access_token > access_token.txt
	#echo access_token $access_token
fi

access_token=""
echo $access_token > access_token.txt
#cat access_token.txt #echo access_token $access_token

last_message_id_from_0=0
access_token=$(cat access_token.txt)
#chat_id=$(curl -s "https://youtube.googleapis.com/youtube/v3/liveBroadcasts?mine=true&key=$API_key" --header "Authorization: Bearer $access_token" --header 'Accept: application/json' --compressed -H 'X-Origin: https://explorer.apis.google.com' -H 'Connection: keep-alive' )

#echo $chat_id > chat_id.txt
#chat_id=$(cat chat_id.txt | jq -r '.items[0].snippet.liveChatId')

chat_id=""
#echo chat_id $chat_id

while true; do 
	
	#curl -s 'https://youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=KSnk0ckVHUkU&part=snippet&key=AIzaSyAcctdwPI' --header "Authorization: Bearer $access_token" --header 'Accept: application/json' --compressed > json.txt
	#curl -s "https://youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$chat_id&part=snippet&key=$API_key" --header "Authorization: Bearer $access_token" --header 'Accept: application/json' --compressed -H 'X-Origin: https://explorer.apis.google.com' -H 'Connection: keep-alive' > json.txt
	curl -s "https://content-youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$chat_id&part=snippet&key=$API_key" --compressed -H "Authorization: Bearer $access_token" -H 'X-Origin: https://explorer.apis.google.com' > json.txt
	
	echo " last: $last_message_id_from_0"
	echo " tot : $total_msg"
	total_msg=$(( $(jq -r '.pageInfo.totalResults' json.txt)-1 ))

	while [[ $last_message_id_from_0 < 74 ]]; do
		if [[ $last_message_id_from_0 == 0 ]]; then
			#bash -c "echo -n 0:" ; channel_id=$(jq -r ".items[0].snippet.authorChannelId" json.txt) ; channel_url=$(curl -s https://content-youtube.googleapis.com/youtube/v3/channels\?id\=$channel_id\&part\=snippet\&key\=$API_key -H 'X-Origin: https://explorer.apis.google.com' -H 'Connection: keep-alive' | jq -r ".items[].snippet.customUrl" | cut -c 2- ) ; zsh -c "echo -n $channel_url:" ; jq -r ".items[0].snippet.textMessageDetails.messageText" json.txt ; last_message_id_from_0=1 #if [[ $total_msg > 0 ]]; then last_message_id_from_0=1 ;fi
			bash -c "echo -n "0:$(jq -r '.items[0].snippet.authorChannelId' json.txt):" " ; jq -r ".items[0].snippet.textMessageDetails.messageText" json.txt ; last_message_id_from_0=1 #if [[ $total_msg > 0 ]]; then last_message_id_from_0=1 ;fi

			#sleep 5;
		else
			if [[ $last_message_id_from_0 -le $total_msg ]]; then
				#for ((i = last_message_id_from_0=1; i <= total_msg ; i=i+1)); do sleep 1; bash -c "echo -n $i:" ; channel_id=$(jq -r ".items[$i].snippet.authorChannelId" json.txt) ; channel_url=$(curl -s https://www.googleapis.com/youtube/v3/channels\?id\=$channel_id\&part\=snippet\&key\=$API_key -H 'X-Origin: https://explorer.apis.google.com' -H 'Connection: keep-alive' | jq -r ".items[].snippet.customUrl" | cut -c 2- ) ; zsh -c "echo -n $channel_url:" ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt; done
				for ((i = last_message_id_from_0; i <= total_msg ; i=i+1)); do bash -c "echo -n "$i:$(jq -r ".items[$i].snippet.authorChannelId" json.txt):" " ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt ; last_message_id_from_0=$(($i+1)) ; last_message_id=$(jq -r ".items[$i].id" json.txt) ; done
				sleep 5
			fi
		fi
	done
		if [[ $last_message_id_from_0 == 75 ]]; then
			#current_message_id=$(jq -r '.items[74].id' json.txt)
			if [[ $last_message_id != $current_message_id ]]; then
				for ((i = 74; i >= 0 ; i--)); do 
				current_message_id=$(jq -r ".items[$i].id" json.txt)
				if [[ $last_message_id == $current_message_id ]]; then
				  last_message_id_from_0=$((i+1))
				  break
				fi
				done
				echo " last: $last_message_id_from_0"
				echo " tot : $total_msg"
				for ((i = last_message_id_from_0; i <= total_msg ; i=i+1)); do bash -c "echo -n "$i:$(jq -r ".items[$i].snippet.authorChannelId" json.txt):" " ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt ; last_message_id=$(jq -r ".items[$i].id" json.txt) ; done
				#last_message_id_from_0=$((last_message_id_from_0+1))
			fi
		fi
	#else
		sleep 5
	

	#echo last: $last_message_id_from_0
	#echo tot : $total_msg
done



