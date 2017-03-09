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
        onMediaPlayerStopped: console.log('stopped')
        onPlayingChanged: console.log('playing failed')
        onStateChanged: {
            console.log('state: '+ vlcPlayer.state)
            if(state == 7) vlcPlayer.mrl = 'tcp/h264://' + ip +':8000/'
        }
        onMediaPlayerOpening: {
            console.log('Abrieeendoooor')
        }
        onMediaPlayerPlaying: {
            console.log('playing')
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
