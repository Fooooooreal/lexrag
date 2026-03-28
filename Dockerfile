FROM ghcr.io/cinnamon/kotaemon:main-lite

WORKDIR /app

# Copy our customized files over the base image
COPY flowsettings.py /app/flowsettings.py
COPY app.py /app/app.py
COPY .env.example /app/.env
COPY assets/ /app/assets/
COPY README.md /app/README.md

# Overwrite modified source files
COPY libs/ktem/ktem/reasoning/simple.py /app/libs/ktem/ktem/reasoning/simple.py

# Railway compatibility
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=7860
EXPOSE 7860

CMD [".venv/bin/python", "app.py"]
