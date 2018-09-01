import React, { Component } from "react";
import { AppRegistry, StyleSheet, Text, View } from "react-native";

import WaveformWrapper from "./WaveformWrapper";
export default class audioWave extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>react-native-audiowaveform for React Native</Text>
        <Text style={styles.welcome}>by Otomogroove 2018</Text>

        <WaveformWrapper
          autoPlay={false}
          style={styles.waveform}
          waveFormStyle={{ waveColor: "lightsteelblue", scrubColor: "white" }}
          source={require("./audio/wildbot.mp3")}
        />
        <WaveformWrapper
          autoPlay={false}
          style={styles.waveform}
          waveFormStyle={{ waveColor: "lightsteelblue", scrubColor: "white" }}
          source={require("./audio/wildbot.mp3")}
        />
      </View>
    );
  }
}
const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: "column",
    padding: 20,
    paddingTop: 50,
    backgroundColor: "lightcyan"
  },
  waveform: {
    flex: 1,
    margin: 10,
    backgroundColor: "lightslategray"
  },
  welcome: {
    flex: 0.2,
    marginLeft: 10
  }
});

AppRegistry.registerComponent("audioWave", () => audioWave);
