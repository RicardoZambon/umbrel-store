#!/bin/bash
set -e

# Run this script inside the code-server terminal after cloning your repos.
# It installs npm dependencies and configures dotnet user-secrets.

WORKSPACE="/home/coder/workspace"
FRONTEND="$WORKSPACE/Frontend"
BACKEND="$WORKSPACE/Backend"

# Database connection (via tunnel on localhost:3306)
DB_CONNECTION_STRING="server=localhost;database=niten;user=niten;password=niten;Convert Zero Datetime=True;Connection Timeout=120"

# JWT Keys
JWT_KEY_PORTAL="2HERTFd+fgU*Lc3jW#5Bw7hp\$hAF8+Fgc8QqCzPoT"
JWT_KEY_SYSTEM="2HERTFd+fgU*Lc3jW#5Bw7hp\$hAF9+Fgc8QqCzPoT"

# PagSeguro
PAGSEGURO_NOTIFICATION_URL="https://niten.org.br/_out/pagseguro/pagseguro_v2_retorno_nitiren.php"
PAGSEGURO_REQUEST_URI="https://api.pagseguro.com/checkouts"
PAGSEGURO_TOKEN_NITEN=""
PAGSEGURO_TOKEN_NITIREN=""

# SafraPay
SAFRAPAY_GATEWAY_URI="https://payment.safrapay.com.br"
SAFRAPAY_PORTAL_URI="https://portal.safrapay.com.br"
SAFRAPAY_NITIREN_MERCHANT_ID=""
SAFRAPAY_NITIREN_MERCHANT_TOKEN=""

# FTP / NFSe
FTP_ROOT_FOLDER="/ftp/arquivos"
NFSE_URL="https://api.focusnfe.com.br"
NFSE_TOKEN=""
NFSE_FTP_PATH="nfse/xml"

echo "==> Installing Frontend npm dependencies..."
cd "$FRONTEND"
npm install

echo "==> Setting up Backend user-secrets..."

# Matriculas.WebApi
MATRICULAS_PROJECT="$BACKEND/Matriculas/Matriculas.WebApi/Matriculas.WebApi.csproj"
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "$DB_CONNECTION_STRING" --project "$MATRICULAS_PROJECT"

# Portal.WebApi
PORTAL_PROJECT="$BACKEND/Portal/Portal.WebApi/Portal.WebApi.csproj"
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "$DB_CONNECTION_STRING" --project "$PORTAL_PROJECT"
dotnet user-secrets set "JWT:Key" "$JWT_KEY_PORTAL" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:PagSeguro:NotificationUrl" "$PAGSEGURO_NOTIFICATION_URL" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:PagSeguro:RequestUri" "$PAGSEGURO_REQUEST_URI" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:PagSeguro:Tokens:Niten" "$PAGSEGURO_TOKEN_NITEN" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:PagSeguro:Tokens:Nitiren" "$PAGSEGURO_TOKEN_NITIREN" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:SafraPay:GatewayUri" "$SAFRAPAY_GATEWAY_URI" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:SafraPay:PortalUri" "$SAFRAPAY_PORTAL_URI" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:SafraPay:Nitiren:MerchantId" "$SAFRAPAY_NITIREN_MERCHANT_ID" --project "$PORTAL_PROJECT"
dotnet user-secrets set "Integracoes:SafraPay:Nitiren:MerchantToken" "$SAFRAPAY_NITIREN_MERCHANT_TOKEN" --project "$PORTAL_PROJECT"

# System.WebApi
SYSTEM_PROJECT="$BACKEND/System/System.WebApi/System.WebApi.csproj"
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "$DB_CONNECTION_STRING" --project "$SYSTEM_PROJECT"
dotnet user-secrets set "JWT:Key" "$JWT_KEY_SYSTEM" --project "$SYSTEM_PROJECT"
dotnet user-secrets set "FTP:RootFolder" "$FTP_ROOT_FOLDER" --project "$SYSTEM_PROJECT"
dotnet user-secrets set "NFSe:URL" "$NFSE_URL" --project "$SYSTEM_PROJECT"
dotnet user-secrets set "NFSe:Token" "$NFSE_TOKEN" --project "$SYSTEM_PROJECT"
dotnet user-secrets set "NFSe:FTPPath" "$NFSE_FTP_PATH" --project "$SYSTEM_PROJECT"

# System.TaskScheduler
TASK_PROJECT="$BACKEND/Tasks/System.TaskScheduler/System.TaskScheduler.csproj"
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "$DB_CONNECTION_STRING" --project "$TASK_PROJECT"

echo "==> All user-secrets configured successfully!"
