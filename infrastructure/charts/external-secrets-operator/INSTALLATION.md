# Set your values
NAMESPACE="vaultwarden-kubernetes-secrets"
SERVER_URL="https://your-vaultwarden-server.com"
BW_CLIENTID="<your_client_id>"
BW_CLIENTSECRET="<your_client_secret>"
MASTER_PASSWORD="<your_master_password>"

# Create credentials secret
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic vaultwarden-kubernetes-secrets -n "$NAMESPACE" \
  --from-literal=BW_CLIENTID="$BW_CLIENTID" \
  --from-literal=BW_CLIENTSECRET="$BW_CLIENTSECRET" \
  --from-literal=VAULTWARDEN__MASTERPASSWORD="$MASTER_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

# Install the sync service
helm upgrade -i vaultwarden-kubernetes-secrets oci://ghcr.io/antoniolago/charts/vaultwarden-kubernetes-secrets \
  --version "$CHART_VERSION" \
  --namespace "$NAMESPACE" --create-namespace \
  --set env.config.VAULTWARDEN__SERVERURL="$SERVER_URL" \
  --set image.tag="$CHART_VERSION"