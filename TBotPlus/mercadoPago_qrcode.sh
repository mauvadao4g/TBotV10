#!/bin/bash
# MAUVADAO
# VER: 1.0.0


source /root/tokens.sh
pagamento() {
    local valor="$1"
    # Envia a requisição de pagamento à API do MercadoPago
    local transaction_request=$(
        curl -s -X POST \
        --url https://api.mercadopago.com/v1/payments \
        --header 'accept: application/json' \
        --header 'content-type: application/json' \
        --header 'Authorization: Bearer '$MP \
        --data '{
          "transaction_amount": '$valor',
          "description": "Título do produto",
          "payment_method_id": "pix",
          "payer": {
            "email": "test@test.com",
            "first_name": "Test",
            "last_name": "User",
            "identification": {
                "type": "CPF",
                "number": "19119119100"
            },
            "address": {
                "zip_code": "06233200",
                "street_name": "Av. das Nações Unidas",
                "street_number": "3003",
                "neighborhood": "Bonfim",
                "city": "Osasco",
                "federal_unit": "SP"
            }
          }
        }'
    )

    # Exibe o JSON de resposta para depuração (opcional)
    echo "$transaction_request"

    # Extrai o campo 'qr_code_base64' do JSON de resposta
    local qr_code_base64=$(echo "$transaction_request" | grep -oP '(?<="qr_code_base64":")[^"]*')

    if [[ -n "$qr_code_base64" ]]; then
        echo "Convertendo o QR Code de base64 para imagem..."
        # Decodifica o base64 e salva como arquivo de imagem
        echo "$qr_code_base64" | base64 --decode > qrcode.jpg
        echo "QR Code salvo como qrcode.jpg"
    else
        echo "Erro: Não foi possível encontrar o QR Code base64 no response."
    fi
}

pagamento "$1"
