# Keep the entire Dash manifest parser to avoid issues with method parameters being optimized away.
-keep class androidx.media3.exoplayer.dash.manifest.** { *; }

# Specifically keep the problematic method to ensure its arguments are not optimized away.
-keep class androidx.media3.exoplayer.dash.manifest.DashManifestParser {
    public * parseMediaPresentationDescription(org.xmlpull.v1.XmlPullParser, android.net.Uri);
}
