package com.otomogroove.OGReactNativeWaveform;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.media.MediaPlayer;
import android.os.AsyncTask;
import android.os.Handler;
import android.util.Log;
import android.widget.FrameLayout;

import com.ringdroid.WaveformView;

import java.io.IOException;

import static com.facebook.react.common.ReactConstants.TAG;

/**
 * Created by juanjimenez on 13/01/2017.
 */

public class OGWaveView extends FrameLayout {


    private final OGUIWaveView mUIWave;
    private MediaPlayer mMediaPlayer;
    private WaveformView mWaveView;



    private Context mContext;
    private int mWaveColor;
    private boolean mAutoplay = false;

    public OGWaveView(Context context) {
        super(context);
        mContext = context;

        mWaveView = new WaveformView(mContext);
        mUIWave = new OGUIWaveView(mContext);

        mUIWave.setBackgroundColor(Color.TRANSPARENT);


    }
    public void setmWaveColor(int mWaveColor) {

        this.mWaveView.setmWaveColor(mWaveColor);


    }

    public void onPlay(){
        this.mMediaPlayer.start();
    }

    public void setAutoPlay(boolean autoplay){
        Log.e(TAG, "setAutoPlay: " + autoplay );
        this.mAutoplay = autoplay;
        if(mAutoplay) {
            mMediaPlayer.start();
            Log.e(TAG, "setURI:starting ");
        }
        if(mAutoplay)
            progressReportinghandler.postDelayed(progressRunnable, 500);

    }

    public void setURI(String uri){
        // Create the MediaPlayer
        Log.e(TAG, "setURI: autoplay is"+mAutoplay);
        this.mWaveView.setmURI(uri);

        mMediaPlayer= new MediaPlayer();
        try {
            mMediaPlayer.setDataSource(uri);
            mMediaPlayer.prepare();



        } catch (IOException e) {
            e.printStackTrace();
        }



        addView(this.mWaveView);
        addView(this.mUIWave);


    }




    private Handler progressReportinghandler = new Handler();
    private Runnable progressRunnable = new Runnable() {

        public void run() {
            try {
                if (mMediaPlayer.isPlaying()) {
                    new UpdateProgressRequest().execute();

                    // seconds
                    progressReportinghandler.postDelayed(progressRunnable, 100);
                }
            } catch (IllegalStateException ex) {
                ex.getStackTrace();
            }
        };
    };

    protected class UpdateProgressRequest extends AsyncTask<Void, Void, Float> {

        @Override
        protected Float doInBackground(Void... params) {

            if (mMediaPlayer.isPlaying()) {
                String offset = Integer.valueOf(
                        mMediaPlayer.getCurrentPosition()).toString();

                Log.e(TAG, "doInBackground: "+ mMediaPlayer.getCurrentPosition() + " of toal: "+mMediaPlayer.getDuration() );

                Float currrentPos = (float) mMediaPlayer.getCurrentPosition()/mMediaPlayer.getDuration();

                return currrentPos;
            }
            return null;
        }

        @Override
        protected void onPostExecute(Float aFloat) {
            super.onPostExecute(aFloat);

            Log.e(TAG, "onPostExecute: " + aFloat );

            mUIWave.updatePlayHead(aFloat);
        }
    }



}
