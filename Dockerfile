FROM denoland/deno:1.30.3

# The port that your application listens to.
EXPOSE 8000

WORKDIR /app

USER root

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
COPY import_map.json .
RUN deno cache import_map.json

# These steps will be re-run upon each file change in your working directory:
COPY . .

# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache main.ts

CMD ["deno", "run", "--allow-run", "--allow-read", "--allow-env", "--allow-net", "--import-map=import_map.json", "main.ts"]
