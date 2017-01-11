
# react-native-react-native-waveform

## Getting started

`$ npm install react-native-react-native-waveform --save`

### Mostly automatic installation

`$ react-native link react-native-react-native-waveform`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-react-native-waveform` and add `OGReactNativeWaveform.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libOGReactNativeWaveform.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.OGReactNativeWaveformPackage;` to the imports at the top of the file
  - Add `new OGReactNativeWaveformPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-react-native-waveform'
  	project(':react-native-react-native-waveform').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-react-native-waveform/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-react-native-waveform')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `OGReactNativeWaveform.sln` in `node_modules/react-native-react-native-waveform/windows/OGReactNativeWaveform.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Cl.Json.OGReactNativeWaveform;` to the usings at the top of the file
  - Add `new OGReactNativeWaveformPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import OGReactNativeWaveform from 'react-native-react-native-waveform';

// TODO: What do with the module?
OGReactNativeWaveform;
```
  