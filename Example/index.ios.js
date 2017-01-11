/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
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

        <Text >
          Audio waveform React Native
        </Text>
        <Text >
          by Otomogroove
        </Text>
        <WaveForm style={styles.waveform}
                  source={require('./audio/intro.mp3')}
                  waveFormStyle={{leftWaveColor:'lightsalmon', rightWaveColor:'lightsalmon'}}
        >

        </WaveForm>


        <WaveForm style={{flex:1, margin:10,backgroundColor:'lavenderblush'}}
                  source={require('./audio/wildbot.mp3')}
                  waveFormStyle={{leftWaveColor:'indigo', rightWaveColor:'indigo'}}>

        </WaveForm>
        <WaveForm style={styles.waveform}
                  source={require('./audio/intro.mp3')}
                  waveFormStyle={{leftWaveColor:'#ffffff', rightWaveColor:'#ffffff'}}>

        </WaveForm>
        <WaveForm style={{flex:1, margin:10,backgroundColor:'lightslategray'}}
                  source={require('./audio/wildbot.mp3')}
                  waveFormStyle={{leftWaveColor:'#ffffffff', rightWaveColor:'#ffffffff'}}>

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
      backgroundColor:'lightsteelblue'

  },
  waveform: {
    flex:1,
      margin:10,
      backgroundColor:'black'


  },
    welcome:{
    flex:4,
    }

});

AppRegistry.registerComponent('audioWave', () => audioWave);
