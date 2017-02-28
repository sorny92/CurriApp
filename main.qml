import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtWebSockets 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Curridrone")

    WebSocket{
        id: webSocket
        url: 'ws://127.0.1.1:8888/ws'
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
            width: parent.width/2
            height: parent.height
            Switch {
                Layout.preferredWidth: 400
                id: webSocketSwitch
                text: qsTr("WebSocket Off")
                Layout.fillWidth: false
                Layout.fillHeight: false
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
                Layout.preferredWidth: 400
                Layout.fillHeight: true
                onControlValuesChanged: {
                    webSocket.sendTextMessage(createDataMessage(power, direction))
                }
            }
        }
        spacing: 10
        ColumnLayout {
            width: parent.width/2
            height: parent.height
            VideoStreamView {
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

