import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtWebSockets 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Curridrone")
    property string thinkingHead_IP: '192.168.1.35'
    property real ratioVideo: 16/9
    property alias droneData: map.droneData
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
                    if(webSocketSwitch.checked) {
                        if(videoSwitch.checked){
                            webSocket.sendTextMessage("VIDEO_ON")
                            videoSwitch.text = qsTr("Connecting")
                        } else {
                            webSocket.sendTextMessage("VIDEO_OFF")
                            videoSwitch.text = qsTr("Video Off")

                        }
                    }else {
                        videoSwitch.text = qsTr("WebSocket should be On")
                        videoSwitch.checked = false
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
        onTextMessageReceived: {
            console.log("R: " + message)
            droneData = JSON.parse(message)
            pageLocalControl.hdop = droneData.HDOP
            pageLocalControl.heading = droneData.sensorHeading
            pageLocalControl.batterylevel = droneData.batterylevel
            pageLocalControl.speed = droneData.speed
            pageLocalControl.satellites = droneData.satellites
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
                id: pageLocalControl
                Layout.maximumHeight: 1280
                Layout.minimumHeight: 200
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                onControlValuesChanged: {
                    map.droneData.sensorHeading = direction
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
}
