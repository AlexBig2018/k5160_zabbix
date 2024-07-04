#!/bin/bash
MODEM_IP="192.168.8.1"

ses_tok=$(curl -s -X GET "$MODEM_IP/api/webserver/SesTokInfo")
COOKIE=$(echo "$ses_tok" | grep -oPm1 "(?<=<SesInfo>)[^<]+")
TOKEN=$(echo "$ses_tok"  | grep -oPm1 "(?<=<TokInfo>)[^<]+")

modem_status=$(curl -s -X GET "http://$MODEM_IP/api/device/signal" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml")

echo $modem_status > modem_status.txt

rssi=$(echo "$modem_status" | grep -oPm1 "(?<=<rssi>)[^<]+" | grep -Eo '[-\+0-9]{1,}')
sinr=$(echo "$modem_status" | grep -oPm1 "(?<=<sinr>)[^<]+" | grep -Eo '[-\+0-9]{1,}')
rsrp=$(echo "$modem_status" | grep -oPm1 "(?<=<rsrp>)[^<]+" | grep -Eo '[-\+0-9]{1,}')
rsrq=$(echo "$modem_status" | grep -oPm1 "(?<=<rsrq>)[^<]+" | grep -Eo '[-\+0-9]{1,}')

traffic_statistic=$(curl -s -X GET "http://$MODEM_IP/api/monitoring/traffic-statistics" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml")

echo $traffic_statistic > traffic_statistic.txt

currentconnecttime=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<CurrentConnectTime>)[^<]+"  | grep -Eo '[-\+0-9]{1,}')
currentupload=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<CurrentUpload>)[^<]+"       | grep -Eo '[-\+0-9]{1,}')
currentdownload=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<CurrentDownload>)[^<]+"     | grep -Eo '[-\+0-9]{1,}')
currentdownloadrate=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<CurrentDownloadRate>)[^<]+" | grep -Eo '[-\+0-9]{1,}')
currentuploadrate=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<CurrentUploadRate>)[^<]+"   | grep -Eo '[-\+0-9]{1,}')
totalupload=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<TotalUpload>)[^<]+"         | grep -Eo '[-\+0-9]{1,}')
totaldownload=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<TotalDownload>)[^<]+"       | grep -Eo '[-\+0-9]{1,}')
totalconnecttime=$(echo "$traffic_statistic" | grep -oPm1 "(?<=<TotalConnectTime>)[^<]+"    | grep -Eo '[-\+0-9]{1,}')

deviceinformation=$(curl -s -X GET "http://$MODEM_IP/api/device/information" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml")

echo $deviceinformation > deviceinformation.txt

devicename=$(echo "$deviceinformation" | grep -oPm1 "(?<=<DeviceName>)[^<]{1,}")
serialnumber=$(echo "$deviceinformation" | grep -oPm1 "(?<=<SerialNumber>)[^<]{1,}")
imei=$(echo "$deviceinformation" | grep -oPm1 "(?<=<Imei>)[^<]{1,}")
imsi=$(echo "$deviceinformation" | grep -oPm1 "(?<=<Imsi>)[^<]{1,}")
iccid=$(echo "$deviceinformation" | grep -oPm1 "(?<=<Iccid>)[^<]{1,}")
msisdn=$(echo "$deviceinformation" | grep -oPm1 "(?<=<Msisdn>)[^<]{1,}")
hardwareversion=$(echo "$deviceinformation" | grep -oPm1 "(?<=<HardwareVersion>)[^<]{1,}")
softwareversion=$(echo "$deviceinformation" | grep -oPm1 "(?<=<SoftwareVersion>)[^<]{1,}")
webuiversion=$(echo "$deviceinformation" | grep -oPm1 "(?<=<WebUIVersion>)[^<]{1,}")
macaddress1=$(echo "$deviceinformation" | grep -oPm1 "(?<=<MacAddress1>)[^<]{1,}")
workmode=$(echo "$deviceinformation" | grep -oPm1 "(?<=<workmode>)[^<]{1,}")
wanipaddress=$(echo "$deviceinformation" | grep -oPm1 "(?<=<WanIPAddress>)[^<]{1,}")
wanipv6address=$(echo "$deviceinformation" | grep -oPm1 "(?<=<WanIPv6Address>)[^<]{1,}")

monitoringstatus=$(curl -s -X GET "http://$MODEM_IP/api/monitoring/status" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml")

echo $monitoringstatus > monitoringstatus.txt

connectionstatus=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<ConnectionStatus>)[^<]{1,}")
# ConnectionStatus:
#   900: connecting
#   901: connected
#   902: disconnected
#   903: disconnecting
primarydns=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<PrimaryDns>)[^<]{1,}")
secondarydns=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<SecondaryDns>)[^<]{1,}")
primaryipv6dns=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<PrimaryIPv6Dns>)[^<]{1,}")
secondaryipv6dns=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<SecondaryIPv6Dns>)[^<]{1,}")
simstatus=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<SimStatus>)[^<]{1,}")
#Статус Сима:
#0 - нет SIM-карты или она недействительна
#1 - правильная SIM-карта
#2 – недействительная SIM-карта для случая с коммутацией каналов (CS).
#3 - недействительная SIM-карта для случая коммутации пакетов (PS)
#4 - недействительная SIM-карта для случая коммутации каналов и пакетов (PS+CS)
#240 - РОМСИМ
#255 - нет сим-карты
currentnetworktype=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<CurrentNetworkType>)[^<]{1,}")
currentnetworktypeex=$(echo "$monitoringstatus" | grep -oPm1 "(?<=<CurrentNetworkTypeEx>)[^<]{1,}")

