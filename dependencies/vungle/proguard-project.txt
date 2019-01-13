# Vungle
-keep class com.vungle.warren.** { *; }
-dontwarn com.vungle.warren.error.VungleError$ErrorCode

# Moat SDK
-keep class com.moat.** { *; }
-dontwarn com.moat.**

# Okio
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Retrofit
-dontwarn okio.**
-dontwarn retrofit2.Platform$Java8

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.examples.android.model.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer