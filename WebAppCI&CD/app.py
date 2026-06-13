from flask import Flask, request, render_template
from azure.storage.blob import BlobServiceClient
import os

app = Flask(__name__)

blob_connection_string = os.environ['BLOB_CONNECTION_STRING']
container_name = "imageanalysis"

blob_service_client = BlobServiceClient.from_connection_string(blob_connection_string)

@app.route("/", methods=["GET", "POST"])
def upload_file():
    if request.method == "POST":
        file = request.files["file"]
        if file:
            blob_client = blob_service_client.get_blob_client(container=container_name, blob=file.filename)
            blob_client.upload_blob(file.read(), overwrite=True)
            return "✅ File uploaded successfully!"
    return render_template("upload.html")
