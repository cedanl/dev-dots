base:
	mkdir -p .devcontainer/base
	cp .devcontainer/post-create.sh .devcontainer/base/post-create.sh
	devcontainer up --workspace-folder . --config .devcontainer/base/devcontainer.json --id-label name=devcontainer-base
	devcontainer exec --workspace-folder . --config .devcontainer/base/devcontainer.json --id-label name=devcontainer-base bash

python-uv:
	mkdir -p .devcontainer/python-uv
	cp .devcontainer/post-create.sh .devcontainer/python-uv/post-create.sh
	devcontainer up --workspace-folder . --config .devcontainer/python-uv/devcontainer.json --id-label name=devcontainer-python-uv
	devcontainer exec --workspace-folder . --config .devcontainer/python-uv/devcontainer.json --id-label name=devcontainer-python-uv bash

slidev:
	mkdir -p .devcontainer/slidev
	cp .devcontainer/post-create.sh .devcontainer/slidev/post-create.sh
	devcontainer up --workspace-folder . --config .devcontainer/slidev/devcontainer.json --id-label name=devcontainer-slidev
	devcontainer exec --workspace-folder . --config .devcontainer/slidev/devcontainer.json --id-label name=devcontainer-slidev bash
