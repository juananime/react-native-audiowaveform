'use strict';
import React, {Component, PropTypes} from 'react';
var {
    StyleSheet,
    View,
    requireNativeComponent
} = require('react-native');
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';


const WaveForm = React.createClass({
    propTypes: {
        /* Wrapper component */
        source: PropTypes.oneOfType([
            PropTypes.shape({
                uri: PropTypes.string
            }),
            // Opaque type returned by require('./video.mp4')
            PropTypes.number
        ]),

    },
    render: function () {
        const source = resolveAssetSource(this.props.source) || {};

        console.log('CXDCDCCD '+ source.uri)

        let uri = source.uri;
        if (uri && uri.match(/^\//)) {
            uri = `file://${uri}`;
        }

        const isNetwork = !!(uri && uri.match(/^https?:/));
        const isAsset = !!(uri && uri.match(/^(assets-library|file|content|ms-appx|ms-appdata):/));

        const nativeProps = Object.assign({}, this.props);
        Object.assign(nativeProps, {
            src: {
                uri,
                isNetwork,
                isAsset,
                type: source.type,
                mainVer: source.mainVer || 0,
                patchVer: source.patchVer || 0,
            }
        });


        return <OGWaverformView {...nativeProps} />;
    }

});

var OGWaverformView = requireNativeComponent('OGWave', WaveForm,
    {nativeOnly:{
        src:true
    }}
);
//var NativeHTMLWebView = requireNativeComponent('AIBHTMLWebView', _HTMLWebView);

module.exports = WaveForm;




