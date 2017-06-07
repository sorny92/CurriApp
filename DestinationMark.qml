import QtQuick 2.0
import QtLocation 5.8

MapQuickItem {
    signal press()
    signal longPress()
    property alias position: mqi.coordinate
    property alias number: text_number.text
    property alias color: circle.color
    property bool editMode: false

    id:mqi
    anchorPoint.y: circle.height/2
    anchorPoint.x: circle.width/2
    sourceItem: Item{
        width: 24
        height: width
        Rectangle {
            id: circle
            anchors.fill: parent
            antialiasing: true
            color: 'blue'
            border.color: 'white'
            border.width: 3
            radius: 12
        }
        Text {
            id: text_number
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

        }
        MouseArea {
            anchors.fill: parent
            onPressed: {
                mqi.press()
                circle.parent.width *= 2
                circle.radius *= 2
            }
            onReleased: {
                circle.parent.width /= 2
                circle.radius /= 2
            }
            onPressAndHold: mqi.longPress()
        }
    }
    onEditModeChanged: {
        editMode?circle.color="red":circle.color='blue'
    }
}
