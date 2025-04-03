plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.webview_app"
    compileSdk = 35 // Utilisation de la version de SDK compilé spécifique

    defaultConfig {
        applicationId = "com.example.webview_app"
        minSdk = 21  // Version minimale du SDK
        targetSdk = 33  // Version cible du SDK
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug") // Configuration de signature
        }
    }
}

flutter {
    source = "../.."  // Source du projet Flutter
}
