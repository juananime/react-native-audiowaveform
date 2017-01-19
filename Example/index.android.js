/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    NativeModules,
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';
import  WaveForm  from './node_modules/react-native-audiowaveform'
import WaveformWrapper from './WaveformWrapper'
export default class audioWave extends Component {


    _onPressButton(sender) {
        console.log("XSXSXS ::: STTTTTTTTTTTs :: "+sender.nativeEvent.onPress);
        song1.play();

    }


    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>
                    react-native-audiowaveform for IOS
                </Text>
                <Text style={styles.welcome} >
                    by Otomogroove 2017
                </Text>







                <WaveformWrapper autoPlay={false} style={styles.waveform} waveFormStyle={{waveColor:'gray',scrubColor:'white'}} source={require('./audio/wildbot.mp3')}/>
                <WaveformWrapper autoPlay={false} style={styles.waveform} waveFormStyle={{waveColor:'gray',scrubColor:'white'}} source={require('./audio/wildbot.mp3')}/>



            </View>
        );
    }
}
var  colors = ['#ddd', '#efefef', 'red', '#666', 'rgba(0,0,0,.1)', '#ededed'];
var backgroundcolors = ['green', 'black', 'orange', 'blue', 'purple', 'pink'];
const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection:'column',
        padding:20,
        paddingTop:50,
        backgroundColor:'lightcyan'

    },
    waveform: {
        flex:1,
        margin:10,
        backgroundColor:'lightslategray'


    },
    welcome:{
        flex:0.2,
        marginLeft:10,
    }

});

AppRegistry.registerComponent('audioWave', () => audioWave);
