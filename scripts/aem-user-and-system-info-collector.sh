#!/bin/bash

#######################################################################################
# version 1.4
#
# Revised at 2016/10/24
#
# Edited by Robert Wunsch  wunsch@adobe.com
#
## Version 
#   v1.5 (18-Nov-16) : Added '-w' parameter for wait time. Default is 3 sec. Set "0" for fastest execution.  
#   v1.4 (24-Oct-16) : Adding the parameter 'n', which only queries user and created a CSV and XLS file from all servers combined
#   v1.3 (23-Sep-16) : Removing '-J' in CURL commands due to this not being available at a client version of CURL
#   v1.2 (19-Sep-16): rdeduce user.json query - nodedepth to "2" -due to server returning massive amounts of "notification entries" in the user-node
# 	v1.1 (6-Sep-16): add timeout parameter and default timeout check 
#   v1.0 (1-Sep-16): first release
# 
# Sample Usage:
# -------------
# ONE SERVER:
# ./aem-user-and-system-info-collector.sh  -v -z -t 10 -w 0 -u admin -p admin -a http://localhost:4502 
# MULTIPLE SERVER:
# ./aem-user-and-system-info-collector.sh  -v -z -t 10 -w 0 -c file-containing-list-of-servers-and-credentials.csv (serverURL, username, password, serverName)
# MULTIPLE SERVER - USERS ONLY:
# ./aem-user-and-system-info-collector.sh  -n -v -t 10 -w 0 -c file-containing-list-of-servers-and-credentials.csv (serverURL, username, password, serverName)
#
# ToDo:
# -------------
# - JVM Parameters
# - workspace.xml
# - quickstart 'tree'
# - Tread Dumps
# - More Curl: 
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-Bundlelist.txt $SERVERURL/system/console/status-Bundlelist.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-Bundles.txt $SERVERURL/system/console/status-Bundles.txt 
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-Configurations.txt  $SERVERURL/system/console/status-Configurations.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-content-packages.txt  $SERVERURL/system/console/status-content-packages.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-Declarative\ Services\ Components.txt $SERVERURL/system/console/status-Declarative%20Services%20Components.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-GFX\ ImageIO\ Formats.txt $SERVERURL/system/console/status-GFX%20ImageIO%20Formats.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-GFX\ supported\ Fonts.txt $SERVERURL/system/console/status-GFX%20supported%20Fonts.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-replication.txt  $SERVERURL/system/console/status-replication.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-httpservice.txt  $SERVERURL/system/console/status-httpservice.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-httpwhiteboard.txt  $SERVERURL/system/console/status-httpwhiteboard.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-jaas.txt  $SERVERURL/system/console/status-jaas.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-jsptaglibs.txt  $SERVERURL/system/console/status-jsptaglibs.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-osgi-installer.txt  $SERVERURL/system/console/status-osgi-installer.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-Preferences.txt  $SERVERURL/system/console/status-Preferences.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-productinfo.txt  $SERVERURL/system/console/status-productinfo.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-Repository\ Apache\ Jackrabbit\ Oak.txt $SERVERURL/system/console/status-Repository%20Apache%20Jackrabbit%20Oak.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-jcrresolver.txt  $SERVERURL/system/console/status-jcrresolver.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingscripting.txt  $SERVERURL/system/console/status-slingscripting.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-Services.txt  $SERVERURL/system/console/status-Services.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-adapters.txt  $SERVERURL/system/console/status-adapters.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingmodels.txt  $SERVERURL/system/console/status-slingmodels.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingprops.txt  $SERVERURL/system/console/status-slingprops.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingreferrerfilter.txt  $SERVERURL/system/console/status-slingreferrerfilter.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingrewriter.txt  $SERVERURL/system/console/status-slingrewriter.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingscheduler.txt  $SERVERURL/system/console/status-slingscheduler.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingfilter.txt  $SERVERURL/system/console/status-slingfilter.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingsettings.txt  $SERVERURL/system/console/status-slingsettings.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingthreadpools.txt  $SERVERURL/system/console/status-slingthreadpools.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-System\ Properties.txt $SERVERURL/system/console/status-System%20Properties.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-slingthreads.txt  $SERVERURL/system/console/status-slingthreads.txt
# curl -u $USER:$PASS  -s -k -o $WORKSPACESTATUS/status-topology.txt  $SERVERURL/system/console/status-topology.txt
# curl -u $USER:$PASS -s -k -o $WORKSPACESTATUS/QueryStat.txt $SERVERURL/libs/granite/operations/content/diagnosis/tool.html/_granite_queryperformance
# curl -u $USER:$PASS -s -k $SERVERURL/crx/packmgr/service.jsp?cmd=ls > $WORKSPACE/package_list.xml
#
# Credits:
# This script is heavily inspired by the "system-info-collector.sh"-script by Takahito Kikuchi  tkikuchi@adobe.com.
# URL: <INTERNAL_WIKI>/display/obujpn/Enhanced+System+info+collector
#######################################################################################

