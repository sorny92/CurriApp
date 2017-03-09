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
        onStateChanged: {
            //if(state == VlcPlayer.Error) vlcPlayer.mrl = 'tcp/h264://' + ip +':8000/'
        }
        Component.onDestruction: vlcPlayer.stop()
    }
    VlcVideoSurface {
        id: videoOut
        anchors.fill: parent
        source: vlcPlayer;
        anchors.centerIn: parent.Center
    }
    MouseArea{
        anchors.fill: parent
        z:2
        onClicked: {
            vlcPlayer.video.saturation = 100
        }
    }
}
