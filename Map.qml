import QtQuick 2.0
import QtLocation 5.4
import QtPositioning 5.4


Map {
    property var userPosition
    property var droneData

    function updatePosition() {
        positionSrc.update();
    }
    id: map
    plugin: myPlugin
    anchors.fill: parent
    center: userPosition
    zoomLevel:15

    You {
        position: userPosition
    }

    Drone {
        position: droneData.position
        heading: droneData.heading
        state: droneData.armed
    }

    PositionSource{
        id: positionSrc
        updateInterval: 5000
        active: true
        onPositionChanged: {
            userPosition = positionSrc.position.coordinate;
        }
    }

    Plugin {
        id: myPlugin
        name: "mapbox"
        PluginParameter { name: "mapbox.map_id"; value: "mapbox.satellite" }
        PluginParameter { name: "mapbox.access_token"; value: "pk.eyJ1IjoiZXNvZmFiaWFuIiwiYSI6ImNpZzNraXRoNTF4OW10d20zYWpqdjc2aDgifQ.rnTqzvyW1wknv9ZZEvWDhQ" }
        PluginParameter { name: "mapbox.options"; value: "zoomwheel,zoompan,geocoder,share" }
    }

    Behavior on center {CoordinateAnimation{duration: 600; easing.type: {Easing.InOutQuad}}}
    Behavior on zoomLevel {NumberAnimation{duration: 600; easing.type: {Easing.InOutQuad}}}
    transitions: Transition {
        NumberAnimation { properties: "zoomLevel"; easing.type: Easing.InOutQuad; duration: 200 }
    }
}
