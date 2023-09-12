export declare module 'react-native-audiowaveform' {
  import { ComponentType } from 'react';
  import { NativeWaveType, WaveObjectPropsType } from 'react-native-audiowaveform';

  const WaveForm: ComponentType<WaveObjectPropsType>;
  export default WaveForm;
}

export declare type NativeWaveType = {
  componentID: number;
} & WaveObjectPropsType;
  
export declare type WaveObjectPropsType = {
  autoPlay: boolean;
  play: boolean;
  source: number;
  stop: boolean;
  style?: number | null;
  waveFormStyle?: WaveformStyleType | null;
  onPress?: (() => void) | null;
  onFinishPlay?: (() => void) | null;
  earpiece: boolean;
};
  
export  declare type WaveformStyleType = {
  scrubColor: string;
  waveColor: string;
};
