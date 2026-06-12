plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // 1. ESTO ERA LO QUE FALTABA OBLIGATORIAMENTE
    namespace = "com.example.gimnasio_app"

    compileSdk = flutter.compileSdkVersion

    // Tu versión de NDK actualizada para evitar el error de descargas
    ndkVersion = "29.0.14206865"
    // 1. AGREGA ESTE BLOQUE JUSTO AQUÍ (Para el compilador de Java)
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }


    // 2. UNIFICADO EN UN SOLO BLOQUE DEFAULTCONFIG
    defaultConfig {
        applicationId = "com.example.gimnasio_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString() // Si usas Java 21 y te da error, déjalo en VERSION_17
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

