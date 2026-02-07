# PUIUX Client Registry Conventions

**معايير موحدة لإضافة وإدارة العملاء.**

---

## 🆔 Client ID

### **Format:**
```
client-XXX
```

### **Rules:**
- Sequential 3-digit number
- Zero-padded (001, 002, ..., 099, 100)
- Never reuse IDs
- Demo clients: `client-demo-XXX`

### **Examples:**
```
client-001  → First real client
client-002  → Second client
client-099  → 99th client
client-100  → 100th client
client-demo-001  → Demo/testing client
```

---

## 🏷️ Slug

### **Format:**
```
lowercase-with-dashes
```

### **Rules:**
- Only lowercase letters (a-z)
- Numbers allowed (0-9)
- Dashes for separation (-)
- No spaces, underscores, or special characters
- Must be unique across all clients
- Short & memorable (prefer 2-3 words max)

### **Good Examples:**
```
✅ alfa-fashion
✅ tech-startup
✅ coffee-shop-123
✅ demo-acme
```

### **Bad Examples:**
```
❌ Alfa_Fashion  (uppercase & underscore)
❌ tech startup  (space)
❌ coffee&shop   (special char)
❌ very-long-complicated-client-name  (too long)
```

### **Derivations from Slug:**
- **Repo name:** `client-{slug}`
- **Beta domain:** `{slug}.puiux.cloud`
- **Staging domain:** `staging.{slug}.puiux.cloud`

---

## 🏆 Tier

### **Options:**
- `beta` - Free trial / testing period
- `standard` - Regular paid client
- `premium` - Enterprise client with premium support

### **Tier Progression:**
```
beta → standard  (after first payment)
standard → premium  (upgrade)
```

---

## 📦 Pod

### **Options:**
- `corporate` - Corporate/business websites
- `ecommerce` - E-commerce stores (single vendor)
- `marketplace` - Multi-vendor platforms
- `saas` - SaaS applications
- `mobile` - Mobile applications
- `custom` - Custom/other projects

### **Selection:**
Based on project primary function, not technology.

---

## 🛠️ Stack

### **Options:**
- `laravel` - Laravel (PHP)
- `node` - Node.js/Express
- `wordpress` - WordPress/WooCommerce
- `react` - React/Next.js
- `vue` - Vue/Nuxt
- `custom` - Custom/mixed stack

### **Selection:**
Primary backend technology.

---

## 🌐 Domains

### **Structure:**
```json
"domains": {
  "beta": "{slug}.puiux.cloud",
  "staging": "staging.{slug}.puiux.cloud",
  "production": "client-actual-domain.com"
}
```

### **Beta Domain:**
- Format: `{slug}.puiux.cloud`
- Managed by PUIUX
- Free SSL
- For demos & testing

### **Staging Domain:**
- Format: `staging.{slug}.puiux.cloud`
- Managed by PUIUX
- Free SSL
- For pre-production testing

### **Production Domain:**
- Format: Client's actual domain
- Examples: `example.com`, `www.example.com`
- Client manages DNS
- PUIUX provides server IP
- SSL via Let's Encrypt (automatic)

---

## 🔒 Gates

### **Structure:**
```json
"gates": {
  "payment_verified": false,
  "dns_verified": false,
  "ssl_verified": false
}
```

### **payment_verified:**
- `false` → Delivery stages LOCKED
- `true` → Delivery stages UNLOCKED
- **When to set true:** After PS5 (invoice paid & verified)

### **dns_verified:**
- `false` → Production deploy BLOCKED
- `true` → Production deploy ALLOWED
- **When to set true:** After client configures DNS + verification passed

### **ssl_verified:**
- `false` → SSL not configured
- `true` → SSL active & valid
- **When to set true:** After Let's Encrypt auto-config succeeds

### **Critical Rules:**
1. **Never manually set gates without verification**
2. **Production deploy requires both payment AND dns = true**
3. **Document gate changes in commits**

---

## 📊 Status

### **Options:**

**presales:**
- Client in sales process (PS0-PS5)
- No development started
- Gates should be false

**active:**
- Project in development/delivery
- payment_verified = true
- Stages 0-5 in progress

**paused:**
- Temporarily paused (client request, payment issue, etc.)
- Work stopped but not completed

**delivered:**
- Project completed & handed over
- All stages done
- Client live

**archived:**
- Historical/closed project
- No longer active
- Kept for records only

### **Transitions:**
```
presales → active  (payment verified)
active → paused  (temporary stop)
paused → active  (resume)
active → delivered  (completion)
delivered → archived  (after retention period)
```

---

## 📅 Dates

### **Format:**
```
YYYY-MM-DD
```

### **Fields:**
- **created:** Initial client entry date (never changes)
- **updated:** Last modification date (update on every change)

### **Update Rule:**
> Every time you edit a client entry, update the `updated` field to current date.

---

## 💰 Billing

### **Structure:**
```json
"billing": {
  "plan": "beta-free|standard|premium",
  "total_value": 50000,
  "paid": 20000,
  "outstanding": 30000,
  "invoices": [
    {
      "number": "INV-001",
      "amount": 20000,
      "status": "paid|pending|overdue",
      "date": "2026-02-07"
    }
  ]
}
```

### **Plan:**
- `beta-free` - Free tier
- `standard` - Standard pricing
- `premium` - Custom/premium pricing

### **Amounts:**
- Currency: SAR (Saudi Riyal) by default
- Format: Integer (no decimals for SAR)

---

## 📞 Contacts

### **Structure:**
```json
"contacts": {
  "primary": {
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+966-XX-XXX-XXXX"
  },
  "technical": {
    "name": "Jane Smith",
    "email": "jane@example.com",
    "phone": "+966-XX-XXX-XXXX"
  }
}
```

### **Types:**
- **primary:** Main decision maker / owner
- **technical:** Technical contact (optional)
- **billing:** Billing contact (optional)

---

## 🔍 Validation

### **Required Fields:**
Every client entry MUST have:
- id, slug, name
- tier, pod, stack
- repo
- domains (beta, staging, production)
- gates (payment_verified, dns_verified)
- status
- created

### **Run Validation:**
```bash
./validate.sh
```

Must pass before committing.

---

## 📝 Commit Messages

### **Format:**
```
[action] Client: [slug] - [description]

Examples:
[add] Client: alfa-fashion - New client entry
[update] Client: demo-acme - Payment verified
[update] Client: tech-startup - DNS configured
[archive] Client: old-client - Project completed
```

---

## ⚠️ Do's and Don'ts

### **Do:**
✅ Validate before committing  
✅ Use consistent naming  
✅ Update `updated` field  
✅ Document gate changes  
✅ Keep slugs short & clear  

### **Don't:**
❌ Delete client entries (archive instead)  
❌ Reuse slugs or IDs  
❌ Set gates without verification  
❌ Use spaces in slugs  
❌ Commit invalid JSON  

---

_هذه المعايير تضمن تنظيم موحد ومحترف لجميع مشاريع PUIUX._
