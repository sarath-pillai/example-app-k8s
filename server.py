from flask import Flask, jsonify, request, abort
app = Flask(__name__)

TreeName = "Big Banyan tree"

@app.route('/tree')
def tree():
    return jsonify({
        'myFavouriteTree': TreeName
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
