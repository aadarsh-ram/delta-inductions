from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route('/')
def home():
    files = os.listdir("files")
    summary_files = [file for file in files if file.startswith('summary')]
    return render_template("home.html", files=summary_files)

@app.route('/<file>')
def showSummary(file):
    path="./files/" + file

    # Some debug issue related to favicon.ico
    # The condition can be removed if favicon.ico exists for website
    if file == "favicon.ico":
        content = ""
    else:
        with open(path, 'r') as f:
            content = f.read()
    return render_template("summary.html", file=file, content=content)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='1000', debug=True)