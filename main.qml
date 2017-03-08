import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtWebSockets 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Curridrone")
    property string thinkingHead_IP: '192.168.43.131'

    WebSocket{
        id: webSocket
        url: 'ws://'+ thinkingHead_IP + ':8888/ws'
        active: false
        onStatusChanged: {
            if (webSocket.status == WebSocket.Error) {
                console.log("Error: " + webSocket.errorString)
                webSocketSwitch.checked = false
            } else if (webSocket.status == WebSocket.Open) {
                webSocket.sendTextMessage("Curridrone Connected")
                console.log("Curridrone connected")
            } else if (webSocket.status == WebSocket.Closed) {
                console.log("\nSecure socket closed")
            }
        }
        onActiveChanged: {
            console.log(webSocket.active)
        }
        onTextMessageReceived: {
            console.log("Received " + message)
            parseMessage()
        }
    }
    RowLayout {
        anchors.fill: parent
        ColumnLayout {
            implicitWidth: parent.width/3
            Layout.maximumHeight: 1280
            Layout.minimumHeight: 500
            Layout.maximumWidth: 500
            Layout.minimumWidth: 200
            Layout.fillHeight: true
            Layout.fillWidth: false
            Switch {
                id: webSocketSwitch
                text: qsTr("WebSocket Off")
                Layout.alignment: Qt.AlignTop

                onCheckedChanged: {
                    if(webSocketSwitch.checked){
                        webSocketSwitch.text = qsTr("WebSocket On")
                        webSocket.active = true
                    } else {
                        webSocketSwitch.text = qsTr("WebSocket Off")
                        webSocket.active = false
                    }
                }
            }
            spacing: 3
            LocalControl {
                id: pageLocalControl
                Layout.alignment: Qt.AlignBottom
                onControlValuesChanged: {
                    webSocket.sendTextMessage(createDataMessage(power, direction))
                }
            }
        }
        spacing: 10
        ColumnLayout {
            height: parent.height
            VideoStreamView {
                ip: thinkingHead_IP
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            spacing: 3
            MapView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    function createDataMessage(power, direction){
        return "p"+ power + ", d" + direction + "\n";
    }

    function parseMessage() {

    }
}

