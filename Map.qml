import QtQuick 2.0
import QtLocation 5.4
import QtPositioning 5.4


Map {
    property var userPosition
    property var dronePosition
    property var droneData
    property alias listRoute: listDestinationPosition

    function updatePosition() {
        positionSrc.update();
    }
    function updateDronePosition() {

    }

    id: map
    plugin: myPlugin
    anchors.fill: parent
    center: userPosition
    zoomLevel:15

    Fisherman {
        id: user
        position: userPosition
    }

    Drone {
        id: drone
        position: QtPositioning.coordinate(droneData.coordinates[0], droneData.coordinates[1])
        heading: droneData.sensorHeading
        state: droneData.armed
        onPositionChanged: {
            dronePosition = drone.position
            if(drone.position.latitude === 0 || drone.position.longitude === 0) {
                drone.position = userPosition
            }
        }
    }
    ListModel {
        id: listDestinationPosition
        ListElement {number: 1; latitude: 39.460555; longitude: -0.372524}
        ListElement {number: 2; latitude: 39.460555; longitude: -0.372526}

    }

    MapItemView {
        model: listDestinationPosition
        delegate: DestinationMark {
            position: QtPositioning.coordinate(latitude, longitude)
            number: number
        }
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
