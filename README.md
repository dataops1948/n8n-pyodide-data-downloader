## Adding Packages

- If the package is part of the **built-in packages of Pyodide** ([link to list](https://pyodide.org/en/stable/usage/packages-in-pyodide.html)), then add it to the `pyodide.requirements.txt` file.

- If the package exists only in **PyPI**, then add it to the `pypi.requirements.txt`. Keep in mind that only pure Python wheels can be added (wheel files that ends with `-none-any.whl`).

## Create the Pyodide Data Tar File

To create a Pyodide data tar file (change the n8n image's version as needed):

```bash
# build the image
docker build . --progress plain -t n8nio/n8n:1.91.1-python-packages-1

# run the image locally
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n n8nio/n8n:1.91.1-python-packages-1

# export the pyodide-data tar file
docker run --rm -v %cd%/pyodide-data:/tmp/pyodide-data --entrypoint sh n8nio/n8n:1.91.1-python-packages-1 -c "tar -C /pyodide-data -cvf /tmp/pyodide-data/pyodide-data-$(date +%s).tar /pyodide-data/*"
```

There is no need to use the built image after, just copy the data from the tar file to the correct folders in n8n - the n8n's `node_modules/pyodide` folder (the `n8n` folder in the tar file) and the n8n's `n8n-nodes-base.code` folder (the `packages` folder in the tar file).

## Notes

- In the `Dockerfile`, the version of the Pyodide npm package should match its version in the n8n's docker image. To find the version, you can import in an n8n's code block a Pyodide-supported package that isn't included in the `pyodide.requirements.txt` file, and look at the n8n's log. It will print something like: `Didn't find package simplejson-3.19.2-cp312-cp312-pyodide_2024_0_wasm32.whl locally, attempting to load from https://cdn.jsdelivr.net/pyodide/v0.27.5/full/` - in this case, the version is `0.27.5`.
