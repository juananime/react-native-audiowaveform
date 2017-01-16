package com.otomogroove.OGReactNativeWaveform;

import android.support.annotation.Nullable;
import android.util.Log;
import android.view.ViewGroup;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.ringdroid.WaveformView;

import java.io.File;
import java.io.FilenameFilter;
import java.math.BigInteger;
import java.security.SecureRandom;

import static com.facebook.react.common.ReactConstants.TAG;

/**
 * Created by juanjimenez on 13/01/2017.
 */

public class OGWaveManager extends SimpleViewManager<OGWaveView> implements LifecycleEventListener {




    public static final String REACT_CLASS = "OGWave";
    //private WaveformView mWaveView;

    @Override
    public String getName() {

        return REACT_CLASS;
    }


    public class GenericExtFilter implements FilenameFilter {

        private String ext;

        public GenericExtFilter(String ext) {
            this.ext = ext;
        }

        public boolean accept(File dir, String name) {
            return (name.endsWith(ext));
        }
    }


    /**void deleteFiles(String folder, String ext)
    {
        File dir = new File(folder);
        if (!dir.exists())
            return;
        File[] files = dir.listFiles(new GenericExtFilter(ext));
        for (File file : files)
        {
            if (!file.isDirectory())
            {
                boolean result = file.delete();
                Log.d("TAG", "Deleted:" + result);
            }
        }
    }**/
    @Override
    public OGWaveView createViewInstance(ThemedReactContext context) {
        context.addLifecycleEventListener(this);

       // deleteFiles(Environment.getExternalStorageDirectory().toString(),"mp3");

       // mWaveView = new WaveformView(context);

        return new OGWaveView(context);
    }


   @ReactProp(name = "src")
    public void setSrc(OGWaveView view, @Nullable ReadableMap src) {


       view.setURI(src.getString("uri"));
    }



    @ReactProp(name = "autoPlay", defaultBoolean = false)
    public void setAutoPlay(OGWaveView view, boolean autoPlay) {
        Log.e("XSXSXS","setAutoPlay:::: "+autoPlay);
        view.setAutoPlay(autoPlay);
    }


    @ReactProp(name = "waveFormStyle")
    public void setWaveFormStyle(OGWaveView view, @Nullable ReadableMap waveFormStyle) {


        view.setmWaveColor(waveFormStyle.getInt("rightWaveColor"));
    }

 

    @ReactMethod
    public void play(@Nullable Callback onPlayed){
        Log.e(TAG, "XXXonPlay: " );

        onPlayed.invoke("PLLLLAAYYYEDD");

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


    private   String random() {
        return new BigInteger(130, new SecureRandom()).toString(32);
    }

}

