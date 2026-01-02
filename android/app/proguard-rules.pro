# ================================
# ProGuard Configuration for Barter App
# ================================

# ==================== OPTIMIZATION ====================
# Enable aggressive optimization
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Optimization algorithms
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*

# ==================== OBFUSCATION ====================
# Obfuscate everything to make reverse engineering harder
-repackageclasses ''
-allowaccessmodification
-keepattributes *Annotation*

# ==================== FLUTTER FRAMEWORK ====================
# Keep Flutter framework classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Flutter method channels
-keepclassmembers class * {
    @io.flutter.embedding.engine.plugins.FlutterPlugin public *;
}

# ==================== SECURITY CLASSES ====================
# Keep our security classes but obfuscate internals
-keep class org.barter.barterapp.barter_app.IntegrityHelper {
    public <methods>;
}

-keep class org.barter.barterapp.barter_app.MainActivity {
    public <methods>;
}

# Keep MethodChannel callbacks
-keepclassmembers class org.barter.barterapp.barter_app.MainActivity {
    public void configureFlutterEngine(io.flutter.embedding.engine.FlutterEngine);
}

# ==================== CRYPTO LIBRARIES ====================
# BouncyCastle - Keep crypto classes but allow obfuscation of implementation
-keep class org.bouncycastle.jcajce.provider.** { *; }
-keep class org.bouncycastle.jce.provider.** { *; }
-keep class org.bouncycastle.crypto.** { *; }
-keepclassmembers class * extends org.bouncycastle.crypto.* { *; }

-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Don't warn about optional BouncyCastle dependencies
-dontwarn javax.naming.**
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# ==================== NETWORKING ====================
# Retrofit & Dio
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
-keepattributes AnnotationDefault

-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*

# OkHttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# ==================== SERIALIZATION ====================
# Keep JSON serialization classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep data classes for JSON
-keepclassmembers class * {
    public <init>(...);
}

# ==================== ANDROID COMPONENTS ====================
# Keep AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-dontwarn androidx.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom views
-keepclassmembers class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(***);
    *** get*();
}

# Keep Activity methods
-keepclassmembers class * extends android.app.Activity {
    public void *(android.view.View);
}

# Keep Parcelables
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ==================== KOTLIN ====================
# Kotlin reflection
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# Coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}

# ==================== THIRD PARTY LIBRARIES ====================
# SLF4J logging
-dontwarn org.slf4j.**

# Flutter plugins (keep plugin registration)
-keep class io.flutter.plugins.** { *; }

# OSM Plugin
-keep class org.osmdroid.** { *; }
-dontwarn org.osmdroid.**

# WebSocket
-keep class org.java_websocket.** { *; }

# ==================== REMOVE LOGGING IN RELEASE ====================
# Remove all logging calls (makes reverse engineering harder)
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Remove print statements from Kotlin/Java code
-assumenosideeffects class java.io.PrintStream {
    public void println(%);
    public void println(**);
    public void print(%);
    public void print(**);
}

# ==================== STACK TRACE OBFUSCATION ====================
# Remove source file names and line numbers (makes stack traces useless for attackers)
# WARNING: This makes debugging harder! Comment out during development
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# ==================== RESOURCES ====================
# Keep notification icons (referenced by string name from Flutter)
-keep class **.R$drawable {
    public static final int ic_notification;
    public static final int ic_notification_simple;
}

# Prevent resource shrinking from removing notification icons
-keepclassmembers class **.R$* {
    public static <fields>;
}

# ==================== ADDITIONAL SECURITY ====================
# Remove debug info
-keepattributes !LocalVariableTable,!LocalVariableTypeTable

# Obfuscate package names
-flattenpackagehierarchy

# Make everything final where possible (optimization + security)
-optimizations !code/simplification/advanced
