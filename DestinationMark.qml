import QtQuick 2.0
import QtLocation 5.8

MapQuickItem {
    property var position
    property real number
    coordinate: position
    anchorPoint.y: circle.height/2
    anchorPoint.x: circle.width/2
    sourceItem:
        Rectangle {
        id: circle
        antialiasing: true
        width: 20
        height: 20
        color: "red"
        border.color: "white"
        border.width: 3
        radius: 10
    }
}
