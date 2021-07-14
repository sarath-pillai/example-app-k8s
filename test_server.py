from server import app

def test_tree():
    response = app.test_client().get('/tree')
    assert response.status_code == 200
    assert b'Big Banyan tree' in response.data

def test_home():
    response = app.test_client().get('/')
    assert response.status_code == 404

