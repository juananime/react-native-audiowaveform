/**
 * Created by juanjimenez on 07/12/2016.
 * Otomogroove ltd 2017
 */

'use strict';
import React, {Component} from 'react';
import {
    Platform,
    DeviceEventEmitter,
    TouchableHighlight,
    processColor,
    StyleSheet,
    View,
    requireNativeComponent
} from 'react-native';
import PropTypes from 'prop-types'
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';


export default class WaveForm extends Component{
    static propTypes = {
        ...View.propTypes,
        autoPlay:React.PropTypes.bool,
        waveFormStyle:PropTypes.shape({
            waveColor: React.PropTypes.string,
            scrubColor: React.PropTypes.string
         }),
        componentID:PropTypes.string,
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
        volume:PropTypes.number,
        onPress:PropTypes.func,
        pressed:PropTypes.bool,

    }
    _makeid()
{
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

    _onPress = (e:Event) => {

        if(Platform.OS == 'ios'){
            if (!this.props.onPress) {
                return;
            }


            this.props.onPress(e) && this.props.onPress;

        }else{
            if(e.componentID == this.state.componentID){
                if (!this.props.onPress) {
                    return;
                }



                this.props.onPress(e) && this.props.onPress;
            }
        }


    }
    componentWillMount() {
        DeviceEventEmitter.addListener('OGOnPress', (e) => this._onPress(e));
        const componentID = this._makeid();
        this.setState({componentID: componentID})

    }

    render () {
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
                ogWaveColor:processColor(this.props.waveFormStyle.waveColor),
                ogScrubColor:processColor(this.props.waveFormStyle.scrubColor),
            },

            src: {
                uri:uri,
                isNetwork:isNetwork,
                isAsset:isAsset,
                type: source.type,
                mainVer: source.mainVer || 0,
                patchVer: source.patchVer || 0,
            },
            componentID:this.state.componentID,
        });

        return <OGWaverformView {...nativeProps} onPress={this._onPress} />;
    }
};

const OGWaverformView = requireNativeComponent('OGWave' , WaveForm)




