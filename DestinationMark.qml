import QtQuick 2.0
import QtLocation 5.8

MapQuickItem {

    property alias position: mqi.coordinate
    property alias number: text_number.text

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
                circle.parent.width *= 1.4
                circle.radius *= 1.4
            }
            onReleased: {
                circle.parent.width /= 1.4
                circle.radius /= 1.4
            }
            onPressAndHold: circle.color = 'red'
        }
    }
}
