# PUIUX Client Projects Registry

**المرجع المركزي لجميع مشاريع العملاء.**

---

## 📋 الهدف:

- فهرس موحد لكل العملاء
- تتبع حالة كل مشروع
- معرفة Gates status لكل عميل
- إدارة مركزية من مكان واحد

---

## 📁 الملفات:

### **clients.json**
الفهرس الرئيسي - يحتوي على معلومات جميع العملاء.

**Structure:**
```json
{
  "clients": [
    {
      "id": "client-001",
      "slug": "client-name",
      "name": "Client Full Name",
      "tier": "beta|standard|premium",
      "pod": "corporate|ecommerce|marketplace|saas",
      "stack": "laravel|node|wordpress",
      "repo": "client-{slug}",
      "domains": {
        "beta": "{slug}.puiux.cloud",
        "staging": "staging.{slug}.puiux.cloud",
        "production": "client-domain.com"
      },
      "gates": {
        "payment_verified": false,
        "dns_verified": false,
        "ssl_verified": false
      },
      "status": "presales|active|paused|delivered|archived",
      "created": "YYYY-MM-DD",
      "updated": "YYYY-MM-DD",
      "limits": { ... },
      "billing": { ... }
    }
  ]
}
```

---

## 🔑 Conventions:

### **Client ID:**
- Format: `client-XXX` (3-digit sequential)
- Example: `client-001`, `client-002`

### **Slug:**
- Format: `lowercase-with-dashes`
- Must be unique
- Used in repo names & domains
- Example: `alfa-fashion`, `demo-acme`

### **Tier:**
- `beta` - Free trial / testing
- `standard` - Regular paid client
- `premium` - Enterprise client

### **Pod:**
- `corporate` - Corporate websites
- `ecommerce` - Online stores
- `marketplace` - Multi-vendor platforms
- `saas` - SaaS platforms
- `mobile` - Mobile apps

### **Stack:**
- `laravel` - Laravel framework
- `node` - Node.js/Express
- `wordpress` - WordPress/WooCommerce
- `react` - React/Next.js
- `vue` - Vue/Nuxt

### **Status:**
- `presales` - In sales process (PS0-PS5)
- `active` - Project in development/delivery
- `paused` - Temporarily paused
- `delivered` - Completed & handed over
- `archived` - Closed/historical

---

## 🔒 Gates:

### **payment_verified**
- `false` → Delivery stages LOCKED
- `true` → Delivery stages UNLOCKED

### **dns_verified**
- `false` → Production deploy BLOCKED
- `true` → Production deploy ALLOWED

### **ssl_verified** (optional)
- `false` → SSL not configured
- `true` → SSL configured & active

**Critical Rule:**
> Production deploy requires: `payment_verified=true` AND `dns_verified=true` AND (optionally) `ssl_verified=true`

---

## 📊 Domains Strategy:

### **Beta/Testing (على puiux.cloud):**
```
Beta:    {slug}.puiux.cloud
Staging: staging.{slug}.puiux.cloud
```
- Managed by PUIUX
- Free for beta/testing
- Auto SSL via Let's Encrypt

### **Production (على دومين العميل):**
```
Production: client-domain.com
            www.client-domain.com
```
- Client's own domain
- Client configures DNS → PUIUX server IP
- SSL via Let's Encrypt (automatic)

---

## 🔄 Workflow:

### **Adding New Client:**

1. **Create entry in `clients.json`:**
```json
{
  "id": "client-XXX",
  "slug": "new-client",
  "name": "New Client Name",
  "tier": "beta",
  "pod": "corporate",
  "stack": "laravel",
  "repo": "client-new-client",
  "domains": {
    "beta": "new-client.puiux.cloud",
    "staging": "staging.new-client.puiux.cloud",
    "production": "newclient.com"
  },
  "gates": {
    "payment_verified": false,
    "dns_verified": false,
    "ssl_verified": false
  },
  "status": "presales",
  "created": "2026-02-07",
  "updated": "2026-02-07",
  "limits": {
    "storage_gb": 10,
    "bandwidth_gb": 100,
    "users": 50
  },
  "billing": {
    "plan": "beta-free",
    "invoices": []
  }
}
```

2. **Create client repo from template:**
```bash
# From client-template
cp -r client-template client-new-client
# Update client.json in new repo
```

3. **Configure gates as project progresses:**
```
PS5 completed + payment verified → payment_verified = true
DNS configured by client → dns_verified = true
SSL auto-configured → ssl_verified = true
```

---

## 📈 Tracking:

### **Quick Status Check:**
```bash
# List all clients
jq '.clients[] | {slug, status, payment_verified: .gates.payment_verified}' clients.json

# Count by status
jq '.clients | group_by(.status) | map({status: .[0].status, count: length})' clients.json

# Find blocked clients
jq '.clients[] | select(.gates.payment_verified == false) | {slug, status}' clients.json
```

---

## 🔧 Maintenance:

### **Update client status:**
```bash
# Example: Mark payment as verified
jq '(.clients[] | select(.slug == "demo-acme") | .gates.payment_verified) = true' clients.json
```

### **Archive completed project:**
```bash
jq '(.clients[] | select(.slug == "demo-acme") | .status) = "archived"' clients.json
```

---

## ⚠️ Rules:

1. **Never delete clients** - archive them instead
2. **Slug must be unique** - check before adding
3. **Update `updated` field** on any change
4. **Validate JSON** after every edit
5. **Commit changes** with descriptive messages

---

## 📝 Example Clients:

See `clients.json` for full list of current clients.

Demo clients:
- `client-demo-acme` - Demo/testing project

---

_هذا السجل هو مصدر الحقيقة الواحد لجميع مشاريع PUIUX._
