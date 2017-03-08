import QtQuick 2.0
import QtWebView 1.1
import QmlVlc 0.1
import QtMultimedia 5.8

Rectangle {
    property string ip
    color: 'red';
    VlcPlayer {
        id: vlcPlayer;
        mrl: 'tcp/h264://' + ip +':8000/';
        onMediaPlayerEncounteredError: console.log("WHAT")
    }
    VideoOutput {
        source: vlcPlayer;
        height: parent.height
        anchors.centerIn: parent.Center
    }
}
