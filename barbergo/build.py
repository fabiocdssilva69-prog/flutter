import subprocess
import sys
import os

print("🔨 Iniciando build do APK...")

# Usar Flutter do workspace
flutter_bin = os.path.join(os.getcwd(), "flutter", "bin", "flutter.bat")

# Build APK
result = subprocess.run(
    [flutter_bin, "build", "apk", "--release"],
    capture_output=False,
    text=True,
    shell=True
)

if result.returncode == 0:
    print("✅ Build concluído!")
    
    # Instalar
    print("📲 Instalando no dispositivo...")
    install_result = subprocess.run(
        [flutter_bin, "install", "-d", "uwbekb8hpf6lamts"],
        capture_output=False,
        text=True,
        shell=True
    )
    
    if install_result.returncode == 0:
        print("✅ Instalação concluída!")
        print("🚀 Teste o app agora!")
    else:
        print("❌ Erro na instalação")
        sys.exit(1)
else:
    print("❌ Erro no build")
    sys.exit(1)
