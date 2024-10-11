// package com.livetalk.randomvideochat;

// import com.livetalk.randomvideochat.R;
// import com.google.android.gms.ads.VideoController;
// import com.google.android.gms.ads.nativead.MediaView;
// import com.google.android.gms.ads.nativead.NativeAd;
// import com.google.android.gms.ads.nativead.NativeAdView;

// import android.content.Context;
// import android.view.LayoutInflater;
// import android.view.View;
// import android.widget.Button;
// import android.widget.ImageView;
// import android.widget.RatingBar;
// import android.widget.TextView;

// import java.util.Map;

// import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

// class ListTileNativeAdFactory implements GoogleMobileAdsPlugin.NativeAdFactory {

//     private final Context context;

//     ListTileNativeAdFactory(Context context) {
//         this.context = context;
//     }

//     /**
//      * Creates a request for a new native ad based on the boolean parameters and calls the
//      * corresponding "populate" method when one is successfully returned.
//      *
//      */

//     @Override
//     public NativeAdView createNativeAd(
//             NativeAd nativeAd, Map<String, Object> customOptions) {
//         NativeAdView adView = (NativeAdView) LayoutInflater.from(context)
//                 .inflate(R.layout.list_tile_native_ad, null);

//         adView.setMediaView((MediaView) adView.findViewById(R.id.ad_media));

//         // Set other ad assets.
//         adView.setHeadlineView(adView.findViewById(R.id.ad_headline));
//         adView.setBodyView(adView.findViewById(R.id.ad_body));
//         adView.setCallToActionView(adView.findViewById(R.id.ad_call_to_action));
//         adView.setIconView(adView.findViewById(R.id.ad_app_icon));
//         adView.setPriceView(adView.findViewById(R.id.ad_price));
//         adView.setStarRatingView(adView.findViewById(R.id.ad_stars));
//         adView.setStoreView(adView.findViewById(R.id.ad_store));
//         adView.setAdvertiserView(adView.findViewById(R.id.ad_advertiser));

//         // The headline and mediaContent are guaranteed to be in every NativeAd.
//         ((TextView) adView.getHeadlineView()).setText(nativeAd.getHeadline());
//         adView.getMediaView().setMediaContent(nativeAd.getMediaContent());

//         // These assets aren't guaranteed to be in every NativeAd, so it's important to
//         // check before trying to display them.
//         if (nativeAd.getBody() == null) {
//             adView.getBodyView().setVisibility(View.INVISIBLE);
//         } else {
//             adView.getBodyView().setVisibility(View.VISIBLE);
//             ((TextView) adView.getBodyView()).setText(nativeAd.getBody());
//         }

//         if (nativeAd.getCallToAction() == null) {
//             adView.getCallToActionView().setVisibility(View.INVISIBLE);
//         } else {
//             adView.getCallToActionView().setVisibility(View.VISIBLE);
//             ((Button) adView.getCallToActionView()).setText(nativeAd.getCallToAction());
//         }

//         if (nativeAd.getIcon() == null) {
//             adView.getIconView().setVisibility(View.GONE);
//         } else {
//             ((ImageView) adView.getIconView()).setImageDrawable(
//                     nativeAd.getIcon().getDrawable());
//             adView.getIconView().setVisibility(View.VISIBLE);
//         }

//         if (nativeAd.getPrice() == null || nativeAd.getPrice()!=null) {
//             adView.getPriceView().setVisibility(View.INVISIBLE);
//         }
//         // else {
//         //     adView.getPriceView().setVisibility(View.VISIBLE);
//         //     ((TextView) adView.getPriceView()).setText(nativeAd.getPrice());
//         // }

//         if (nativeAd.getStore() == null  || nativeAd.getPrice()!=null) {
//             adView.getStoreView().setVisibility(View.INVISIBLE);
//         }

//         if (nativeAd.getStarRating() == null) {
//             adView.getStarRatingView().setVisibility(View.INVISIBLE);
//         } else {
//             ((RatingBar) adView.getStarRatingView())
//                     .setRating(nativeAd.getStarRating().floatValue());
//             adView.getStarRatingView().setVisibility(View.VISIBLE);
//         }

//         if (nativeAd.getAdvertiser() == null) {
//             adView.getAdvertiserView().setVisibility(View.INVISIBLE);
//         } else {
//             ((TextView) adView.getAdvertiserView()).setText(nativeAd.getAdvertiser());
//             adView.getAdvertiserView().setVisibility(View.VISIBLE);
//         }

//         // This method tells the Google Mobile Ads SDK that you have finished populating your
//         // native ad view with this native ad.
//         adView.setNativeAd(nativeAd);

//         // Get the video controller for the ad. One will always be provided, even if the ad doesn't
//         // have a video asset.
//         VideoController vc = nativeAd.getMediaContent().getVideoController();

//         // Updates the UI to say whether or not this ad has a video asset.
//         if (vc.hasVideoContent()) {


//             // Create a new VideoLifecycleCallbacks object and pass it to the VideoController. The
//             // VideoController will call methods on this object when events occur in the video
//             // lifecycle.
//             vc.setVideoLifecycleCallbacks(new VideoController.VideoLifecycleCallbacks() {
//                 @Override
//                 public void onVideoEnd() {
//                     // Publishers should allow native ads to complete video playback before
//                     // refreshing or replacing them with another ad in the same UI location.
//                    /* refresh.setEnabled(true);
//                     videoStatus.setText("Video status: Video playback has ended.");*/
//                     super.onVideoEnd();
//                 }
//             });
//         } else {
//             /*videoStatus.setText("Video status: Ad does not contain a video asset.");
//             refresh.setEnabled(true);*/
//         }

//         return adView;
//     }
// }