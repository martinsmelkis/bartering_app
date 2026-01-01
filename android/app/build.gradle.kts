plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
}

android {
    namespace = "org.barter.barterapp.barter_app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keyProperties["keyAlias"] as String?
            keyPassword = keyProperties["keyPassword"] as String?
            storeFile = file(keyProperties["storeFile"] as String?)
            storePassword = keyProperties["storePassword"] as String?
        }
    }

    defaultConfig {
        applicationId = "org.barter.barterapp.barter_app"
        minSdk = 26
        targetSdk = 36
        versionCode = 1
        versionName = "0.0.1"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")

            // ===== CODE OBFUSCATION & OPTIMIZATION =====
            // Enables R8 code shrinking, obfuscation, and optimization
            isMinifyEnabled = true

            // Shrink resources (removes unused resources)
            isShrinkResources = true

            // Includes the default ProGuard rules optimized for Android
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Enable full mode for maximum optimization
            // This applies advanced optimizations
            isDebuggable = false
            isJniDebuggable = false
            isRenderscriptDebuggable = false

            // NDK debug symbols (optional - set to FULL for release)
            ndk {
                debugSymbolLevel = "FULL"
            }
        }

        debug {
            // Keep debug builds fast and easy to debug
            isMinifyEnabled = false
            isShrinkResources = false
            isDebuggable = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
