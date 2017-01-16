
# react-native-audiowaveform
React Native component for visuaization of audio files waveform.
Very early stage, will add more conisfiguration options and styles eventually.
Android is ready with basic funtionalities, performance needs to get improved.


<img src="/screenshots/screen4.png" alt="sounWaves" style="width: 60px;"/>
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

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.otomogroove.OGReactNativeWaveform.OGWavePackage;` to the imports at the top of the file
  - Add `new OGWavePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-audiowaveform'
  	project(':react-native-audiowaveform').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-audiowaveform/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-audiowaveform')
  	```

## Usage
```javascript
import WaveForm from 'react-native-audiowaveform';

<WaveForm 
    source={require('./path/to/your/file.mp3')}  
    waveFormStyle={{leftWaveColor:'red', rightWaveColor:'#ffffff'}}
>
</WaveForm>


```
  
