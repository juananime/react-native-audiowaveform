package com.otomogroove.OGReactNativeWaveform;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;
import android.net.Uri;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;

import com.ringdroid.WaveformView;
import com.ringdroid.soundfile.SoundFile;

import java.io.File;
import java.io.IOException;
import java.net.URI;

/**
 * Created by juanjimenez on 13/01/2017.
 */

public class OGWaveView extends View {


    private MediaPlayer mMediaPlayer;
    private Visualizer mVisualizer;

    private Context mContext;
    public OGWaveView(Context context) {
        super(context);
        mContext = context;





    }


    public void setURI(String uri){
        // Create the MediaPlayer

        mMediaPlayer= new MediaPlayer();
        try {
            mMediaPlayer.setDataSource(uri);
            mMediaPlayer.prepare();
            //mMediaPlayer.start();
        } catch (IOException e) {
            e.printStackTrace();
        }



        init();


        // Create the Visualizer object and attach it to our media player.
        mVisualizer = new Visualizer(mMediaPlayer.getAudioSessionId());
      //  mVisualizer.setCaptureSize(Visualizer.getCaptureSizeRange()[1]);
       /** mVisualizer.setDataCaptureListener(new Visualizer.OnDataCaptureListener() {
            public void onWaveFormDataCapture(Visualizer visualizer, byte[] bytes,
                                              int samplingRate) {
                //mBytes = bytes;
               // invalidate();
            }

            public void onFftDataCapture(Visualizer visualizer, byte[] bytes, int samplingRate) {}
        }, Visualizer.getMaxCaptureRate() / 2, true, false);**/

    }

    private byte[] mBytes;
    private float[] mPoints;
    private Rect mRect = new Rect();

    private Paint mForePaint = new Paint();



    private void init() {
        mBytes = null;

        mForePaint.setStrokeWidth(1f);
        mForePaint.setAntiAlias(true);
        mForePaint.setColor(Color.rgb(0, 128, 255));
    }



    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (mBytes == null) {
            return;
        }

        if (mPoints == null || mPoints.length < mBytes.length * 4) {
            mPoints = new float[mBytes.length * 4];
        }

        mRect.set(0, 0, getWidth(), getHeight());

        for (int i = 0; i < mBytes.length - 1; i++) {
            mPoints[i * 4] = mRect.width() * i / (mBytes.length - 1);
            mPoints[i * 4 + 1] = mRect.height() / 2
                    + ((byte) (mBytes[i] + 128)) * (mRect.height() / 2) / 128;
            mPoints[i * 4 + 2] = mRect.width() * (i + 1) / (mBytes.length - 1);
            mPoints[i * 4 + 3] = mRect.height() / 2
                    + ((byte) (mBytes[i + 1] + 128)) * (mRect.height() / 2) / 128;
        }

        canvas.drawLines(mPoints, mForePaint);
    }

}
