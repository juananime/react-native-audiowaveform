package com.otomogroove.OGReactNativeWaveform;

import android.support.annotation.Nullable;
import android.util.Log;


import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.ringdroid.WaveformView;


import static com.facebook.react.common.ReactConstants.TAG;

/**
 * Created by juanjimenez on 13/01/2017.
 */

public class OGWaveManager extends SimpleViewManager<OGWaveView> implements LifecycleEventListener,WaveformView.WaveformListener {




    private Callback onPressCallback;
    public static final String REACT_CLASS = "OGWave";
    private ReactContext mcontext;
    //private WaveformView mWaveView;

    @Override
    public String getName() {

        return REACT_CLASS;
    }



    @Override
    public OGWaveView createViewInstance(ThemedReactContext context) {
        context.addLifecycleEventListener(this);
        mcontext = context;

       // deleteFiles(Environment.getExternalStorageDirectory().toString(),"mp3");
        OGWaveView mWaveView = new OGWaveView(context);

        mWaveView.setWaveformListener(this);


        return mWaveView;
    }

    @Override
    public void setTestId(OGWaveView view, String testId) {
        super.setTestId(view, testId);
        Log.e("XSXGOT","TTTTTTTTTT::: "+ testId);
    }

    @ReactMethod
    public void testCallback(Callback cb) {

        Log.e("XSXGOT","TESXT CA:LBACK CALLED!!! ");
        String sampleText = "Java is fun";
        int textLength = sampleText.length();
        try{
            cb.invoke(textLength);
        }catch (Exception e){
            cb.invoke("err");
        }
    }

   @ReactProp(name = "src")
    public void setSrc(OGWaveView view, @Nullable ReadableMap src) {
        view.setURI(src.getString("uri"));
    }

    @ReactProp(name="componentID")
    public void setComponentID(OGWaveView view, String componentID) {
        Log.e("XSXGOT","componentID SETTED:::!!!!" +componentID);
        view.setComponentID(componentID);

    }



    @ReactProp(name = "autoPlay", defaultBoolean = false)
    public void setAutoPlay(OGWaveView view, boolean autoPlay) {
        Log.e("XSXSXS","setAutoPlay:::: "+autoPlay);
        view.setAutoPlay(autoPlay);
    }


    @ReactProp(name = "waveFormStyle")
    public void setWaveFormStyle(OGWaveView view, @Nullable ReadableMap waveFormStyle) {


        view.setmWaveColor(waveFormStyle.getInt("ogWaveColor"));
        view.setScrubColor(waveFormStyle.getInt("ogScrubColor"));
    }
    @ReactProp(name = "play")
    public void setPlay(OGWaveView view, @Nullable boolean play) {

            view.onPlay(play);

    }



   /** @ReactProp(name = "pause")
    public void setPause(OGWaveView view, @Nullable Callback pause){
       // view.onPlay();

    }

    @ReactProp(name = "stop")
    public void setStop(OGWaveView view, @Nullable Callback stop){
        //view.onPlay();

    }**/


    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {

    }

    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    @Override
    public void waveformTouchStart(ReactContext context, String componentID) {

        WritableMap map = Arguments.createMap();
        map.putString("componentID",componentID);
        sendEvent(context, "OGOnPress",map);
        Log.e("OGTAGDEBUG::", "waveformTouchStart: " );

    }

    @Override
    public void waveformTouchStart(float x) {

    }

    @Override
    public void waveformTouchMove(float x) {

    }

    @Override
    public void waveformTouchEnd() {

    }

    @Override
    public void waveformFling(float x) {

    }

    @Override
    public void waveformDraw() {

    }

    @Override
    public void waveformZoomIn() {

    }

    @Override
    public void waveformZoomOut() {

    }
}

