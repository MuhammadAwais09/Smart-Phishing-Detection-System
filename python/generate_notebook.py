import json
import re

def markdown_to_ipynb(md_path, ipynb_path):
    """Converts a Markdown file with code blocks into a Jupyter Notebook JSON structure."""
    
    with open(md_path, 'r') as f:
        content = f.read()

    # Regex to split content into code blocks and markdown sections
    # It captures the code block content and the surrounding markdown
    parts = re.split(r'(```python\n.*?```)', content, flags=re.DOTALL)
    
    cells = []
    
    for part in parts:
        if not part.strip():
            continue
            
        if part.startswith('```python'):
            # Code cell
            source = part.strip().strip('```python').strip('```').strip()
            cells.append({
                "cell_type": "code",
                "execution_count": None,
                "metadata": {},
                "outputs": [],
                "source": source.split('\n')
            })
        else:
            # Markdown cell
            cells.append({
                "cell_type": "markdown",
                "metadata": {},
                "source": part.strip().split('\n')
            })

    # Notebook structure
    notebook = {
        "cells": cells,
        "metadata": {
            "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3"
            },
            "language_info": {
                "codemirror_mode": {"name": "ipython", "version": 3},
                "file_extension": ".py",
                "mimetype": "text/x-python",
                "name": "python",
                "nbconvert_exporter": "python",
                "pygments_lexer": "ipython3",
                "version": "3.11.0"
            }
        },
        "nbformat": 4,
        "nbformat_minor": 5
    }

    with open(ipynb_path, 'w') as f:
        json.dump(notebook, f, indent=4)

if __name__ == "__main__":
    markdown_to_ipynb('/home/ubuntu/chatbot_notebook.md', '/home/ubuntu/chatbot.ipynb')
    print("Successfully generated /home/ubuntu/chatbot.ipynb")