function usage() {
	echo "---------------------"
	echo "Usage: options" 1>&2
	echo "---------------------"
	echo "-u : user login (default is prompted if online mode)" 1>&2
	echo "-p : password" 1>&2
	echo "-a : server url e.g. http://localhost:4502 (default is prompted if online mode)" 1>&2
	echo "-c : CSV-file: define server-url (-a), servername (-d), login(-u), password(-p)  for batch collection" 1>&2
	echo "-d : destination folder/directory default 'collected-info'-folder, if this folder does not exist, it will be created, and deleted on zipping (on flag '-z')" 1>&2
	echo "-t : Connection Timeout (default 30sec)" 1>&2
	echo "-v : more verbose output" 1>&2
	echo "-w : wait time (for reading feedback) in sec (default: 3 sec). For production set to 0" 1>&2
	echo "-z : zip output (files and folders , '-d' folder 'collected-info' will be deleted for cleanup)" 1>&2
	echo "-n : only query users and creates 'all_users.csv' in folder 'users'" 1>&2
	echo ""
	echo "---------------------"
	echo "Sample Usage: " 1>&2
	echo "---------------------"
	echo "ONE SERVER:" 1>&2
	echo "./aem-user-and-system-info-collector.sh  -v -z -t 10 -u admin -p admin -a http://localhost:4502 -d 'info_localhost_4502'" 1>&2
	echo ""
	echo "MULTIPLE SERVER:" 1>&2
	echo "./aem-user-and-system-info-collector.sh  -v -z -t 10 -c example-list-of-servers.csv -d 'info_all_servers'" 1>&2
	echo ""
	echo "MULTIPLE SERVER - USERS ONLY:" 1>&2
	echo "./aem-user-and-system-info-collector.sh  -v -t 10 -c example-list-of-servers.csv -d 'info_all_servers'" 1>&2
	echo "---------------------"
	echo ""
	echo "---------------------"
	echo "CSV File - Content" 1>&2
	echo "---------------------"
	echo "http://localhost:4502,AEM_6.1_Server-Donald,admin,admin"  1>&2
	echo "http://localhost:4504,AEM_5.6.1_Server-Dagobert,username,password" 1>&2
	echo "http://localhost:4506,AEM_6.2_Server-Goofy,wunsch,c3$6gbH+!" 1>&2
	echo ""
	echo "---------------------"
	exit 1
}

