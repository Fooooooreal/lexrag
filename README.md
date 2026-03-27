# LexRAG -- AI Legal Document Assistant

RAG-powered system for searching and answering questions about legislative documents. Upload laws, regulations, or legal documents and ask questions in natural language -- get precise answers with exact article citations.

## Features

- **Document Q&A** -- Ask questions about uploaded legal documents in natural language
- **Citation Highlighting** -- Answers include exact references to articles, clauses, and paragraphs with in-PDF highlighting
- **Multi-document Search** -- Query across multiple legal documents simultaneously
- **Hybrid Search** -- Combines semantic (vector) and keyword (BM25) search for precise legal term matching
- **Multilingual** -- Supports Russian and English legal documents

## Tech Stack

| Component | Technology |
|---|---|
| RAG Framework | [Kotaemon](https://github.com/Cinnamon/kotaemon) (customized fork) |
| LLM | DeepSeek V3 via OpenAI-compatible API |
| Embeddings | FastEmbed with BAAI/bge-m3 (multilingual, 100+ languages) |
| Vector Store | ChromaDB (embedded) |
| Document Store | LanceDB |
| UI | Gradio |
| Deployment | Docker + Railway |

## Architecture

```
User uploads PDF/DOCX --> Document parsing --> Chunking --> Embeddings (bge-m3)
                                                                  |
                                                                  v
User asks question --> Query embedding --> Hybrid search (vector + BM25)
                                                                  |
                                                                  v
                                    Retrieved chunks + question --> DeepSeek API
                                                                  |
                                                                  v
                                    Answer with citations <-- LLM response
```

## Quick Start

### Prerequisites

- Python 3.10+
- DeepSeek API key ([get one here](https://platform.deepseek.com/))

### Local Setup

```bash
git clone https://github.com/<YOUR_USERNAME>/lexrag.git
cd lexrag

# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -e "libs/kotaemon[all]"
pip install -e "libs/ktem"

# Configure API keys
cp .env.example .env
# Edit .env and set OPENAI_API_KEY to your DeepSeek API key

# Launch
python app.py
# Open http://localhost:7860
# Default login: admin / admin
```

### Docker

```bash
docker build -t lexrag:latest --target lite .

docker run -p 7860:7860 \
  -e OPENAI_API_BASE=https://api.deepseek.com/v1 \
  -e OPENAI_API_KEY=your_deepseek_key \
  -e OPENAI_CHAT_MODEL=deepseek-chat \
  -v lexrag_data:/app/ktem_app_data \
  lexrag:latest
```

### Railway Deployment

1. Fork this repository
2. Create a new Railway project from the GitHub repo
3. Add environment variables in Railway dashboard:
   - `OPENAI_API_BASE=https://api.deepseek.com/v1`
   - `OPENAI_API_KEY=your_deepseek_key`
   - `OPENAI_CHAT_MODEL=deepseek-chat`
4. Add a volume mounted to `/app/ktem_app_data`
5. Deploy

## Demo Questions

Try these after uploading legal documents:

- "What consumer rights apply when returning goods?"
- "What is the statute of limitations for labor disputes?"
- "What are the grounds for termination of an employment contract?"
- "What does the law say about personal data protection?"

## Customization

### System Prompt

The legal assistant prompt is pre-configured in the reasoning pipeline. You can modify it through the UI settings or by editing `libs/ktem/ktem/reasoning/simple.py`.

### Theme

Custom CSS is in `assets/custom.css`. The theme uses a professional legal color palette (navy blue + gold accents).

### Embedding Model

Default: `BAAI/bge-m3` (multilingual, supports 100+ languages including Russian). Configurable in `flowsettings.py` under `KH_EMBEDDINGS`.

## License

Apache-2.0 (inherited from [Kotaemon](https://github.com/Cinnamon/kotaemon))
