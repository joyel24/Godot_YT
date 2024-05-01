export $(xargs < vars.txt)

curl -s "https://content-youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$chat_id&part=snippet&key=$API_key" --compressed -H "Authorization: Bearer $access_token" -H 'X-Origin: https://explorer.apis.google.com' > json.txt
total_messages=$(( $(jq -r '.pageInfo.totalResults' json.txt)-1 ))

for ((i = $last_message_id_from_0; i <= $total_messages ; i++)); do
  last_message_id=$(jq -r ".items[$i].id" json.txt)
  #echo " last_message_id:$last_message_id"
  #echo " current_message_id:$current_message_id"
  if [[ $last_message_id == $current_message_id ]]; then
    #echo "  last_message_id_from_0=$i"
    break
  fi
  bash -c "echo -n "$i:$(jq -r ".items[$i].snippet.authorChannelId" json.txt):" " ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt
  current_message_id=$(jq -r ".items[$i].id" json.txt)
  last_message_id_from_0=$i
  #echo "1F+last_message_id_from_0=$last_message_id_from_0"
  #echo $current_message_id
  message=$(jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt)
  if [[ $message == "!1" ]]; then curl -s 'http://127.0.0.1:8080/index.html?&!1' > /dev/null; fi
  if [[ $message == "!2" ]]; then curl -s 'http://127.0.0.1:8080/index.html?&!2' > /dev/null; fi
  if [[ $message == "!start" ]]; then curl -s 'http://127.0.0.1:8080/index.html?&!start' > /dev/null; fi

done


while true; do 
  curl -s "https://content-youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$chat_id&part=snippet&key=$API_key" --compressed -H "Authorization: Bearer $access_token" -H 'X-Origin: https://explorer.apis.google.com' -H 'Connection: keep-alive' > json.txt
  total_messages=$(( $(jq -r '.pageInfo.totalResults' json.txt)-1 ))
  #echo "total_messages $total_messages"
  #echo "last_message_id_from_0 $last_message_id_from_0"
  last_message_id=$(jq -r ".items[$total_messages].id" json.txt)

  #echo " last_message_id   :$last_message_id"
  #echo " current_message_id:$current_message_id"

  if [[ $last_message_id != $current_message_id ]]; then
    #echo "yololoooo"  
    for ((i = $total_messages ; i >= $last_message_id_from_0; i--)); do
      last_message_id=$(jq -r ".items[$i].id" json.txt)
      
      if [[ $last_message_id == $current_message_id ]]; then
        if [[ $i == 74 ]]; then echo "NOOO"; break;  fi
        #bash -c "echo -n "$i:$(jq -r ".items[$i].snippet.authorChannelId" json.txt):" " ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt
        #echo "FR2B:last_message_id_from_0=$i"
        last_message_id_from_0=$((i+1))
        last_message_id=$(jq -r ".items[$i].id" json.txt)
        current_message_id=$(jq -r ".items[$i].id" json.txt)
        if [[ $last_message_id != $current_message_id ]]; then echo "bllellfefk"; fi
        #break
      fi
    done
      #echo " last_message_id   :$last_message_id"
      #echo " current_message_id:$current_message_id"
      #echo "MAMENE:last_message_id_from_0=$last_message_id_from_0"
    for ((i = $((last_message_id_from_0)) ; i <= $total_messages ; i++)); do
      #echo "MAMENE $i"
      last_message_id=$(jq -r ".items[$i].id" json.txt)
      # if [[ $last_message_id == $current_message_id ]]; then
      #   break
      # fi
      bash -c "echo -n "$i:$(jq -r ".items[$i].snippet.authorChannelId" json.txt):" " ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt
      current_message_id=$(jq -r ".items[$i].id" json.txt)
      last_message_id_from_0=$i
      message=$(jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt)
      if [[ $message == "!1" ]]; then curl -s 'http://127.0.0.1:8080/index.html?&!1' > /dev/null; fi
      if [[ $message == "!2" ]]; then curl -s 'http://127.0.0.1:8080/index.html?&!2' > /dev/null; fi
      if [[ $message == "!start" ]]; then curl -s 'http://127.0.0.1:8080/index.html?&!start' > /dev/null; fi
    done
  fi
   sleep 3
done

# while true; do 
#   curl -s "https://content-youtube.googleapis.com/youtube/v3/liveChat/messages?liveChatId=$chat_id&part=snippet&key=$API_key" --compressed -H "Authorization: Bearer $access_token" -H 'X-Origin: https://explorer.apis.google.com' > json.txt
#   total_messages=$(( $(jq -r '.pageInfo.totalResults' json.txt)-1 ))
#   #echo $total_messages
#   for ((i = $last_message_id_from_0; i <= $total_messages ; i++)); do
#     last_message_id=$(jq -r ".items[$i].id" json.txt)
#     echo " last_message_id:$last_message_id"
#     echo " current_message_id:$current_message_id"
#     if [[ $last_message_id == $current_message_id ]]; then
#       echo "  last_message_id_from_0=$i"
#       last_message_id_from_0=$i
#       break
#     fi
#     bash -c "echo -n "$i:$(jq -r ".items[$i].snippet.authorChannelId" json.txt):" " ; jq -r ".items[$i].snippet.textMessageDetails.messageText" json.txt ; current_message_id=$(jq -r ".items[$i].id" json.txt)
#     echo $current_message_id
#   done

#   sleep 10
# done



