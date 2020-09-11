import os
from flask import Flask, request, jsonify

app = Flask(__name__)

project_id = 'everis1'

# Index
@app.route('/')
def index():
  return 'Index Page'

# Return greetings
@app.route("/greetings", methods=["GET"])
def greetings():
    data = "hello world from "
    file1 = open("hostname.txt","r+")
    hostname = file1.read()
    file1.close()  
    return jsonify({'message': data+hostname}) 

# Return square
@app.route("/square/<int:number>", methods=["GET"])
def square(number):
    return jsonify({'message': number**2})

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0',
            port=int(os.environ.get(
                     'PORT', 8080)))