#CurrentNetworkType, CurrentNetworkTypeEx:
#0 - brak usługi
#1 - GSM
#2 - GPRS
#3 - EDGE
#4 - WCDMA
#5 - HSDPA
#6 - HSUPA
#7 - HSPA
#8 - TDSCDMA
#9 - HSPA+
#10 - EVDO rev. 0
#11 - EVDO rev. A
#12 - EVDO rev. B
#13 - 1xRTT
#14 - UMB
#15 - 1xEVDV
#16 - 3xRTT
#17 - HSPA+64QAM
#18 - HSPA+MIMO
#19 - LTE
#21 - IS95A
#22 - IS95B
#23 - CDMA1x
#24 - EVDO rev. 0
#25 - EVDO rev. A
#26 - EVDO rev. B
#27 - Hybrydowa CDMA1x
#28 - Hybrydowa EVDO rev. 0
#29 - Hybrydowa EVDO rev. A
#30 - Hybrydowa EVDO rev. B
#31 - EHRPD rev. 0
#32 - EHRPD rev. A
#33 - EHRPD rev. B
#34 - Hybrydowa EHRPD rev. 0
#35 - Hybrydowa EHRPD rev. A
#36 - Hybrydowa EHRPD rev. B
#41 - WCDMA
#42 - HSDPA
#43 - HSUPA
#44 - HSPA
#45 - HSPA+
#46 - DC HSPA+
#61 - TD SCDMA
#62 - TD HSDPA
#63 - TD HSUPA
#64 - TD HSPA
#65 - TD HSPA+
#81 - 802.16E
#101 - LTE

pinstatus=$(curl -s -X GET "http://$MODEM_IP/api/pin/status" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml")

echo $pinstatus > pinstatus.txt

simstate=$(echo "$pinstatus" | grep -oPm1 "(?<=<SimState>)[^<]{1,}")
# simstate:
#255 - нет сим-карты,
#256 - ошибка CPIN,
#257 – готов,
#258 - ПИН-код отключен,
#259 - Проверка ПИН-кода,
#260 - требуется ПИН-код,
#261 - Требуется PUK

currentplmn=$(curl -s -X GET "http://$MODEM_IP/api/net/current-plmn" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml")

echo $currentplmn > currentplmn.txt

fullname=$(echo "$currentplmn" | grep -oPm1 "(?<=<FullName>)[^<]{1,}")

echo -e "RSSI : $rssi \nSINR : $sinr \nRSRP : $rsrp \nRSRQ : $rsrq \nCurrentConnectTime : $currentconnecttime \nCurentUload : $currentupload \nCurentDwnload : $currentdownload \nCurrentDownloadRate : $currentdownloadrate \nCurrentUploadRate : $currentuploadrate \nTotalUpload : $totalupload \nTotalDownload : $totaldownload \nTotalConnectTime : $totalconnecttime \ndevicename : $devicename \nserialnumber : $serialnumber \nimei : $imei \nimsi : $imsi \niccid : $iccid \nmsisdn : $msisdn \nhardwareversion : $hardwareversion \nsoftwareversion : $softwareversion \nwebuiversion : $webuiversion \nmacaddress1 : $macaddress1 \nworkmode : $workmode \nwanipaddress : $wanipaddress \nwanipv6address : $wanipv6address \nconnectionstatus : $connectionstatus \ncurrentnetworktype : $currentnetworktype \nprimarydns : $primarydns \nsecondarydns : $secondarydns \nprimaryipv6dns : $primaryipv6dns \nsecondaryipv6dns : $secondaryipv6dns \ncurentnetworktypeex : $currentnetworktypeex \nsimstatus : $simstatus \nsimstate : $simstate \nfullname  : $fullname" > /etc/zabbix/zabbix_agent2.d/modem.txt
