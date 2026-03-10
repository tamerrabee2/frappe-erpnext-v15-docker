# ============================================================
# Custom Frappe Image: ERPNext v15 + HRMS + Healthcare (Marley)
# ============================================================
# Build command:
#   export APPS_JSON_BASE64=$(base64 -w 0 apps.json)
#   docker build \
#     --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
#     --build-arg=FRAPPE_BRANCH=version-15 \
#     --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
#     --tag=frappe-erpnext-custom:v15 \
#     --file=Containerfile .
# ============================================================

FROM ghcr.io/frappe/base:version-15 AS builder

ARG FRAPPE_PATH=https://github.com/frappe/frappe
ARG FRAPPE_BRANCH=version-15
ARG APPS_JSON_BASE64

RUN install_packages git

WORKDIR /home/frappe

# Write apps.json from build arg
RUN echo ${APPS_JSON_BASE64} | base64 -d > /opt/apps.json

# Initialize bench without starting it
RUN bench init \
    --frappe-branch=${FRAPPE_BRANCH} \
    --frappe-path=${FRAPPE_PATH} \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --verbose \
    frappe-bench

WORKDIR /home/frappe/frappe-bench

# Get all apps from apps.json
RUN export APP_INSTALL_LIST=$(python3 -c \
    "import json; data=json.load(open('/opt/apps.json')); print(' '.join([d.get('app',d['url'].split('/')[-1].replace('.git','')) for d in data]))") && \
    for app in $APP_INSTALL_LIST; do \
        bench get-app --branch version-15 \
            $(python3 -c "import json; data=json.load(open('/opt/apps.json')); [print(d['url']) for d in data if d['url'].split('/')[-1].replace('.git','')=='$app']"); \
    done

# Build assets
RUN bench build --app frappe

# -------------------------------------------------------
FROM ghcr.io/frappe/frappe:version-15

COPY --from=builder /home/frappe/frappe-bench /home/frappe/frappe-bench
