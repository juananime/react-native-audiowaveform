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

export default class audioWave extends Component {




    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>
                    react-native-audiowaveform for IOS
                </Text>
                <Text style={styles.welcome} >
                    by Otomogroove 2017
                </Text>

                {song1}

                <WaveForm style={styles.waveform}
                          source={require('./audio/intro.mp3')}
                          waveFormStyle={{leftWaveColor:'#ffffff', rightWaveColor:'#ffffff'}}>


                </WaveForm>
                <WaveForm style={styles.waveform}
                          autoPlay={true}
                          source={require('./audio/wildbot.mp3')}
                          waveFormStyle={{leftWaveColor:'lightgrey', rightWaveColor:'#ffffffff'}}>

                </WaveForm>


            </View>
        );
    }
}

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
const song1 =  <WaveForm style={styles.waveform}

                         source={require('./audio/intro.mp3')}
                         waveFormStyle={{leftWaveColor:'lightgrey', rightWaveColor:'lightgrey'}} />
AppRegistry.registerComponent('audioWave', () => audioWave);
