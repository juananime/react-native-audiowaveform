/**
 * Created by juanjimenez on 07/12/2016.
 * Otomogroove ltd 2017
 */

"use strict";
import React, { PureComponent } from "react";
import {
  Platform,
  processColor,
  DeviceEventEmitter,
  requireNativeComponent,
  NativeModules
} from 'react-native';

import resolveAssetSource from "react-native/Libraries/Image/resolveAssetSource";

type StateType = { componentID: string };
const wave = NativeModules.OGWaveManager;

const _makeid = () => {
  let text = "";
  const possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for (var i = 0; i < 5; i++) text += possible.charAt(Math.floor(Math.random() * possible.length));

  return text;
};

export default class WaveForm extends PureComponent<WaveObjectPropsType, StateType> {
  constructor(props) {
    super(props);
    this.state = {
      componentID: _makeid()
    };

    DeviceEventEmitter.addListener("OGOnPress", this._onPress);
    DeviceEventEmitter.addListener("OGFinishPlay", this._onFinishPlay);
  }

  _onPress = (e) => {
    const event = Platform.OS === "ios" ? e.nativeEvent : e;
    if (event.componentID === this.state.componentID && this.props.onPress) {
      this.props.onPress(event);
    }
  }

  _onFinishPlay = (e) => {
    const event = Platform.OS === "ios" ? e.nativeEvent : e;
    if (event.componentID === this.state.componentID && this.props.onFinishPlay) {
      this.props.onFinishPlay(event);
    }
  };

  componentWillUnmount() {
    if (wave) {
      wave.onStopPlay(this.state.componentID, () => {});
    }
  }

  render() {
    const { source } = this.props;
    const { componentID } = this.state;
    const assetResoved = resolveAssetSource(source) || {};

    let uri = assetResoved.uri;
    if (uri && uri.match(/^\//)) {
      uri = `file://${uri}`;
    }

    const isNetwork = !!(uri && uri.match(/^https?:/));
    const isAsset = !!(uri && uri.match(/^(assets-library|file|content|ms-appx|ms-appdata):/));

    const nativeProps = {
      ...this.props,
      waveFormStyle: {
        ogWaveColor: processColor(this.props.waveFormStyle.waveColor),
        ogScrubColor: processColor(this.props.waveFormStyle.scrubColor)
      },

      src: {
        uri,
        isNetwork,
        isAsset,
        type: source.type,
        mainVer: source.mainVer || 0,
        patchVer: source.patchVer || 0
      },
      componentID
    };

    return <OGWaverformView
        {...nativeProps}
        onPress={this._onPress}
        onFinishPlay={this._onFinishPlay}
    />;
  }
}

const OGWaverformView = requireNativeComponent("OGWave", WaveForm);
