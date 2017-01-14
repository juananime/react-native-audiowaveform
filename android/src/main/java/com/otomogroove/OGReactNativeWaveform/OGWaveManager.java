package com.otomogroove.OGReactNativeWaveform;

import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.views.image.ReactImageView;

/**
 * Created by juanjimenez on 13/01/2017.
 */

public class OGWaveManager extends ViewGroupManager<OGWaveView> implements LifecycleEventListener {
    public static final String REACT_CLASS = "OGWave";
    private OGWaveView mWaveView;

    @Override
    public String getName() {

        return REACT_CLASS;
    }

    @Override
    public OGWaveView createViewInstance(ThemedReactContext context) {
        context.addLifecycleEventListener(this);
        mWaveView = new OGWaveView(context);

        return mWaveView;
    }


   @ReactProp(name = "src")
    public void setSrc(OGWaveView view, @Nullable ReadableMap src) {
        Log.e("XSXSXS",":XSXGOT THE FUCKING SRC    SXS::: ");
    }


    @ReactProp(name = "waveFormStyle")
    public void setWaveFormStyle(OGWaveView view, @Nullable ReadableMap waveFormStyle) {
        Log.e("XSXSXS","XSXSXS:::: "+waveFormStyle.getInt("rightWaveColor"));
    }


    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {

    }
}
