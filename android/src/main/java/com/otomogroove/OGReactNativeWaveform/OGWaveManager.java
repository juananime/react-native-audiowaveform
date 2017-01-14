package com.otomogroove.OGReactNativeWaveform;

import android.os.AsyncTask;
import android.os.Environment;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.views.image.ReactImageView;
import com.ringdroid.soundfile.SoundFile;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;

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
        Log.e("XSXSXS",":XSXGOT THE FUCKING SRC    SXS::: "+src.getString("uri"));

        new DownloadFileFromURL().execute(src.getString("uri"));
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
    /**
     * Background Async Task to download file
     * */
    class DownloadFileFromURL extends AsyncTask<String, String, String> {


        String filePath = Environment.getExternalStorageDirectory().toString() + "/temp.mp3";

        /**
         * Before starting background thread Show Progress Bar Dialog
         * */
        @Override
        protected void onPreExecute() {
            super.onPreExecute();

        }

        /**
         * Downloading file in background thread
         * */
        @Override
        protected String doInBackground(String... f_url) {
            int count;
            try {
                URL url = new URL(f_url[0]);
                URLConnection conection = url.openConnection();
                conection.connect();

                // this will be useful so that you can show a tipical 0-100%
                // progress bar
                int lenghtOfFile = conection.getContentLength();

                // download the file
                InputStream input = new BufferedInputStream(url.openStream(),
                        8192);




                // Output stream
                OutputStream output = new FileOutputStream(filePath);

                byte data[] = new byte[1024];

                long total = 0;

                while ((count = input.read(data)) != -1) {
                    total += count;
                    // publishing the progress....
                    // After this onProgressUpdate will be called
                    publishProgress("" + (int) ((total * 100) / lenghtOfFile));

                    // writing data to file
                    output.write(data, 0, count);
                }

                // flushing output
                output.flush();

                // closing streams
                output.close();
                input.close();
                Log.e("XSXGOT","Audio file complented + "+filePath);



            } catch (Exception e) {
                Log.e("XSXGOT Error: ", e.getMessage());
            }

            return null;
        }

        /**
         * Updating progress bar
         * */
        protected void onProgressUpdate(String... progress) {
            // setting progress percentage

        }

        /**
         * After completing background task Dismiss the progress dialog
         * **/
        @Override
        protected void onPostExecute(String file_url) {
            // dismiss the dialog after the file was downloaded
            SoundFile soundFile = null;
            try {
                soundFile = SoundFile.create(filePath,null);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (SoundFile.InvalidInputException e) {
                e.printStackTrace();
            }

            if(soundFile != null) {
                mWaveView.setAudioFile(soundFile);
            }else{
                Log.e("XSXGOT","SoundFile is null");
            }

        }

    }
}

