
# react-native-audiowaveform
React Native component for visuaization of audio files waveform.
Very early stage, will add more configuration options and styles eventually.
Android is on progress, so right now working just for iOS.

<img src="/screenshots/screen2.png" alt="sounWaves" style="width: 60px;"/>
## Getting started

`$ npm react-native-audiowaveform --save`

### Mostly automatic installation

`$ react-native link react-native-audiowaveform`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-audiowaveform` and add `OGReactNativeWaveform.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libOGReactNativeWaveform.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android
`$ Currently no available, working on it...`


## Usage
```javascript
import WaveForm from 'react-native-audiowaveform';

<WaveForm source={require('./path/to/your/file.mp3')}>
</WaveForm>


```
  
