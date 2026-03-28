import os

from theflow.settings import settings as flowsettings

KH_APP_DATA_DIR = getattr(flowsettings, "KH_APP_DATA_DIR", ".")
KH_GRADIO_SHARE = getattr(flowsettings, "KH_GRADIO_SHARE", False)
GRADIO_TEMP_DIR = os.getenv("GRADIO_TEMP_DIR", None)
if GRADIO_TEMP_DIR is None:
    GRADIO_TEMP_DIR = os.path.join(KH_APP_DATA_DIR, "gradio_tmp")
    os.environ["GRADIO_TEMP_DIR"] = GRADIO_TEMP_DIR

# Load custom LexRAG CSS
_CUSTOM_CSS_PATH = os.path.join(os.path.dirname(__file__), "assets", "custom.css")
_CUSTOM_CSS = ""
if os.path.exists(_CUSTOM_CSS_PATH):
    with open(_CUSTOM_CSS_PATH, "r") as f:
        _CUSTOM_CSS = f.read()


from ktem.main import App  # noqa

app = App()

# Safely append custom CSS
if _CUSTOM_CSS and hasattr(app, "_css"):
    app._css = (app._css or "") + "\n" + _CUSTOM_CSS

demo = app.make()
port = int(os.environ.get("PORT", os.environ.get("GRADIO_SERVER_PORT", 7860)))
demo.queue().launch(
    favicon_path=getattr(app, "_favicon", None),
    allowed_paths=[
        "libs/ktem/ktem/assets",
        GRADIO_TEMP_DIR,
    ],
    share=KH_GRADIO_SHARE,
    server_name="0.0.0.0",
    server_port=port,
)
