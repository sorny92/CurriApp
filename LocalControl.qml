import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: root
    signal controlValuesChanged(real power, real direction)
    property string heading: "0"
    property string speed: "0"
    property string batterylevel: "100"
    property string satellites: "0"
    property string hdop: "0"

    Slider {
        id: sliderPower
        height: parent.height*0.8
        anchors.left: parent.left
        anchors.rightMargin: 10
        anchors.bottom: sliderDirection.top
        anchors.bottomMargin: 5
        orientation: Qt.Vertical
        stepSize: 1
        from: 0
        to: 100
        value: 0
        onValueChanged: root.valueChanged(sliderPower.value, sliderDirection.value)
    }

    Slider {
        id: sliderDirection
        width: parent.width*0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        stepSize: 1
        from: 0
        to: 100
        value: 50
        onValueChanged: root.valueChanged(sliderPower.value, sliderDirection.value)
    }
    Button {
        id: centerButton
        onClicked: {
            sliderDirection.value = (sliderDirection.from + sliderDirection.to)/2
        }
        anchors.bottom: sliderDirection.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Center")
    }

    ColumnLayout {
        anchors.left: sliderPower.right
        anchors.bottom: centerButton.top
        id: columnLayout
        width: 100
        height: 100
        Text {
            id: headingText
            text: qsTr("Heading: ") + heading
            font.pixelSize: 12
        }
        Text {
            id: speedText
            text: qsTr("Speed: ") + speed
            font.pixelSize: 12
        }
        Text {
            id: batteryText
            text: qsTr("Battery Level: ") + batterylevel
            font.pixelSize: 12
        }
        Text {
            id: satelliteText
            text: qsTr("Satellites: ") + satellites
            font.pixelSize: 12
        }
        Text {
            id: hdopText
            text: qsTr("HDOP: ") + hdop
            font.pixelSize: 12
        }
    }

    function valueChanged(power, direction) {
        root.controlValuesChanged(Math.round(power), Math.round(direction))
    }
}
