import QtQuick 2.7
import QtQuick.Controls 2.0

Item {
    Map {
        id: map
        anchors.fill: parent
        gesture.enabled: true
        MultiPointTouchArea{
            anchors.fill: parent
        }
    }
    Button {
        id: centerYouButton
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.left: map.left
        anchors.top: map.top
        text: qsTr("You")
        onClicked: {
            map.updatePosition();
            console.log(map.userPosition);
        }
    }

    Button {
        id: centerDronButton
        anchors.topMargin: 10
        anchors.rightMargin: 10
        anchors.right: map.right
        anchors.top: map.top
        text: qsTr("Drone")
        onClicked: {
            map.updateBoatPosition();
            console.log(map.boatPosition);
        }
    }
}
