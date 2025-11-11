#!/usr/bin/env python3
"""
Script de Validação dos 3 Perfis Corrigidos no Firebase
Verifica se barber_002, barber_004, barber_005 têm todos os campos necessários
"""

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime

# Inicializar Firebase Admin SDK
# ATENÇÃO: Você precisa do arquivo de credenciais
# Baixe de: https://console.firebase.google.com/project/barbergo-38c21/settings/serviceaccounts/adminsdk
# Salve como: barbergo-38c21-firebase-adminsdk.json
cred = credentials.Certificate('barbergo-38c21-firebase-adminsdk.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

# IDs dos perfis corrigidos manualmente
CORRECTED_PROFILES = ['barber_002', 'barber_004', 'barber_005']

# Campos obrigatórios para query de Discovery funcionar
REQUIRED_FIELDS = {
    'accountType': str,  # Deve ser "barber" (inglês, lowercase)
    'email': str,
    'boostedUntil': (int, type(None)),  # number ou null
    'isPremium': bool,
    'updatedAt': int,  # number (milliseconds)
    'createdAt': int,  # number (milliseconds)
    'searchRadiusKm': int,
    'isAvailable': bool,
}

def validate_profile(profile_id: str) -> dict:
    """
    Valida se um perfil tem todos os campos obrigatórios
    Retorna dict com status e erros encontrados
    """
    doc_ref = db.collection('profiles').document(profile_id)
    doc = doc_ref.get()
    
    result = {
        'profile_id': profile_id,
        'exists': doc.exists,
        'errors': [],
        'warnings': [],
        'fields': {}
    }
    
    if not doc.exists:
        result['errors'].append('❌ DOCUMENTO NÃO EXISTE NO FIRESTORE')
        return result
    
    data = doc.to_dict()
    
    # Validar cada campo obrigatório
    for field_name, expected_type in REQUIRED_FIELDS.items():
        if field_name not in data:
            result['errors'].append(f'❌ Campo "{field_name}" FALTANDO')
            continue
        
        value = data[field_name]
        result['fields'][field_name] = value
        
        # Verificar tipo
        if isinstance(expected_type, tuple):
            # Permite múltiplos tipos (ex: int ou None)
            if not any(isinstance(value, t) for t in expected_type):
                result['errors'].append(
                    f'❌ Campo "{field_name}" tipo incorreto: {type(value).__name__} '
                    f'(esperado: {" ou ".join(t.__name__ for t in expected_type)})'
                )
        else:
            if not isinstance(value, expected_type):
                result['errors'].append(
                    f'❌ Campo "{field_name}" tipo incorreto: {type(value).__name__} '
                    f'(esperado: {expected_type.__name__})'
                )
        
        # Validações específicas
        if field_name == 'accountType':
            if value not in ['barber', 'barbershop']:
                result['errors'].append(
                    f'❌ accountType inválido: "{value}" (esperado: "barber" ou "barbershop")'
                )
            elif value != 'barber':
                result['warnings'].append(
                    f'⚠️ accountType é "{value}" (não será retornado em query para barbeiro)'
                )
        
        if field_name == 'email':
            if not value or '@' not in value:
                result['errors'].append(f'❌ Email inválido: "{value}"')
    
    # Verificar se existem campos extras importantes
    if 'name' in data:
        result['fields']['name'] = data['name']
    if 'rating' in data:
        result['fields']['rating'] = data['rating']
    
    return result

def print_result(result: dict):
    """Imprime resultado da validação de forma formatada"""
    profile_id = result['profile_id']
    
    print(f"\n{'='*60}")
    print(f"📋 PROFILE: {profile_id}")
    print(f"{'='*60}")
    
    if not result['exists']:
        print("❌ DOCUMENTO NÃO EXISTE")
        return
    
    # Status geral
    has_errors = len(result['errors']) > 0
    status = "❌ FALHOU" if has_errors else "✅ VÁLIDO"
    print(f"Status: {status}\n")
    
    # Campos encontrados
    if result['fields']:
        print("📊 Campos Encontrados:")
        for field, value in sorted(result['fields'].items()):
            print(f"  ✅ {field}: {value}")
    
    # Erros
    if result['errors']:
        print(f"\n🔴 Erros Críticos ({len(result['errors'])}):")
        for error in result['errors']:
            print(f"  {error}")
    
    # Warnings
    if result['warnings']:
        print(f"\n⚠️ Avisos ({len(result['warnings'])}):")
        for warning in result['warnings']:
            print(f"  {warning}")

def main():
    """Função principal - valida os 3 perfis corrigidos"""
    print("🔍 VALIDAÇÃO DOS PERFIS CORRIGIDOS NO FIREBASE")
    print(f"Data/Hora: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")
    print(f"Profiles: {', '.join(CORRECTED_PROFILES)}")
    
    results = []
    
    # Validar cada perfil
    for profile_id in CORRECTED_PROFILES:
        try:
            result = validate_profile(profile_id)
            results.append(result)
            print_result(result)
        except Exception as e:
            print(f"\n❌ ERRO AO VALIDAR {profile_id}: {e}")
            results.append({
                'profile_id': profile_id,
                'exists': False,
                'errors': [f'Exceção: {str(e)}'],
                'warnings': [],
                'fields': {}
            })
    
    # Resumo final
    print(f"\n{'='*60}")
    print("📊 RESUMO FINAL")
    print(f"{'='*60}")
    
    valid_count = sum(1 for r in results if len(r['errors']) == 0)
    invalid_count = len(results) - valid_count
    
    print(f"✅ Válidos: {valid_count}/{len(results)}")
    print(f"❌ Inválidos: {invalid_count}/{len(results)}")
    
    if invalid_count == 0:
        print("\n🎉 TODOS OS PERFIS ESTÃO VÁLIDOS!")
        print("✅ Discovery deve carregar 7 perfis agora")
    else:
        print("\n⚠️ AINDA HÁ PERFIS COM PROBLEMAS")
        print("❌ Discovery pode não carregar todos os 7 perfis")
        print("\nPróxima ação:")
        print("1. Corrigir campos faltantes/incorretos acima")
        print("2. Executar este script novamente")
    
    print("\n🔧 PRÓXIMO PASSO:")
    print("  flutter run -d uwbekb8hpf6lamts")
    print("  Abrir tela Discovery e contar perfis")

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f"\n💥 ERRO FATAL: {e}")
        print("\nVerifique:")
        print("1. Arquivo barbergo-38c21-firebase-adminsdk.json existe?")
        print("2. firebase-admin instalado? (pip install firebase-admin)")
        exit(1)
