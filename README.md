# ERPNext v15 + HRMS + Healthcare — Docker Setup

هذا المشروع يحتوي على الإعداد الكامل لتشغيل **ERPNext v15** مع وحدات **HRMS** و**Healthcare (Marley)** باستخدام Docker.

> تم اختبار هذا الإعداد بنجاح على Ubuntu 24.04.3 LTS.

---

## التطبيقات المثبتة

| التطبيق | الفرع | المصدر |
|---------|-------|--------|
| Frappe Framework | version-15 | frappe/frappe |
| ERPNext | version-15 | frappe/erpnext |
| Payments | version-15 | frappe/payments |
| HRMS | version-15 | frappe/hrms |
| Healthcare (Marley) | version-15 | earthians/marley |

---

## المتطلبات

- Docker Engine 24+
- Docker Compose v2+
- ذاكرة RAM: 4GB على الأقل (يُفضل 8GB)
- مساحة قرص: 10GB على الأقل

---

## خطوات التشغيل

### الخطوة 1 — استنساخ المشروع

```bash
git clone https://github.com/tamerrabee2/frappe-erpnext-v15-docker.git
cd frappe-erpnext-v15-docker
```

### الخطوة 2 — ضبط كلمات المرور

```bash
cp .env .env.local
nano .env.local   # غيّر كلمات المرور
```

### الخطوة 3 — بناء الصورة المخصصة

```bash
bash scripts/build-image.sh
```

> ⏱️ هذه الخطوة تستغرق 15–30 دقيقة حسب سرعة الإنترنت.

### الخطوة 4 — تشغيل الـ Stack

```bash
bash scripts/start.sh
```

### الخطوة 5 — إنشاء الموقع وتثبيت التطبيقات

```bash
bash scripts/new-site.sh site1.local
```

### الخطوة 6 — فتح النظام

```
http://localhost:8080
Username: Administrator
Password: (التي حددتها في .env.local)
```

---

## هيكل المشروع

```
frappe-erpnext-v15-docker/
├── apps.json              # قائمة التطبيقات
├── Containerfile          # ملف بناء الصورة المخصصة
├── docker-compose.yml     # إعداد الـ stack
├── .env                   # متغيرات البيئة (template)
├── .gitignore
├── config/
│   ├── mariadb.cnf        # إعداد MariaDB (utf8mb4)
│   └── nginx.conf         # إعداد Nginx
└── scripts/
    ├── build-image.sh     # بناء الصورة
    ├── start.sh           # تشغيل الـ stack
    ├── new-site.sh        # إنشاء موقع جديد
    ├── backup.sh          # أخذ نسخة احتياطية
    └── restore.sh         # استرجاع نسخة احتياطية
```

---

## الأوامر اليومية المفيدة

```bash
# إيقاف النظام
docker compose down

# إعادة التشغيل
docker compose restart

# تتبع الـ logs
docker compose logs -f backend

# الدخول إلى الـ container
docker exec -it frappe_backend bash

# أخذ نسخة احتياطية
bash scripts/backup.sh site1.local

# استرجاع نسخة احتياطية
bash scripts/restore.sh site1.local ./backup.sql.gz
```

---

## ملاحظات مهمة

- **لا ترفع `.env.local` أبدًا على GitHub**
- ملف `apps.json` هو المصدر الوحيد لتحديد التطبيقات المثبتة
- عند تغيير التطبيقات، أعد تنفيذ `build-image.sh` من البداية
- الإعداد الحالي مناسب للتطوير وأيضًا للإنتاج بعد إضافة SSL

---

## المراجع

- [frappe/frappe_docker](https://github.com/frappe/frappe_docker)
- [frappe/erpnext](https://github.com/frappe/erpnext)
- [frappe/hrms](https://github.com/frappe/hrms)
- [earthians/marley](https://github.com/earthians/marley)
