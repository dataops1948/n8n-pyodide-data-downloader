FROM n8nio/n8n:1.91.1 AS builder

USER root

RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN apk add --update py-pip

RUN npm install pyodide@0.27.5
RUN pip install --break-system-packages pkginfo pyodide_lock

COPY pyodide.requirements.txt pypi.requirements.txt installPyodidePackages.js add_pypi_packages_to_pyodide.py ./

RUN node installPyodidePackages.js
RUN pip download -r pypi.requirements.txt -d /pyodide-pypi-packages
RUN python3 add_pypi_packages_to_pyodide.py
RUN mv /pyodide-pypi-packages/* /home/node/node_modules/pyodide

RUN chmod -R 777 /home/node/node_modules/pyodide /usr/local/lib/node_modules/n8n/node_modules/pyodide
USER node


FROM n8nio/n8n:1.91.1

COPY --from=builder /home/node/node_modules/pyodide /pyodide-data/packages
COPY --from=builder /usr/local/lib/node_modules/n8n/node_modules/pyodide /pyodide-data/n8n
