import React, { Component } from "react";

import WaveForm from "react-native-audiowaveform";

export default class WaveformWrapper extends Component {
  constructor(props) {
    super(props);

    this.state = {
      playAudio: false,
      stopAudio: true
    };
  }
  static propTypes = {
    ...WaveForm.propTypes
  };

  changestate = () => {
    this.setState({ playAudio: !this.state.playAudio });
  }

  render() {
    return (
      <WaveForm
        style={this.props.style}
        onPress={this.changestate}
        source={this.props.source}
        stop={this.state.stopAudio}
        play={this.state.playAudio}
        autoPlay={this.props.autoPlay}
        waveFormStyle={{
          waveColor: this.props.waveFormStyle.waveColor,
          scrubColor: this.props.waveFormStyle.scrubColor
        }}
      />
    );
  }
}
