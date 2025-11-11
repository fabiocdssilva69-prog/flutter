@echo off
echo ===========================================
echo     BARBERGO - GERENCIADOR DE TESTES
echo ===========================================
echo.

echo Verificando dispositivos disponíveis...
flutter devices
echo.

echo Verificando emuladores disponíveis...
flutter emulators
echo.

echo ===========================================
echo     OPÇÕES DE TESTE:
echo ===========================================
echo [1] Testar no Emulador Android
echo [2] Testar no Chrome (Web)
echo [3] Testar no Windows Desktop
echo [4] Executar Testes Unitários
echo [5] Executar Testes de Integração
echo [6] Iniciar Emulador Android
echo [7] Parar Todos os Emuladores
echo [8] Verificar Status do Ambiente
echo [0] Sair
echo.
set /p choice="Escolha uma opção (0-8): "

if "%choice%"=="1" goto android
if "%choice%"=="2" goto chrome
if "%choice%"=="3" goto windows
if "%choice%"=="4" goto unit_tests
if "%choice%"=="5" goto integration_tests
if "%choice%"=="6" goto start_emulator
if "%choice%"=="7" goto stop_emulators
if "%choice%"=="8" goto status
if "%choice%"=="0" goto exit

echo Opção inválida!
pause
goto menu

:android
echo.
echo Iniciando aplicação no Android...
flutter run -d emulator-5554 --debug
goto end

:chrome
echo.
echo Iniciando aplicação no Chrome...
flutter run -d chrome --debug
goto end

:windows
echo.
echo Iniciando aplicação no Windows...
flutter run -d windows --debug
goto end

:unit_tests
echo.
echo Executando testes unitários...
flutter test test/auth_controller_test.dart
echo.
pause
goto menu

:integration_tests
echo.
echo Verificando se emulador está disponível...
flutter devices | findstr "emulator-5554"
if errorlevel 1 (
    echo Emulador não encontrado. Iniciando emulador...
    start /b flutter emulators --launch Medium_Phone_API_36.1
    timeout /t 15 /nobreak > nul
)
echo.
echo Executando testes de integração...
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/auth_integration_test.dart -d emulator-5554
goto end

:start_emulator
echo.
echo Iniciando emulador Android...
flutter emulators --launch Medium_Phone_API_36.1
goto end

:stop_emulators
echo.
echo Parando emuladores...
taskkill /f /im emulator.exe 2>nul
taskkill /f /im qemu-system-x86_64.exe 2>nul
echo Emuladores parados.
timeout /t 3 /nobreak > nul
goto menu

:status
echo.
echo ===========================================
echo     STATUS DO AMBIENTE
echo ===========================================
flutter doctor
echo.
echo Dispositivos conectados:
flutter devices
echo.
echo Emuladores disponíveis:
flutter emulators
echo.
pause
goto menu

:exit
echo.
echo Até logo!
timeout /t 2 /nobreak > nul
exit

:end
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause > nul
goto menu

:menu
cls
goto start

:start
goto menu