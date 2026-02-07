#!/bin/bash

# PUIUX Client Registry Validation Script

echo "=== PUIUX Client Registry Validation ==="
echo ""

# Check if clients.json exists
if [ ! -f "clients.json" ]; then
  echo "❌ Error: clients.json not found"
  exit 1
fi

# Validate JSON syntax
echo "1. Validating JSON syntax..."
if ! jq empty clients.json 2>/dev/null; then
  echo "   ❌ Invalid JSON syntax"
  exit 1
fi
echo "   ✅ JSON syntax valid"
echo ""

# Check required top-level fields
echo "2. Checking top-level fields..."
REQUIRED_TOP=("registry_version" "last_updated" "total_clients" "clients")

for field in "${REQUIRED_TOP[@]}"; do
  VALUE=$(jq -r ".$field" clients.json)
  if [ "$VALUE" = "null" ]; then
    echo "   ❌ Missing top-level field: $field"
    exit 1
  fi
done
echo "   ✅ All top-level fields present"
echo ""

# Validate each client
echo "3. Validating client entries..."

CLIENT_COUNT=$(jq '.clients | length' clients.json)
echo "   Total clients: $CLIENT_COUNT"
echo ""

ERRORS=0

for i in $(seq 0 $((CLIENT_COUNT - 1))); do
  SLUG=$(jq -r ".clients[$i].slug" clients.json)
  echo "   Client $((i + 1)): $SLUG"
  
  # Required fields per client
  REQUIRED_FIELDS=(
    "id"
    "slug"
    "name"
    "tier"
    "pod"
    "stack"
    "repo"
    "domains.beta"
    "domains.staging"
    "domains.production"
    "gates.payment_verified"
    "gates.dns_verified"
    "status"
    "created"
  )
  
  for field in "${REQUIRED_FIELDS[@]}"; do
    VALUE=$(jq -r ".clients[$i].$field" clients.json)
    if [ "$VALUE" = "null" ]; then
      echo "      ❌ Missing field: $field"
      ERRORS=$((ERRORS + 1))
    fi
  done
  
  # Validate tier
  TIER=$(jq -r ".clients[$i].tier" clients.json)
  if [[ ! "$TIER" =~ ^(beta|standard|premium)$ ]]; then
    echo "      ❌ Invalid tier: $TIER (must be beta|standard|premium)"
    ERRORS=$((ERRORS + 1))
  fi
  
  # Validate status
  STATUS=$(jq -r ".clients[$i].status" clients.json)
  if [[ ! "$STATUS" =~ ^(presales|active|paused|delivered|archived)$ ]]; then
    echo "      ❌ Invalid status: $STATUS"
    ERRORS=$((ERRORS + 1))
  fi
  
  # Validate gates (boolean)
  PAYMENT_GATE=$(jq -r ".clients[$i].gates.payment_verified" clients.json)
  DNS_GATE=$(jq -r ".clients[$i].gates.dns_verified" clients.json)
  
  if [[ ! "$PAYMENT_GATE" =~ ^(true|false)$ ]]; then
    echo "      ❌ payment_verified must be boolean"
    ERRORS=$((ERRORS + 1))
  fi
  
  if [[ ! "$DNS_GATE" =~ ^(true|false)$ ]]; then
    echo "      ❌ dns_verified must be boolean"
    ERRORS=$((ERRORS + 1))
  fi
  
  echo ""
done

# Check for duplicate slugs
echo "4. Checking for duplicate slugs..."
DUPLICATES=$(jq -r '.clients[].slug' clients.json | sort | uniq -d)

if [ -n "$DUPLICATES" ]; then
  echo "   ❌ Duplicate slugs found:"
  echo "$DUPLICATES"
  ERRORS=$((ERRORS + 1))
else
  echo "   ✅ No duplicate slugs"
fi
echo ""

# Summary
echo "=== Validation Summary ==="
if [ $ERRORS -eq 0 ]; then
  echo "✅ All validations passed"
  echo "   Total clients: $CLIENT_COUNT"
  echo "   Registry is valid and ready to use."
  exit 0
else
  echo "❌ Validation failed with $ERRORS error(s)"
  echo "   Please fix the errors and run validation again."
  exit 1
fi
