'use strict';
import React, {Component, PropTypes} from 'react';
var {
    processColor,
    StyleSheet,
    View,
    requireNativeComponent
} = require('react-native');
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';



const WaveForm = React.createClass({
    propTypes: {
        ...View.propTypes,

        waveFormStyle:PropTypes.shape({
            leftWaveColor: React.PropTypes.string,
            rightWaveColor: React.PropTypes.string
        }),
        src: PropTypes.shape({
            uri: PropTypes.string,
        }),
        source: PropTypes.oneOfType([
            PropTypes.shape({
                uri: PropTypes.string
            }),
            // Opaque type returned by require('./video.mp4')
            PropTypes.number
        ])

    },
    render: function () {
        const source = resolveAssetSource(this.props.source) || {};

        let uri = source.uri;
        if (uri && uri.match(/^\//)) {
            uri = `file://${uri}`;
        }

        const isNetwork = !!(uri && uri.match(/^https?:/));
        const isAsset = !!(uri && uri.match(/^(assets-library|file|content|ms-appx|ms-appdata):/));


        this.props.waveFormStyle.leftWaveColor=processColor(this.props.waveFormStyle.leftWaveColor)
        this.props.waveFormStyle.rightWaveColor=processColor(this.props.waveFormStyle.rightWaveColor)


        const nativeProps = Object.assign({}, this.props);
        Object.assign(nativeProps, {
            waveFormStyle:{
                rightWaveColor:this.props.waveFormStyle.rightWaveColor,
                leftWaveColor:this.props.waveFormStyle.leftWaveColor,
            },
            src: {
                uri:uri,
                isNetwork,
                isAsset,
                type: source.type,
                mainVer: source.mainVer || 0,
                patchVer: source.patchVer || 0,
            }

        });

        console.log("FRFR: "+nativeProps.src.uri);
        return <OGWaverformView {...nativeProps} />;
    }

});

var OGWaverformView = requireNativeComponent('OGWave', WaveForm);


module.exports = WaveForm;




