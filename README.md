
[![](https://img.shields.io/npm/dm/react-native-audiowaveform.svg?style=flat-square)](https://www.npmjs.com/package/react-native-audiowaveform)

# react-native-audiowaveform
React Native component for visuaization of audio files waveform.
Basic renderization of audio waveforms with play, autoplay and stop control, as well as progress and scrub control.

Regarding Android is ready with waveform's renderization and audio playback. Thus has been implemented adapting the ringDroid audio libraries, but those need much performance improvement, working on it...



<img src="/screenshots/screen32.png" alt="ios" style="width: 60px;"/>
<img src="/screenshots/screen31.png" alt="android" style="width: 60px;"/>

## Getting started

`$ npm install react-native-audiowaveform --save`

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

So far, reac-native-audiowaveform just generates a image view with the audio waveform data.
In order to show graphically a local audio file, use:

Basic custom styling:

prop.waveFormStyle.waveColor => Will set up color waveform

prop.waveFormStyle.scrubColor => Will set up color sscrubber


```javascript
import WaveForm from 'react-native-audiowaveform';

<WaveForm 
    source={require('./path/to/your/file.mp3')}  
    waveFormStyle={{waveColor:'red', scrubColor:'white'}}
>
</WaveForm>
```
  Also it is possible to get remote audio files:
 
```javascript
import WaveForm from 'react-native-audiowaveform';

<WaveForm source={{uri:'https://url/path/to/the/file.mp3'}}  />

```

Autoplayback flag, for both iOS and Android. Just call autoPlay property:
```javascript
<WaveForm autoPlay={true}
         source={require('./audio/intro.mp3')}
/>

```


In order to detect touch, now both in IOS and Android, call method onPress, also, switch play true/false will play/pause audio:
```javascript
<WaveForm style={this.props.style}
                      onPress = {(sender) => this.myMethodOnPress() }
                      source={{uri:'https://url/path/to/the/file.mp3'}}
                      play={true}
                      />

```       


Switching stop flag to true will stop and reset the audio, for example:
```javascript
<WaveForm style={this.props.style}
                      onPress = {(sender) => this.myMethodWhereAfterPressIWillChangeStateStopAudioToTrue() }
                      source={{uri:'https://url/path/to/the/file.mp3'}}
                      stop={this.state.stopAudio? true:false}
                      />
```   
                      
