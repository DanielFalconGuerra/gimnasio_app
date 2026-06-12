$log = 'C:\Users\Susy\.gradle\daemon\8.14\daemon-19076.out.log'
if (-not (Test-Path $log)) { Write-Output "Log no encontrado: $log"; exit 1 }
$prev = (Get-Item $log).LastWriteTime
Write-Output "Monitoring $log (snapshot at $prev). Waiting 300s..."
Start-Sleep -Seconds 300
$now = (Get-Item $log).LastWriteTime
if ($now -le $prev) {
  Write-Output "No hay nuevas entradas. Ejecutando remediación..."
  cd 'C:\Users\Susy\Documents\MTRO.MARCO\flutter\gimnasio_app\android'
  if (Test-Path '.\gradlew.bat') { .\gradlew.bat --stop }
  Write-Output "Eliminando dist y caches de Gradle (wrapper/caches 8.14)..."
  Try { Remove-Item -Recurse -Force "C:\Users\Susy\.gradle\wrapper\dists\gradle-8.14-all" -ErrorAction SilentlyContinue } Catch {}
  Try { Remove-Item -Recurse -Force "C:\Users\Susy\.gradle\caches\8.14" -ErrorAction SilentlyContinue } Catch {}
  Try { Remove-Item -Recurse -Force "C:\Users\Susy\.gradle\caches\modules-2\files-2.1" -ErrorAction SilentlyContinue } Catch {}

  # Buscar JDK 11 disponible
  $java11 = Get-ChildItem 'C:\Program Files\Java' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'jdk-?11' } | Select-Object -First 1
  if ($java11) {
    Write-Output "Se encontró JDK11 en: $($java11.FullName). Usando como JAVA_HOME temporal."
    $env:JAVA_HOME = $java11.FullName
    $env:PATH = "$($java11.FullName)\bin;${env:PATH}"
  } else {
    Write-Output "No se encontró JDK11 localmente; se mantendrá el JAVA_HOME actual."
  }

  Write-Output "Reintentando assembleDebug (no interactivo)..."
  .\gradlew.bat assembleDebug --no-daemon --refresh-dependencies --stacktrace --info --console=plain
} else {
  Write-Output "Se detectó actividad en el log ($now). No se requiere remediación."
}
