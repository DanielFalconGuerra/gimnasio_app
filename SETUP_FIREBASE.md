# Guía: Configurar Firebase en Gimnasio App

## Prerrequisitos

- Cuenta Google (para Firebase)
- Proyecto Firebase creado en [console.firebase.google.com](https://console.firebase.google.com)
- Flutter CLI instalado
- Android SDK configurado (si vas a testear en Android)

## Paso 1: Obtener las Credenciales de Firebase

### Para Android

1. Ve a **Firebase Console** → Tu proyecto → **Configuración del proyecto** (engranaje arriba a la izq.)
2. En la pestaña **Aplicaciones**, selecciona o añade tu app Android con:
   - **Nombre del paquete**: `com.universidad.gimnasio`
   - **Nombre de depuración (SHA-1)**: (Opcional, pero recomendado para Google Sign-In)
3. Descarga el archivo `google-services.json` y colócalo en:
   ```
   android/app/google-services.json
   ```

### Para Web (Opcional)

1. En **Firebase Console** → Tu proyecto → **Configuración del proyecto** → **Aplicaciones**
2. Añade una app **Web** y copia la configuración:
   ```javascript
   const firebaseConfig = {
     apiKey: "...",
     authDomain: "...",
     databaseURL: "...",
     projectId: "...",
     storageBucket: "...",
     messagingSenderId: "...",
     appId: "..."
   };
   ```

## Paso 2: Actualizar `lib/firebase_options.dart`

Reemplaza los valores placeholder (AIzaSyD_Dummy_*) con los reales obtenidos en Paso 1:

```dart
// Web
const webApiKey = '<COPIA_apiKey>';
const webAppId = '<COPIA_appId>';
const webMessagingSenderId = '<COPIA_messagingSenderId>';
const webProjectId = '<COPIA_projectId>';
const webAuthDomain = '<COPIA_authDomain>';
const webDatabaseURL = '<COPIA_databaseURL>';
const webStorageBucket = '<COPIA_storageBucket>';

// Android
const androidApiKey = '<COPIA_apiKey>';
const androidAppId = '<COPIA_appId>';
const androidMessagingSenderId = '<COPIA_messagingSenderId>';
const androidProjectId = '<COPIA_projectId>';
const androidDatabaseURL = '<COPIA_databaseURL>';
const androidStorageBucket = '<COPIA_storageBucket>';
```

## Paso 3: Habilitar Autenticación y Firestore en Firebase

### Authentication
1. **Firebase Console** → Tu proyecto → **Authentication** (lado izq.)
2. Haz clic en **Empezar**
3. Habilita **Email/Contraseña** como proveedor

### Firestore
1. **Firebase Console** → Tu proyecto → **Firestore Database** (lado izq.)
2. Haz clic en **Crear base de datos**
3. Selecciona: **Modo de inicio de sesión**
4. Región: `us-central1` (o la más cercana)
5. Una vez creada, ve a **Reglas** y reemplaza con:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura/escritura solo al usuario autenticado su propio perfil
    match /profiles/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // Rutinas públicas de lectura
    match /routines/{document=**} {
      allow read: if true;
    }
  }
}
```

Publica las reglas.

## Paso 4: Compilar y Probar

```powershell
cd c:/Users/Susy/Documents/MTRO.MARCO/flutter/gimnasio_app

# Descargar dependencias
flutter pub get

# Limpiar build previos (si hay conflictos)
flutter clean
flutter pub get

# Ejecutar en emulador Android
flutter run
```

## Paso 5: Validar Funcionamiento

1. **Pantalla de Bienvenida**: Debería mostrarse con botones "Completar perfil" y "Ver rutinas"
2. **Formulario de Perfil**:
   - Ingresa un email institucional (ej.: `usuario@universidad.edu`)
   - Completa: edad, peso, estatura, nivel
   - Haz clic en "Guardar perfil"
   - Si Firebase está bien configurado, los datos se guardarán en Firestore
3. **Ver Rutinas**: Filtra rutinas por tipo (Fuerza/Resistencia/Acondicionamiento)

## Troubleshooting

### Error: "firebase_core plugin not found"
```bash
flutter pub get
flutter clean
flutter pub get
```

### Error: "Failed to initialize Google Play services"
- Asegúrate de tener el **Android SDK** actualizado
- En Android Studio: **SDK Manager** → Instala **Google Play Services** (v35+)

### Error: "com.google.android.gms.common.GooglePlayServicesNotAvailableException"
- Executa en un emulador con **Google Play API** activado
- O usa un dispositivo físico con Google Play Services

### Las credenciales no funcionan
- Verifica que `google-services.json` esté en `android/app/`
- Revisa que el `projectId` en `firebase_options.dart` coincida con el de tu proyecto Firebase
- En Firebase Console, asegúrate de que la app **Android** con packageName `com.universidad.gimnasio` esté registrada

## Alternativa: Usar FlutterFire CLI para Auto-Setup (Avanzado)

Si lograste instalar `flutterfire` correctamente:

```bash
flutterfire configure --project <YOUR_PROJECT_ID> --platforms android --android-package-name com.universidad.gimnasio
```

Esto actualizará automáticamente `android/google-services.json` y `lib/firebase_options.dart`.

---

**Soporte**: Si encuentras problemas, consulta [Firebase for Flutter Docs](https://firebase.flutter.dev/docs/overview).
