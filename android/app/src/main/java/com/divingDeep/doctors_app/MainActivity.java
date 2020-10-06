package com.divingDeep.doctors_app;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String channelID = getString(R.string.notification_channel_id);
            CharSequence name = getString(R.string.notification_channel_name);
            String descriptionText = getString(R.string.notification_channel_desc);
            int importance = NotificationManager.IMPORTANCE_HIGH;


            NotificationChannel channel = new NotificationChannel(channelID, name, importance);
            channel.setDescription(descriptionText);

            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);

            notificationManager.createNotificationChannel(channel);

        }
    }
}
