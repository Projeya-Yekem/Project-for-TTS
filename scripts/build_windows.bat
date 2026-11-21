@echo off
echo === Building Kurmanji-TTS for Windows ===
cd /d "%~dp0.."

rem Detect virtual environment in priority order: standard Windows .venv, .build-venv, MSYS2 .venv
set "VENV_DIR="
set "PY="
set "FLET="
if exist ".venv\Scripts\python.exe" (
  set "VENV_DIR=.venv"
  set "PY=.venv\Scripts\python.exe"
  set "FLET=.venv\Scripts\flet.exe"
) else if exist ".build-venv\Scripts\python.exe" (
  set "VENV_DIR=.build-venv"
  set "PY=.build-venv\Scripts\python.exe"
  set "FLET=.build-venv\Scripts\flet.exe"
) else if exist ".venv\bin\python.exe" (
  set "VENV_DIR=.venv"
  set "PY=.venv\bin\python.exe"
  set "FLET=.venv\bin\flet.exe"
)

if not exist "%PY%" (
  echo [ERROR] Virtual environment not found. Run: python -m venv .venv then pip install -r requirements.txt
  exit /b 1
)

echo Using virtual environment: %VENV_DIR%
"%PY%" -m pip install pyinstaller
if errorlevel 1 exit /b 1

rem Point urllib at certifi's CA bundle for reliable SSL downloads during build.
"%PY%" -c "import certifi;open('.certifi_path.tmp','w').write(certifi.where())"
set /p SSL_CERT_FILE=<.certifi_path.tmp
del /q .certifi_path.tmp
set "REQUESTS_CA_BUNDLE=%SSL_CERT_FILE%"

set "SHERPA_BINARIES="
if exist "%VENV_DIR%\Lib\site-packages\sherpa_onnx\lib" (
  set "SHERPA_BINARIES=--add-binary %VENV_DIR%\Lib\site-packages\sherpa_onnx\lib\*;sherpa_onnx\lib --hidden-import sherpa_onnx"
) else (
  echo [WARNING] sherpa_onnx\lib not found inside %VENV_DIR%; MMS profiles will not be bundled.
)

"%FLET%" pack main.py --name "Kurmanji-TTS" --add-data "THIRD-PARTY-LICENSES.md;." %SHERPA_BINARIES% -y
if errorlevel 1 exit /b 1
echo Copying runtime assets next to the executable...
xcopy /E /I /Y "models" "dist\models" >nul
xcopy /E /I /Y "piper" "dist\piper" >nul
copy /Y "THIRD-PARTY-LICENSES.md" "dist\" >nul
echo.
echo Build finished: dist\Kurmanji-TTS.exe
dir "dist\Kurmanji-TTS.exe"
if "%KURMANJI_NO_PAUSE%"=="" pause
