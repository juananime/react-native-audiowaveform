package com.otomogroove.OGReactNativeWaveform;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.Log;
import android.view.View;

import static com.facebook.react.common.ReactConstants.TAG;

/**
 * Created by juanjimenez on 16/01/2017.
 */

public class OGUIWaveView extends View {

    private float mCurrentSeek = 0;

    public int scrubColor;

    public OGUIWaveView(Context context) {
        super(context);
    }

    public void updatePlayHead(float currentSeek){
        mCurrentSeek = currentSeek;
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        float currrentXPos = mCurrentSeek * canvas.getWidth();
        // Draw a solid color on the canvas as background
        canvas.drawColor(Color.TRANSPARENT);

        // Initialize a new Paint instance to draw the line
        Paint paint = new Paint();
        // Line color
        paint.setColor(scrubColor);
        paint.setStyle(Paint.Style.STROKE);
        // Line width in pixels
        paint.setStrokeWidth(8);
        paint.setAntiAlias(true);
        canvas.drawLine(currrentXPos, 0, currrentXPos, canvas.getHeight(), paint);
    }
}
