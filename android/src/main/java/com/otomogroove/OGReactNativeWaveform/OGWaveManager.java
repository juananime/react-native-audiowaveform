package com.otomogroove.OGReactNativeWaveform;

import android.os.AsyncTask;
import android.os.Environment;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.views.image.ReactImageView;
import com.ringdroid.WaveformView;
import com.ringdroid.soundfile.SoundFile;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigInteger;
import java.net.URL;
import java.net.URLConnection;
import java.security.SecureRandom;
import java.security.acl.LastOwnerException;
import java.util.Random;

/**
 * Created by juanjimenez on 13/01/2017.
 */

public class OGWaveManager extends SimpleViewManager<WaveformView> implements LifecycleEventListener {
    private long mLoadingLastUpdateTime;
    private boolean mLoadingKeepGoing;
    private long mRecordingLastUpdateTime;
    private boolean mRecordingKeepGoing;
    private double mRecordingTime;
    private boolean mFinishActivity;

    private SoundFile mSoundFile;
    private File mFile;
    private String mFilename;
    private String mArtist;
    private String mTitle;
    private int mNewFileKind;
    private boolean mWasGetContentIntent;


    private String mInfoContent;

    private boolean mKeyDown;
    private String mCaption = "";
    private int mWidth;
    private int mMaxPos;
    private int mStartPos;
    private int mEndPos;
    private boolean mStartVisible;
    private boolean mEndVisible;
    private int mLastDisplayedStartPos;
    private int mLastDisplayedEndPos;
    private int mOffset;
    private int mOffsetGoal;
    private int mFlingVelocity;
    private int mPlayStartMsec;
    private int mPlayEndMsec;

    private boolean mIsPlaying;

    private boolean mTouchDragging;
    private float mTouchStart;
    private int mTouchInitialOffset;
    private int mTouchInitialStartPos;
    private int mTouchInitialEndPos;
    private long mWaveformTouchStartMsec;
    private float mDensity;
    private int mMarkerLeftInset;
    private int mMarkerRightInset;
    private int mMarkerTopOffset;
    private int mMarkerBottomOffset;

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


    void deleteFiles(String folder, String ext)
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
    }
    @Override
    public WaveformView createViewInstance(ThemedReactContext context) {
        context.addLifecycleEventListener(this);

        deleteFiles(Environment.getExternalStorageDirectory().toString(),"mp3");

       // mWaveView = new WaveformView(context);

        return new WaveformView(context);
    }


   @ReactProp(name = "src")
    public void setSrc(WaveformView view, @Nullable ReadableMap src) {
        Log.e("XSXSXS",":XSXGOT THE FUCKING SRC    SXS::: "+src.getString("uri"));

       view.setmURI(src.getString("uri"));
    }


    @ReactProp(name = "waveFormStyle")
    public void setWaveFormStyle(WaveformView view, @Nullable ReadableMap waveFormStyle) {
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

    /**private void finishOpeningSoundFile(SoundFile soundFile) {
        mWaveView.setSoundFile(soundFile);
        mWaveView.recomputeHeights(mDensity);

        mMaxPos = mWaveView.maxPos();
        mLastDisplayedStartPos = -1;
        mLastDisplayedEndPos = -1;

        mTouchDragging = false;

        mOffset = 0;
        mOffsetGoal = 0;
        mFlingVelocity = 0;

        if (mEndPos > mMaxPos)
            mEndPos = mMaxPos;




        updateDisplay();
    }**/

    /**private synchronized void updateDisplay() {

        Log.e("Aaaa","AAAAAAAAAAAAAAAA");


        mWaveView.invalidate();





        Log.e("XSXGOT","VFVFVFVFVFVFVFVFVFVFVFVFV");

    }**/

    private   String random() {
        return new BigInteger(130, new SecureRandom()).toString(32);
    }

}

