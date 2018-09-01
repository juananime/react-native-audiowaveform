/**
 * Created by juanjimenez on 07/12/2016.
 * Otomogroove ltd 2017
 */

"use strict";
import React, { PureComponent } from "react";
import { Platform, processColor, DeviceEventEmitter, requireNativeComponent } from "react-native";

import resolveAssetSource from "react-native/Libraries/Image/resolveAssetSource";

type StateType = { componentID: number };

export default class WaveForm extends PureComponent<WaveObjectPropsType, StateType> {
  constructor(props) {
    super(props);
    this._onPress = this._onPress.bind(this);
  }
  _makeid() {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 5; i++) text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
  }

  _onPress = e => {
    if (Platform.OS === "ios") {
      if (!this.props.onPress) {
        return;
      }

      this.props.onPress(e) && this.props.onPress;
    } else {
      if (e.componentID == this.state.componentID) {
        if (!this.props.onPress) {
          return;
        }

        this.props.onPress(e) && this.props.onPress;
      }
    }
  };
  componentWillMount() {
    DeviceEventEmitter.addListener("OGOnPress", this._onPress);
    const componentID = this._makeid();
    this.setState({ componentID });
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

    return <OGWaverformView {...nativeProps} onPress={this._onPress} />;
  }
}

const OGWaverformView = requireNativeComponent("OGWave", WaveForm);
