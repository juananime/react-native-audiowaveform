package com.otomogroove.OGReactNativeWaveform;

import android.content.Context;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.FrameLayout;

import com.facebook.react.bridge.ReactContext;
import com.ringdroid.WaveformView;
import com.ringdroid.soundfile.SoundFile;

import java.io.IOException;

import static com.facebook.react.common.ReactConstants.TAG;

/**
 * Created by juanjimenez on 13/01/2017.
 */

public class OGWaveView extends FrameLayout {


    private final OGUIWaveView mUIWave;
    private MediaPlayer mMediaPlayer;
    private WaveformView mWaveView;
    private SoundFile soundFile;

    private String componentID;

    private ReactContext mContext;
    private int mWaveColor;
    private int mScrubColor;

    private boolean mAutoplay = false;
    private boolean isCreated = false;




    public OGWaveView(ReactContext context) {
        super(context);
        mContext = context;

        mWaveView = new WaveformView(mContext, this);
        mUIWave = new OGUIWaveView(mContext);


        mUIWave.setBackgroundColor(Color.TRANSPARENT);


    }
    public void setmWaveColor(int mWaveColor) {

        this.mWaveView.setmWaveColor(mWaveColor);


    }
    public void setScrubColor(int scrubcolor){
        mScrubColor = scrubcolor;
        mUIWave.scrubColor=this.mScrubColor;
        mUIWave.invalidate();
    }

    public void setEarpiece(boolean earpiece) {
        Log.e(TAG, "setEarpiece: " + earpiece);

        if(this.soundFile == null){
            return;
        }

        int length = this.mMediaPlayer.getCurrentPosition();
        this.mMediaPlayer.release();
        this.mMediaPlayer = null;
        this.createMediaPlayer();

        try {
            this.mMediaPlayer.reset();
            this.mMediaPlayer.setDataSource(this.soundFile.getInputFile().getPath());
            if (earpiece) {
                this.setEarPieceAudioStream();
            } else {
               this.setSpeakerAudioStream();
            }
            this.mMediaPlayer.prepare();
            this.mMediaPlayer.start();
            this.mMediaPlayer.seekTo(length);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void setEarPieceAudioStream(){
        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            this.mMediaPlayer.setAudioAttributes(
                new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
            );
        } else {
            this.mMediaPlayer.setAudioStreamType(AudioManager.STREAM_VOICE_CALL);
        }
    }

    private void setSpeakerAudioStream(){
        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            this.mMediaPlayer.setAudioAttributes(
                    new AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_MEDIA)
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .build()
            );
        } else {
            this.mMediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
        }
    }

    public void onPlay(boolean play){
        if(play){
            this.mMediaPlayer.start();


        }else{
            if(mMediaPlayer != null && mMediaPlayer.isPlaying())
                mMediaPlayer.pause();

        }

        progressReportinghandler.postDelayed(progressRunnable, 500);

    }
    public void onPause(){
        this.mMediaPlayer.pause();
    }
    public void onStop(){
        this.mMediaPlayer.stop();
    }

    public void setAutoPlay(boolean autoplay){
        Log.e(TAG, "setAutoPlay: " + autoplay );
        this.mAutoplay = autoplay;
        if(mAutoplay) {
            mMediaPlayer.start();
            Log.e(TAG, "setURI:starting ");
        }

        progressReportinghandler.postDelayed(progressRunnable, 500);

    }

    public void setup() {
        this.createMediaPlayer();
        addView(this.mWaveView);
        addView(this.mUIWave);
        this.mWaveView.setOnTouchListener(new OnTouchListener(){

            @Override
            public boolean onTouch(View v, MotionEvent event) {
            if(event.getAction() == MotionEvent.ACTION_DOWN){
                Log.e("OGWaveView","LCICK");
                waveformListener.waveformTouchStart(mContext, componentID);
            }
            return true;
            }

        });
    }

    private void createMediaPlayer() {
        this.mMediaPlayer = new MediaPlayer();
        this.mMediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                waveformListener.waveformFinishPlay(mContext, componentID);
            }
        });
    }

    public void setURI(String uri){
        Log.d("XSXGOT", "Setting URI to: " + uri);

        if (uri.isEmpty()) {
            Log.d("XSXGOT", "URI is empty");
            return;
        }

        this.mWaveView.setmURI(uri);

        if (!isCreated) {
            isCreated = true;
            setup();
        }
    }

    public SoundFile getSoundFile() {
        return soundFile;
    }

    public void setSoundFile(SoundFile soundFile) {
        this.soundFile = soundFile;

        try {
            Log.d("XSXGOT", "Setting datasource to: " + soundFile.getInputFile().getPath());
            mMediaPlayer.reset();
            mMediaPlayer.setDataSource(soundFile.getInputFile().getPath());
            mMediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mMediaPlayer.prepare();
        } catch (IOException e) {
            e.printStackTrace();
        }

        Log.e(TAG, "setURI: mMediaPlayer is"+mMediaPlayer.getDuration());
    }

    private WaveformView.WaveformListener waveformListener;



    public WaveformView.WaveformListener getWaveformListener() {
        return waveformListener;
    }

    public void setWaveformListener(WaveformView.WaveformListener waveformListener) {
        this.waveformListener = waveformListener;
    }

    private Handler progressReportinghandler = new Handler();
    private Runnable progressRunnable = new Runnable() {

        public void run() {
            try {
                if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {
                    new UpdateProgressRequest().execute();

                    // seconds
                    progressReportinghandler.postDelayed(progressRunnable, 100);
                }
            } catch (IllegalStateException ex) {
                ex.getStackTrace();
            }
        };
    };

    public String getComponentID() {
        return componentID;
    }

    public void setComponentID(String componentID) {
        this.componentID = componentID;
    }


    protected class UpdateProgressRequest extends AsyncTask<Void, Void, Float> {

        @Override
        protected Float doInBackground(Void... params) {

            if (mMediaPlayer.isPlaying()) {
                String offset = Integer.valueOf(
                        mMediaPlayer.getCurrentPosition()).toString();



                Float currrentPos = (float) mMediaPlayer.getCurrentPosition()/mMediaPlayer.getDuration();

                return currrentPos;
            }
            return null;
        }

        @Override
        protected void onPostExecute(Float aFloat) {
            super.onPostExecute(aFloat);


            mUIWave.updatePlayHead(aFloat);
        }
    }



}
