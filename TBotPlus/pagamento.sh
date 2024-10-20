#!/bin/bash
# MAUVADAO
# VER: 1.0.0

# MP=$(cat /etc/TerminusBot/info-mp)
source /root/tokens.sh
pagamento() {
    local valor="$1"
    local pix_copia_e_cola

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

    # Extrai o campo 'qr_code_base64', 'pix_copia_e_cola', e o 'payment_id'
    local qr_code_base64=$(echo "$transaction_request" | grep -oP '(?<="qr_code_base64":")[^"]*')
    pix_copia_e_cola=$(echo "$transaction_request" | grep -oP '(?<="qr_code":")[^"]*')
    local payment_id=$(echo "$transaction_request" | grep -oP '(?<="id":)[0-9]+')

    if [[ -n "$qr_code_base64" ]]; then
        echo "Convertendo o QR Code de base64 para imagem..."
        # Decodifica o base64 e salva como arquivo de imagem
        echo "$qr_code_base64" | base64 --decode > qrcode.jpg
        echo "QR Code salvo como qrcode.jpg"

        # Limpa a tela após o sucesso
        clear

        # Exibe a mensagem alegre com o ID do pagamento e emojis
        echo -e "✅ Pagamento gerado com sucesso! 🎉"
        echo -e "🆔 ID do Pagamento: $payment_id\n"
        echo -e "💰 Valor da cobrança: R$${valor}\n"
        echo "🖼️ Você pode escanear o QRCODE da imagem 'qrcode.jpg' para realizar o pagamento!"
        echo -e "📲 Ou pague com o código do 'PIX Copia e Cola' abaixo:\n"
        echo "👇️👇️"
        echo "$pix_copia_e_cola"
        echo -e "\n🕒 OBS: Código válido por apenas 30 minutos."
        echo -e "⚡️ Clique no código para copiar e pagar rápido!"
    else
        echo "Erro: Não foi possível encontrar o QR Code base64 no response."
    fi
}

pagamento "$1"