# Getting AEM version name
function getAemVersion(){
	# curl -u $USER:$PASS -k $SERVERURL/system/console/productinfo  
	#	->  gets html with AEM version included
	# grep "Adobe Experience Manager"  
	#	-> returns only lines with "AEM" included
	# awk -F'[()]' 'NR==5 {print $2}'  
	#	-> gets text between round braces (version-numbers). There are two round braces, one is the license version number, the other the software version number.
	#	-> due to removal of text we need to use "NR==5" (fifth line) to get the software version number.
	echo "-------------------------------------------"
	echo "Checking AEM version"
	echo "-------------------------------------------"
	AEM_VERSION=$(curl -u $USER:$PASS -k $CURL_NON_VERBOSE $SERVERURL/system/console/productinfo | grep "Adobe Experience Manager" | awk -F'[()]' '{print substr($2,0,3)}')
	AEM_VERSION=${AEM_VERSION//[$'\t\r\n']}
	echo "-------------------------------------------"
	echo "AEM VERSION:  $AEM_VERSION"
	echo "-------------------------------------------"
}

# Get 'configuration-status' of server as ZIP
function curlConfigurationStatus(){
	echo "-------------------------------------------"
	echo "Get 'configuration-status' of server as ZIP"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then		
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -O -J -k $SERVERURL/system/console/status-slinglogs/configuration-status.zip"
		#echo "	-O : Download"
		#echo "	-J : User File-Name used on Server"
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "configuration-status.zip" $CURL_NON_VERBOSE $SERVERURL"/system/console/status-slinglogs/configuration-status.zip"
}

# Collecting "bundles.json" for use in tools from http://www.aemstuff.com/ -> Tools
function curlBundleJson(){
	echo "-------------------------------------------"
	echo "Collecting 'bundles.json'"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -O -J -k $SERVERURL/system/console/bundles.json"
		#echo "	-O : Download"
		#echo "	-J : User File-Name used on Server"
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "bundles.json" $CURL_NON_VERBOSE $SERVERURL"/system/console/bundles.json"
}

# Collecting "package_list.xml" for use in CQ Package Analyzer (http://sj1slm902 internal server on corp.adobe.com/)
function curlCrxPackages(){
	echo "-------------------------------------------"
	echo "Collecting 'package_list.xml'"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -k -o package_list.xml $SERVERURL/crx/packmgr/service.jsp?cmd=ls"
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "package_list.xml"  $CURL_NON_VERBOSE $SERVERURL"/crx/packmgr/service.jsp?cmd=ls"
}

# Collecting "oak-index-definitions.json" for use in Index Definition Analyzer (https://oakutils.appspot.com/analyze/index)
function curlOakIndexDefinitions(){
	echo "-------------------------------------------"
	echo "Collecting 'oak-index-definitions.json'"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -k -o oak-index-definitions.json $SERVERURL/oak:index.tidy.-1.json"
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "oak-index-definitions.json"  $CURL_NON_VERBOSE $SERVERURL"/oak:index.tidy.-1.json"
}


# Collecting "users.json" to be able to determine named-users
function curlUsersJson(){
	echo "-------------------------------------------"
	echo "Collecting 'users.json'"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -k -o users.json $SERVERURL/bin/querybuilder.json?property=jcr:primaryType&property.value=rep:User&p.limit=-1&p.hits=full&p.nodedepth=2"
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "users.json" $CURL_NON_VERBOSE $SERVERURL"/bin/querybuilder.json?property=jcr:primaryType&property.value=rep:User&p.limit=-1&p.hits=full&p.nodedepth=2"
}

### Retrive QueryPerformance Statistics (Slow Queries)
function curlGraniteQueryPerformance(){
	echo "-------------------------------------------"
	echo "Collecting 'graniteQueryPerfromance.html'"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -s -o -k  graniteQueryPerformance.txt $SERVERURL/libs/granite/operations/content/diagnosis/tool.html/_granite_queryperformance"
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "graniteQueryPerformance.html" $CURL_NON_VERBOSE $SERVERURL"/libs/granite/operations/content/diagnosis/tool.html/_granite_queryperformance" 
}

### Retrive Systemoverview (since 6.4)
function curlSystemOverview(){
	echo "-------------------------------------------"
	echo "Collecting 'systemOverview.json'"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -s -o -k  graniteQueryPerformance.txt $SERVERURL/libs/granite/operations/content/systemoverview/export.json"
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "systemOverview.json" $CURL_NON_VERBOSE $SERVERURL"/libs/granite/operations/content/systemoverview/export.json" 
}

### Retrive Sling Health Checks(since 6.4)
function curlSlingHealthChecks(){
	echo "-------------------------------------------"
	echo "Collecting 'healthChecks.html'"
	echo "-------------------------------------------"
	if [ "$VERBOSE" = true ] ; then
		echo "executing: "
		echo "	curl -u $USER:$PASSWORD -s -o -k  graniteQueryPerformance.txt $SERVERURL/system/console/healthcheck?tags=&debug=true&overrideGlobalTimeout="
		echo "	-s : Does not output error messages"
		echo "	-o : Download directory"
		echo "	-k : allow insecure SSL connections"
	fi
	curl -u $USER:$PASS -s -k -o "healthChecks.html" $CURL_NON_VERBOSE $SERVERURL"/system/console/healthcheck?tags=&debug=true&overrideGlobalTimeout=" 
}


### Iterate through all folders, find "users.json", copy to "users" folder, rename to folder/server-name
function getAllUserJsonAndStoreToOneFolder(){
	USERS_FOLDER='users'
	USERS_PREFIX='users_'
	
	echo "-------------------------------------------"
	echo "Collecting all 'users.json' and copy to 'users' folder. "
	echo "Server name will become the filename."
	echo "-------------------------------------------"	
	## Create folder named 'users' underneath the folder defined in parameter '-d'
	mkdir  -p "${PWD_ME}/${DIRECTORY}/${USERS_FOLDER}"
	JSON_COUNT=1
	find "`pwd`" -type d -name '*.*' -print0 | while IFS= read -r -d '' CUR_FOLDER; do
		cd "$CUR_FOLDER"
		DIR_NAME=${PWD##*/} 
		for JSON in users.json; do	   
		   cp "$JSON" "${PWD_ME}/${DIRECTORY}/${USERS_FOLDER}/${USERS_PREFIX}${DIR_NAME}.json"
		done
		echo "${JSON_COUNT}: 'users.json' found in	'${DIR_NAME}'"
		((JSON_COUNT++))
	done
	cd $PWD_ME

}

### Convert and combine all "users.json"-files of all servers into CSV-files
function createUserCsvFromJsons(){
	USERS_FOLDER='users'
	USER_FILE_NAME='all_users'
	
	echo "-------------------------------------------"
	echo "Creating CSV files 'server-name'.csv from 'serve-name'.json. "
	echo "Joining all CSV in a file '${USER_FILE_NAME}.csv'."
	echo "-------------------------------------------"	

	cd "${PWD_ME}/${DIRECTORY}/${USERS_FOLDER}"
	
	echo '"Server Name","rep:principalName","givenName","familyName","email","country","region","organization","jcr:created"' > "${USER_FILE_NAME}.csv"
	
	for JSON in *.json; do
		SERVER_NAME=$(echo "${JSON%.*}" | sed -e 's/^users_//')
		echo "Creating ${SERVER_NAME}.csv"
		jq -r '.hits | map([."rep:principalName", .profile.givenName, .profile.familyName, .profile.email, .profile.country, .profile.region, .profile.organization , .profile."jcr:created"] | @csv) | join("\n")' $JSON > "${SERVER_NAME}.csv"
		sed "s/^/\"${SERVER_NAME}\",/" "${SERVER_NAME}.csv" >> "${USER_FILE_NAME}.csv"
		rm "${SERVER_NAME}.csv"
		#rm $JSON
	done
	
	# Create fake Excel file which opens correctly in Excel using the Excel "sep=," command
	echo "sep=," > "${USER_FILE_NAME}.xls"
	cat "${USER_FILE_NAME}.csv" >> "${USER_FILE_NAME}.xls"
	
	echo "-------------------------------------------"
	echo "Created  CSV file '${USER_FILE_NAME}.csv'."
	echo "-------------------------------------------"	

	
	cd $PWD_ME

}

function checkTimeout ()  {
	echo "-------------------------------------------"
	echo "Checking for server timeout (set timeout: $TIMEOUT)"
	echo "-------------------------------------------"
	CURL_STATUS=$(curl -u $USER:$PASS -s -w %{http_code} --connect-timeout $TIMEOUT -o /dev/null $SERVERURL"/system/console/vmstat")
}

function countdown () {

  for ((i=$1; i > 0;--i)) do
	printf " $i "
	sleep .25
	printf "."
	sleep .25
	printf "."
	sleep .25
	printf "."
	sleep .25
  done
 
  if [ "$WAITTIME" -ne 0 ]; then
	 printf " GO!"
	echo " "
	sleep 1
  fi
}

#---------------------------------------------------------
#---------      MAIN PROGRAMM      -----------------------
#---------------------------------------------------------
# clearing screen
clear

# --------------Get Parameters ---------------------------
while getopts u:p:a:c:d:t:w:vzn OPT

do
  case $OPT in
	"u" ) FLG_U="TRUE"  ; VALUE_U="$OPTARG" ;;
	"p" ) FLG_P="TRUE"  ; VALUE_P="$OPTARG" ;;
	"a" ) FLG_A="TRUE"  ; VALUE_A="$OPTARG" ;;
	"c" ) FLG_C="TRUE"  ; VALUE_C="$OPTARG" ;;
	"d" ) FLG_D="TRUE"  ; VALUE_D="$OPTARG" ;;
	"t" ) FLG_T="TRUE"  ; VALUE_T="$OPTARG" ;;
	"w" ) FLG_W="TRUE"  ; VALUE_W="$OPTARG" ;;
	"v" ) FLG_V="TRUE"  ;;
	"z" ) FLG_Z="TRUE"  ;;
	"n" ) FLG_N="TRUE"  ;;
	  * ) usage exit 1 ;;   
  esac
