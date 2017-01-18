'use strict';
import React, {Component, PropTypes} from 'react';
var {
    TouchableHighlight,
    processColor,
    StyleSheet,
    View,
    requireNativeComponent
} = require('react-native');
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';



const WaveForm = React.createClass({
    propTypes: {
        ...View.propTypes,
        autoPlay:React.PropTypes.bool,
        waveFormStyle:PropTypes.shape({
            leftWaveColor: React.PropTypes.string,
            rightWaveColor: React.PropTypes.string
        }),
        src: PropTypes.shape({
            uri: PropTypes.string,
            isNetwork: PropTypes.bool,
            isAsset:PropTypes.bool,
        }),
        source: PropTypes.oneOfType([
            PropTypes.shape({
                uri: PropTypes.string
            }),
            // Opaque type returned by require('./video.mp4')
            PropTypes.number
        ]),
        play:PropTypes.bool,
        stop:PropTypes.bool,
        pause:PropTypes.bool,
        onPress:PropTypes.func,
        pressed:PropTypes.bool,

     



    },

    _onPress(e:Event) {


        if (!this.props.onPress) {
            return;
        }

        this.props.onPress(e) && this.props.onPress;
    },
    render: function () {
        const source = resolveAssetSource(this.props.source) || {};

        let uri = source.uri;
        if (uri && uri.match(/^\//)) {
            uri = `file://${uri}`;
        }


        const isNetwork = !!(uri && uri.match(/^https?:/));
        const isAsset = !!(uri && uri.match(/^(assets-library|file|content|ms-appx|ms-appdata):/));


        //this.props.waveFormStyle.leftWaveColor=processColor(this.props.waveFormStyle.leftWaveColor)
        //this.props.waveFormStyle.rightWaveColor=processColor(this.props.waveFormStyle.rightWaveColor)


        const nativeProps = Object.assign({}, this.props);
        Object.assign(nativeProps, {
            autoPlay:this.props.autoPlay,
            waveFormStyle:{
                rightWaveColor:processColor(this.props.waveFormStyle.rightWaveColor),
                leftWaveColor:processColor(this.props.waveFormStyle.leftWaveColor),
            },

            src: {
                uri:uri,
                isNetwork:isNetwork,
                isAsset:isAsset,
                type: source.type,
                mainVer: source.mainVer || 0,
                patchVer: source.patchVer || 0,
            }

        });


        return <OGWaverformView {...nativeProps} onPress={this._onPress} />;
    }

});

var OGWaverformView = requireNativeComponent('OGWave', WaveForm);


module.exports = WaveForm;




