import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: root
    signal controlValuesChanged(real power, real direction)

    Slider {
        id: sliderPower
        anchors.right: parent.right
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
        width: parent.width - parent.width/10
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

    function valueChanged(power, direction) {
        root.controlValuesChanged(Math.round(power), Math.round(direction))
    }
}
