# Quick Queries - PUIUX Client Registry

**شرح سريع لاستعلامات شائعة على `clients.json` باستخدام `jq`.**

---

## 📊 Overview Queries

### **List all clients (slug + status):**
```bash
jq '.clients[] | {slug, status}' clients.json
```

### **Count total clients:**
```bash
jq '.clients | length' clients.json
```

### **Count by status:**
```bash
jq '.clients | group_by(.status) | map({status: .[0].status, count: length})' clients.json
```

### **Count by tier:**
```bash
jq '.clients | group_by(.tier) | map({tier: .[0].tier, count: length})' clients.json
```

---

## 🔍 Search Queries

### **Find client by slug:**
```bash
jq '.clients[] | select(.slug == "demo-acme")' clients.json
```

### **Find clients by status:**
```bash
# Presales clients
jq '.clients[] | select(.status == "presales")' clients.json

# Active projects
jq '.clients[] | select(.status == "active")' clients.json
```

### **Find clients by tier:**
```bash
jq '.clients[] | select(.tier == "premium")' clients.json
```

### **Find clients by pod:**
```bash
jq '.clients[] | select(.pod == "ecommerce")' clients.json
```

---

## 🔒 Gates Queries

### **Clients with payment NOT verified:**
```bash
jq '.clients[] | select(.gates.payment_verified == false) | {slug, status}' clients.json
```

### **Clients with DNS NOT verified:**
```bash
jq '.clients[] | select(.gates.dns_verified == false) | {slug, status}' clients.json
```

### **Clients ready for production (all gates passed):**
```bash
jq '.clients[] | select(.gates.payment_verified == true and .gates.dns_verified == true) | {slug, production: .domains.production}' clients.json
```

### **Clients BLOCKED from production:**
```bash
jq '.clients[] | select(.gates.payment_verified == false or .gates.dns_verified == false) | {slug, payment: .gates.payment_verified, dns: .gates.dns_verified}' clients.json
```

---

## 💰 Billing Queries

### **Clients with outstanding balance:**
```bash
jq '.clients[] | select(.billing.outstanding > 0) | {slug, outstanding: .billing.outstanding}' clients.json
```

### **Total revenue (all paid amounts):**
```bash
jq '[.clients[].billing.paid] | add' clients.json
```

### **Total outstanding:**
```bash
jq '[.clients[].billing.outstanding] | add' clients.json
```

---

## 🌐 Domain Queries

### **List all production domains:**
```bash
jq '.clients[] | {slug, production: .domains.production}' clients.json
```

### **List all staging domains:**
```bash
jq '.clients[] | {slug, staging: .domains.staging}' clients.json
```

---

## ✏️ Update Queries

### **Set payment_verified to true:**
```bash
jq '(.clients[] | select(.slug == "demo-acme") | .gates.payment_verified) = true' clients.json > temp.json && mv temp.json clients.json
```

### **Set dns_verified to true:**
```bash
jq '(.clients[] | select(.slug == "demo-acme") | .gates.dns_verified) = true' clients.json > temp.json && mv temp.json clients.json
```

### **Update client status:**
```bash
jq '(.clients[] | select(.slug == "demo-acme") | .status) = "active"' clients.json > temp.json && mv temp.json clients.json
```

### **Update last_updated date:**
```bash
jq '(.clients[] | select(.slug == "demo-acme") | .updated) = "2026-02-07"' clients.json > temp.json && mv temp.json clients.json
```

### **Add invoice:**
```bash
jq '(.clients[] | select(.slug == "demo-acme") | .billing.invoices) += [{"number": "INV-001", "amount": 20000, "status": "paid", "date": "2026-02-07"}]' clients.json > temp.json && mv temp.json clients.json
```

---

## 📋 Reporting Queries

### **Active projects summary:**
```bash
jq '.clients[] | select(.status == "active") | {slug, pod, stack, payment: .gates.payment_verified}' clients.json
```

### **Presales pipeline:**
```bash
jq '.clients[] | select(.status == "presales") | {slug, presales_stage, payment: .gates.payment_verified}' clients.json
```

### **Delivered projects:**
```bash
jq '.clients[] | select(.status == "delivered") | {slug, delivered: .updated}' clients.json
```

---

## 🎯 Combined Queries

### **Clients needing attention (presales without payment):**
```bash
jq '.clients[] | select(.status == "presales" and .presales_stage >= "PS3" and .gates.payment_verified == false) | {slug, stage: .presales_stage}' clients.json
```

### **Ready to deploy but DNS missing:**
```bash
jq '.clients[] | select(.gates.payment_verified == true and .gates.dns_verified == false) | {slug, production: .domains.production}' clients.json
```

---

## 🔧 Validation Queries

### **Check for duplicate slugs:**
```bash
jq -r '.clients[].slug' clients.json | sort | uniq -d
```

### **Check for missing required fields:**
```bash
jq '.clients[] | select(.slug == null or .name == null or .status == null) | .id' clients.json
```

---

## 💡 Tips

### **Pretty print specific client:**
```bash
jq '.clients[] | select(.slug == "demo-acme")' clients.json
```

### **Export to CSV (basic):**
```bash
jq -r '.clients[] | [.slug, .status, .gates.payment_verified, .gates.dns_verified] | @csv' clients.json
```

### **Count clients per pod:**
```bash
jq '[.clients | group_by(.pod)[] | {pod: .[0].pod, count: length}]' clients.json
```

---

## ⚠️ Safety Tips

1. **Always backup before bulk updates:**
   ```bash
   cp clients.json clients.json.backup
   ```

2. **Validate after updates:**
   ```bash
   ./validate.sh
   ```

3. **Use temp file for updates:**
   ```bash
   jq '...' clients.json > temp.json && mv temp.json clients.json
   ```

---

_استخدم هذه الاستعلامات لإدارة وتتبع العملاء بكفاءة._
