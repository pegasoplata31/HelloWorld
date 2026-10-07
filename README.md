# Beyond Words — HelloWorld

Aplicación Android Flutter para los guantes Beyondwords_Left y Beyondwords_Right.
Base: [prove_22](https://github.com/pegasoplata31/prove_22/tree/c4dbe5a1f398cb547fac908422d7b16bbabedb0a), de la misma cuenta.

## Descargar el APK

1. Abrir [Actions](https://github.com/pegasoplata31/HelloWorld/actions/workflows/build-apk.yml).
2. Entrar en la última ejecución exitosa de **Build Beyond Words APK**.
3. Descargar **Beyond-Words-APK** en Artifacts y extraer `app-release.apk`.
4. Abrir el APK en el teléfono Android y permitir la instalación desde esa fuente.

Cada cambio en `main` compila automáticamente. También se puede iniciar desde **Run workflow**.
El APK de prueba usa la firma de depuración generada por Flutter; no es una versión firmada para Google Play. Entre compilaciones, una firma diferente puede obligar a desinstalar la versión anterior: exportar las señas antes de hacerlo.

## Funciones de esta base

- Dos guantes BLE, protocolo binario de 17 bytes.
- Entrenamiento y reconocimiento de señas estáticas y dinámicas con KNN/DTW.
- Voz en 13 idiomas, según las voces instaladas en Android.
- Modo frase, exportación e importación JSON y visualización de manos.

La corrección gramatical con Gemma todavía está pendiente: el modo frase concatena las palabras traducidas. La compilación no sustituye las pruebas físicas con ambos guantes.

## Compilar localmente

Usar Flutter 3.47.6, Java 17 y el SDK de Android. Desde `Guante-De-Voz-App`:

```sh
python3 tool/prepare_android.py
flutter pub get
flutter analyze
flutter test
flutter build apk --release --no-tree-shake-icons
```

El script genera Android y reconstruye el logo desde `assets/logo.png.base64` (se conserva así para que el repositorio se pueda inicializar mediante la conexión de GitHub). La suma SHA-256 se verifica antes de compilar. Las dependencias resueltas y su archivo lock se adjuntan a cada compilación como **Build-metadata**.
