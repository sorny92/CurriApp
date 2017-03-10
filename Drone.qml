import QtQuick 2.0
import QtLocation 5.8

MapQuickItem {
    property var position
    property int heading: 0
    property bool armed: false
    coordinate: position
    anchorPoint.y: image.height/2
    anchorPoint.x: image.width/2
    sourceItem:
        Image {
        sourceSize.width: 50
        id: image
        source: "resources/boat.png"
    }
}