done

# ------------Check command-line parameters -----------
echo "----------------------------------"
echo "Check flags:"
echo "----------------------------------"

if [ "$FLG_U" = "TRUE" ]; then
  USER=$VALUE_U
fi

if [ "$FLG_P" = "TRUE" ]; then
  PASS=$VALUE_P
fi

if [ "$FLG_A" = "TRUE" ]; then
  SERVERURL=$VALUE_A
  echo "SINGLE SERVER: Querying only single server. "
elif [ "$FLG_C" = "TRUE" ]; then
  CSV_FILE=$VALUE_C
  echo "MULTIPLE SERVERS: Querying several servers by the list provided in '-c' parameter. "
else
  #Display usage message if neither "-a" or "-c" parameter is given
  # if -a is given only one server is queried
  # if -c is given multiple servers are queried
  usage
fi


if [ "$FLG_T" = "TRUE" ]; then
  TIMEOUT=$VALUE_T
else
  TIMEOUT=30
fi

if [ "$FLG_D" = "TRUE" ]; then
  DIRECTORY=$VALUE_D/collected-info
else
  DIRECTORY="collected-info"
fi

if [ "$FLG_W" = "TRUE" ]; then
  WAITTIME=$VALUE_W
   echo "WAITTIME: $VALUE_W"
