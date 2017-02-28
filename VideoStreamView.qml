import QtQuick 2.0
import QtWebView 1.1

Rectangle {
    WebView {
        id: player
        url: "http://192.168.92.1:5000/video_feed"
        anchors.fill: parent
    }
}
