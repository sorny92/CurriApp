import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtWebSockets 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Curridrone")
    property string thinkingHead_IP: '192.168.1.34'
    property real ratioVideo: 16/9
    property var droneData
    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            Switch {
                id: webSocketSwitch
                text: qsTr("WebSocket Off")
                Layout.alignment: Qt.AlignTop
                onCheckedChanged: {
                    if(webSocketSwitch.checked)
                        webSocket.active = true
                    else
                        webSocket.active = false
                }
            }
            Switch {
                id: videoSwitch
                text: qsTr("Video Off")
                Layout.alignment: Qt.AlignTop
                onCheckedChanged: {
                    if(videoSwitch.checked){
                        videoSwitch.text = qsTr("Connecting")
                    } else {
                        videoSwitch.text = qsTr("Video Off")

                    }
                }
            }
            ToolButton {
                text: qsTr("⋮")
                onClicked: menu.open()
                anchors.right: parent.right
            }
        }
    }
    Timer {
        id: timer
        repeat: true
        interval: 3000 //ms
        running: false
        onTriggered: {
            webSocket.sendTextMessage(map.userPosition)
        }
    }

    WebSocket{
        id: webSocket
        url: 'ws://'+ thinkingHead_IP + ':8888/ws'
        active: false
        onStatusChanged: {
            switch(webSocket.status){
            case WebSocket.Connecting:
                webSocketSwitch.text = qsTr("Connecting")
                break
            case WebSocket.Closing:
                webSocketSwitch.text = qsTr("Closing")
                break
            case WebSocket.Open:
                webSocketSwitch.text = qsTr("WebSocket On")
                timer.start()
                break
            case WebSocket.Error:
                webSocketSwitch.text = qsTr("Error connecting")
                webSocketSwitch.checked = false
                break
            case WebSocket.Closed:
                webSocketSwitch.text = qsTr("WebSocket Off")
                timer.stop()
                break
            }
        }
        onActiveChanged: {
            console.log(webSocket.active)
        }
        onTextMessageReceived: {
            console.log("Received " + message)
            parseData('TIME|2|3|17|16|6\nGPS|\x01|1|8|50.1000|1.8100\nPOS|3928.5198|N|25.2099|W|48.10\nMOV|0.9350|0.0000|0.0000|\x00\nH|175.219319\r\n')
        }
    }
    RowLayout {
        anchors.fill: parent
        ColumnLayout {
            height: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: false
            implicitWidth: parent.width/2
            Layout.maximumWidth: 900
            Layout.minimumWidth: 200
            VideoStreamView {
                id: videoStream
                ip: thinkingHead_IP
                implicitWidth: parent.width
                implicitHeight: implicitWidth/ratioVideo
                Layout.maximumHeight: 500
                Layout.fillWidth: true
                Layout.fillHeight: false
            }
            spacing: 3
            LocalControl {
                Layout.maximumHeight: 1280
                Layout.minimumHeight: 200
                Layout.fillHeight: true
                Layout.fillWidth: true
                id: pageLocalControl
                Layout.alignment: Qt.AlignBottom
                onControlValuesChanged: {
                    webSocket.sendTextMessage(createDataMessage(power, direction))
                }
            }

        }
        spacing: 10
        MapView {
            id: map
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    function createDataMessage(power, direction){
        return "p"+ power + ", d" + direction + "\n";
    }

    function parseData(data) {
        rows = data.split('\n')
        for (n in rows){
            row = rows[n]
            row = row.split('|')
            switch (row[0]){
            case 'TIME':
                droneData.day 			= row[1]
                droneData.month 		= row[2]
                droneData.year 			= row[3]
                droneData.hour 			= row[4]
                droneData.minutes 		= row[5]
                break
            case 'GPS':
                droneData.fix 			= row[1]
                droneData.fixquality 	= row[2]
                droneData.satellites 	= row[3]
                droneData.geoidheight 	= row[4]
                droneData.HDOP 			= row[5]
                break
            case 'POS':
                droneData.latitude 		= row[1]
                droneData.lat 			= row[2]
                droneData.longitude 	= row[3]
                droneData.lon 			= row[4]
                droneData.altitude 		= row[5]
                break
            case 'MOV':
                droneData.speed 		= row[1]
                droneData.angle 		= row[2]
                droneData.magvariation 	= row[3]
                droneData.mag 			= row[4]
                break
            case 'H':
                droneData.sensorHeading = row[1]
                break
            default:
                console.log(row[0] + 'is undefined')
            }
        }
    }
}