else
  WAITTIME=3
   echo "WAITTIME: Default (3)"
fi

if [ "$FLG_V" = "TRUE" ]; then
  VERBOSE=true
  SCRIPT_VERBOSE="-v"
  echo "OUTPUT: Verbose"
else
  CURL_NON_VERBOSE="-s"
  echo "OUTPUT: Non Verbose"
fi

if [ "$FLG_Z" = "TRUE" ]; then
  ZIP=true
  echo "OUTPUT: ZIP files and folders."
else
  echo "OUTPUT: Do NOT ZIP files and folders."
fi

if [ "$FLG_N" = "TRUE" ]; then
  ONLY_USERS=true
  SCRIPT_ONLY_USERS='-n'
  echo "OUTPUT: Only query users."
fi

echo " "

# ------------ Software checks -------------------
# Check if necessary software is installed and available
echo "----------------------------------"
echo "Check installed sotfware:"
echo "----------------------------------"
# CURL
if hash curl 2>/dev/null; then
	echo "CURL is installed"
else
	echo "You need to install CURL to continue"
	exit 1
fi
# SED
if hash sed 2>/dev/null; then
	echo "SED is installed"
else
	echo "You need to install SED to continue"
	exit 1
fi
# ZIP
if [ "$ZIP" = true ] ; then
	if hash zip 2>/dev/null ; then
		echo "ZIP is installed"
	else
		echo "You need to install ZIP to continue"
		exit 1
	fi
fi
# READ
if hash read 2>/dev/null; then
	echo "READ is installed"
else
	echo "You need to install READ to continue"
	exit 1
fi
# GREP
if hash grep 2>/dev/null; then
	echo "GREP is installed"
else
	echo "You need to install GREP to continue"
	exit 1
fi
# ZIP
if [ "$ONLY_USERS" = true ] ; then	
	if hash jq 2>/dev/null ; then
		echo "JQ is installed"
	else
		echo "You need to install JQ to continue"
		exit 1
	fi
fi
echo "	"
echo "----------------------------------"
echo "All necessary software installed."
echo "----------------------------------"
echo "	"
countdown $WAITTIME

