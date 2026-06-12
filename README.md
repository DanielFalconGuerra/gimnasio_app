# Gimnasio App (Base MVVM + Firebase)

Estructura base en patrón **MVVM** para el proyecto del Gimnasio Universitario con autenticación y persistencia en Firebase.

## Módulos Implementados

1. **Módulo de Usuario**: Formulario de perfil (email institucional, edad, peso, estatura, nivel).
2. **Módulo de Rutinas**: Rutinas por tipo (Fuerza, Resistencia, Acondicionamiento) con detalles y recordatorios de calentamiento.
3. **Firebase**: Auth + Firestore para persistencia (en desarrollo).

## Módulos Pendientes

- **Módulo de Seguridad**: Avisos legales, advertencias por ejercicio, recordatorios de calentamiento.
- **Módulo de Ejercicios**: Videos demostrativos, errores comunes, músculos trabajados.

## Setup y Ejecución

### 1. Descargar dependencias
```powershell
cd c:/Users/Susy/Documents/MTRO.MARCO/flutter/gimnasio_app
flutter pub get
```

### 2. Configurar Firebase (IMPORTANTE)

El archivo `lib/firebase_options.dart` contiene valores placeholder. **Necesitas reemplazarlos con tus credenciales reales**:

#### Opción A: Usar FlutterFire CLI
```powershell
# Si tienes flutterfire instalado y PATH configurado
flutterfire configure --project <TU_PROJECT_ID> --platforms android,web --android-package-name com.universidad.gimnasio

# Si no está en PATH, usa:
dart pub global run flutterfire_cli configure --project <TU_PROJECT_ID> --platforms android,web --android-package-name com.universidad.gimnasio
```

#### Opción B: Manual (desde Firebase Console)
1. Ve a [Firebase Console](https://console.firebase.google.com) → Tu proyecto
2. Copia las claves de **Android** (build.gradle o JSON) y **Web** (config JS)
3. Reemplaza las constantes en `lib/firebase_options.dart`:
   - `webApiKey`, `androidApiKey`, `webAppId`, `androidAppId`, etc.

### 3. Ejecutar la app
```powershell
flutter run
```

La app mostrará:
- Pantalla de bienvenida con botones para "Completar perfil" y "Ver rutinas"
- Formulario de perfil (validación de email institucional)
- Listado de rutinas filtradas por tipo (Fuerza/Resistencia/Acondicionamiento)
- Detalles de rutina con recordatorio de calentamiento

## Estructura de Carpetas

```
lib/
├── main.dart                 # Entry point, provider setup
├── firebase_options.dart     # Configuración Firebase (requiere actualizar)
├── models/
│   ├── profile.dart
│   └── routine.dart
├── viewmodels/
│   ├── profile_viewmodel.dart
│   └── routines_viewmodel.dart
├── views/
│   ├── welcome_view.dart
│   ├── profile_form.dart
│   ├── routines_list_view.dart
│   └── routine_detail_view.dart
├── widgets/
│   ├── custom_text_field.dart
│   └── routine_card.dart
└── services/
    ├── auth_service.dart
    └── firestore_service.dart
```

## Próximas Tareas (Priority)

1. **Completar Módulo de Seguridad**:
   - Modal de avisos legales al inicio
   - Advertencias por ejercicio (lesiones comunes)
   - Recordatorios de calentamiento dinámica

2. **Completa Módulo de Ejercicios**:
   - Modelo `Exercise` con videos, técnica correcta, músculos trabajados
   - Integración de URLs de YouTube o assets de video
   - Lista de errores comunes para cada ejercicio

3. **Mejorar Autenticación**:
   - Login con email/password desde AuthService
   - Registro con validación de email institucional
   - Recuperación de contraseña

4. **Agregar Persistencia Local**:
   - SharedPreferences para guardar perfil en caché
   - Sincronización con Firestore cuando hay conectividad

5. **Testing**:
   - Unit tests para ViewModels
   - Widget tests para vistas principales

## Notas Importantes

- La app funciona sin Firebase configurado (fallback a mock saves)
- Para producción, actualiza las credenciales en `firebase_options.dart`
- Asegúrate de habilitar **Authentication (Email/Password)** en Firebase Console
- Crea una colección `profiles` en Firestore con reglas de lectura/escritura apropiadas

---

**Desarrollado por**: Asistente Senior Flutter & Firebase Engineer
**Última actualización**: Feb 7, 2026
