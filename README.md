
# react-native-waveform

<img src="/screenshots/screen1.png" alt="Drawing" style="width: 60px;"/>
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

<WaveForm style={styles.waveform} source={require('./audio/intro.mp3')}>
</WaveForm>


```
  
