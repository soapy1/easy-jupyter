#based off of https://stackoverflow.com/a/32742700
#this gets the features and extracts them
curl -c /tmp/cookies "https://drive.google.com/uc?export=download&id=15g-wAdSU9p5cU7ATu_vRO6s8dAZ1LpV0" > /tmp/temp_warning.html && 
curl -L -b /tmp/cookies "https://drive.google.com$(cat /tmp/temp_warning.html | grep -Po 'uc-download-link" [^>]* href="\K[^"]*' | sed 's/\&amp;/\&/g')" > features.zip && 
unzip features.zip &&
rm -rf features.zip
#results
curl -c /tmp/cookies "https://drive.google.com/uc?export=download&id=1seXIfpBdhAqtTbZFzg779qcWajO82gdG" > /tmp/temp_warning2.html && 
curl -L -b /tmp/cookies "https://drive.google.com$(cat /tmp/temp_warning2.html | grep -Po 'uc-download-link" [^>]* href="\K[^"]*' | sed 's/\&amp;/\&/g')" > results.zip && 
unzip results.zip
rm -rf results.zip