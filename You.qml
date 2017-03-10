import QtQuick 2.0
import QtLocation 5.8

MapQuickItem {
    property var position
    coordinate: position
    anchorPoint.y: image.height
    anchorPoint.x: image.width/2
    sourceItem:
        Image {
        sourceSize.width: 50
        id: image
        source: "resources/fisherman.png"
    }
}