# ------------- MULTI SERVER --------------------------------
# - Iterate through CSV and call this script recursively ----
# -----------------------------------------------------------
if [ "$FLG_C" = "TRUE" ]; then 
	
	BASENAME_ME=`basename "$0"`
	PWD_ME=`pwd`

	mkdir -p $DIRECTORY
	cd $DIRECTORY	
	
	[ ! -f "$PWD_ME/$CSV_FILE" ] && { echo "$CSV_FILE : file not found in path: $PWD_ME"; exit 99; }
	
	LINE=1
	grep "" $PWD_ME/$CSV_FILE | while IFS=',' read -r server_url servername username password
	do
		# clearing screen
		clear
		echo "-----------------------------------------------"
		echo "CSV line $LINE - Querying Server $servername."
		echo "-----------------------------------------------"
		echo "Server URL : $server_url"
		echo "Servername : $servername"
		echo "Username : $username"
		echo "Password : $password"
		echo "-----------------------------------------------"
		echo "Recursively executing: "
		echo "$PWD_ME/$BASENAME_ME $SCRIPT_VERBOSE $SCRIPT_ONLY_USERS -t $TIMEOUT -u $server_url -u $username -p $password -a $server_url."
		echo "-----------------------------------------------"
		countdown $WAITTIME
		
		# Recursively calling this script with Single Server parameters
		($PWD_ME/$BASENAME_ME $SCRIPT_VERBOSE $SCRIPT_ONLY_USERS -t $TIMEOUT -w $WAITTIME -u $username -p $password -d $servername -a $server_url )
		
		countdown $WAITTIME
		
		((LINE++))
	done
	
	# return to uppermost folder
	cd $PWD_ME
	
	if [ "$ONLY_USERS" = true ] ; then
		# collect all 'users.json' and copy to users-folder
		clear
		getAllUserJsonAndStoreToOneFolder
		createUserCsvFromJsons
	fi
		
	# ZIPing Folder
	if [ "$ZIP" = true ] ; then	
		zip -q -r $DIRECTORY{.zip,}
		rm -rf $DIRECTORY
	fi
	
	exit 0
fi 

# -------- SINGLE SERVER-------------------------
# - Collect all information from one server -----
# -----------------------------------------------

# Create Directory if it does not exist
mkdir -p $DIRECTORY
cd $DIRECTORY

checkTimeout

if [ "$CURL_STATUS" -eq "000" ] ; then
	echo ""
	echo "> Server did not respond within $TIMEOUT seconds. Please check if '$SERVERURL' is available."
	echo ""
	printf "> Continuing ..."
	touch "server_timed_out_$TIMEOUT_sec.txt"
else

	# This returns AEM_VERSION
	getAemVersion

	if [ "$ONLY_USERS" = true ] ; then	
		curlUsersJson
	else
	
		
		# This is only executed if > AEM6.3
		if (( $(echo "$AEM_VERSION > 6.3" | bc -l) )); then 
			echo "-------------------------------------------"
			echo "AEM Version $AEM_VERSION >= AEM 6.4"
			echo "-------------------------------------------"
			
			curlSystemOverview
		else
			echo ">>> AEM Version $AEM_VERSION < AEM 6.4 - not querying >=AEM6.4 stuff <<<"
		fi
		
		# This is only executed if > AEM6.2
		if (( $(echo "$AEM_VERSION > 6.2" | bc -l) )); then 
			echo "-------------------------------------------"
			echo "AEM Version $AEM_VERSION >= AEM 6.3"
			echo "-------------------------------------------"
			
			curlSlingHealthChecks
		else
			echo ">>> AEM Version $AEM_VERSION < AEM 6.3 - not querying >=AEM6.3 stuff <<<"
		fi
	
		# This is only executed if >= AEM6.x
		if [[ $AEM_VERSION == 6.* ]]; then 
			echo "-------------------------------------------"
			echo "Collecting items for AEM Version $AEM_VERSION >= AEM 6.0"
			echo "-------------------------------------------"
			
			curlGraniteQueryPerformance
			curlOakIndexDefinitions
		else
			echo ">>> AEM Version $AEM_VERSION < AEM 6.0 - not querying AEM6.x stuff <<<"
		fi
		
		# This collects server information
		echo "-------------------------------------------"
		echo "Collecting items for all AEM versions"
		echo "-------------------------------------------"
		curlConfigurationStatus
		curlBundleJson
		curlCrxPackages
		curlUsersJson
	fi
	

	cd - #go back to last dir "cd $OLDPWD"

	# ZIPing Folder
	if [ "$ZIP" = true ] ; then	
		zip -q -r $DIRECTORY{.zip,}
		rm -rf $DIRECTORY
	fi

	echo "-------------------------------------------"
	echo "Information successfully collected."
	echo "-------------------------------------------"
fi
