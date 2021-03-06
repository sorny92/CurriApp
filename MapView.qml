import QtQuick 2.7
import QtQuick.Controls 2.0
import QtPositioning 5.8

Item {
    id: mapView
    property var userPosition: map.userPosition
    property alias droneData: map.droneData
    property var destination_point_coor

    function getCoordinatesFromMapScene(mv, x, y) {
        return map.toCoordinate(Qt.point(x - mv.x, y - mv.y), false)
    }

    Map {
        id: map
        anchors.fill: parent
        gesture.enabled: true
        MultiPointTouchArea{
            anchors.fill: parent
            onPressed: {
                destination_point_coor = getCoordinatesFromMapScene(mapView, touchPoints[0].sceneX, touchPoints[0].sceneY)
            }
            onReleased: {
                var destination_point_coor_actual = getCoordinatesFromMapScene(mapView, touchPoints[0].sceneX, touchPoints[0].sceneY)
                if (destination_point_coor === destination_point_coor_actual){
                    var num = map.listRoute.count + 1
                    map.listRoute.append({
                      "num": num,
                      "latitude":destination_point_coor.latitude,
                      "longitude":destination_point_coor.longitude
                    })
                }
            }
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
            map.center = userPosition;
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
            map.center = droneData.position
        }
    }
    Button {
        id: centerRouteButton
        anchors.topMargin: 10
        anchors.rightMargin: 10
        anchors.right: map.right
        anchors.top: centerDronButton.bottom
        text: qsTr("Show route")
        onClicked: {
            if(map.listRoute.count == 0){
                console.log("No points in Route")
            } else {
                map.fitViewportToVisibleMapItems()
            }
        }
    }
    Button {
        id: clearCacheButton
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.left: centerYouButton.right
        anchors.top: map.top
        text: qsTr("Clear cache")
        onClicked: {
            map.clearData()
        }
    }
}
