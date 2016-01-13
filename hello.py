#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

from flask import Flask, request, Response, g, session, url_for, json, jsonify
from flaskext.mysql import MySQL


app = Flask(__name__)
mysql = MySQL()

app.config['MYSQL_DATABASE_USER'] = 'kbgiskbg'
app.config['MYSQL_DATABASE_PASSWORD'] = 'mysql'
app.config['MYSQL_DATABASE_DB'] = 'emotionDB'
app.secret_key = 'emotionDB_secret_key'

mysql.init_app(app);


def connect_db():
	return mysql.connect()


def query_db(query, one=False):
	cursor = g.db.cursor()
	cursor.execute(query)

	data = []

	if cursor.description:
		columns = tuple ( [desc[0] for desc in cursor.description] )
		print columns

		for row in cursor:
			data.append(dict(zip(columns, row)))
	
	return data


# SELECT userid FROM userInfo // using user_email
def get_user_id(user_email):
	query = "SELECT userid FROM userInfo WHERE email = \'%s\'" % user_email

	data = query_db(query, True)

	if data:
		result = data[0]['userid']
	else:
		result = None

	return result


# INSERT new user_email INTO userInfo
def register_user_id(user_email):
	query = "INSERT INTO userInfo (email) VALUES (\'%s\')" % user_email
	print query
	cursor = g.db.cursor()
	cursor.execute(query)
	g.db.commit()


# before_request IS CALLED BEFORE EVERY REQUEST
@app.before_request
def before_request():
	g.db = connect_db()
	print "before request called."

# teardown request IS CALLED AT EVERY END OF REQUEST
@app.teardown_request
def teardown_request(exception):
	print "teardown request called."
	if hasattr(g, 'db'):
		print "db connection closed."
		g.db.close()


@app.route('/')
def hello_world():
	return 'Hello World!'


@app.route('/login', methods=["POST"])
def login():
	user_email = request.form['email']
	user_check = get_user_id(user_email)

	if not user_check:
		register_user_id(user_email)
		user_id = get_user_id(user_email)

	session['logged_in'] = True
	session['username'] = user_email
	g.user = session['username']

	return user_email + " log in OK."


@app.route('/insertEmotion', methods=["POST"])
def insertData():
	emotion = request.form['emotion']
	loc_id = request.form['location']
	time = int (request.form['time'])

	if (time > 6 and time < 12):
		dayTime = "morning"
	elif (time >= 12 and time < 17):
		dayTime = "afternoon"
	elif (time >= 17 and time < 21):
		dayTime = "evening"
	else:
		dayTime = "night"

	user_email = session['username']
	user_id = get_user_id(user_email)
	print user_email
	print user_id

	query = "SELECT id FROM dayTime WHERE name = \'%s\'" % dayTime
	data = query_db(query, True)
	dayTime_id = data[0]['id']

	query = "INSERT INTO represent (userid, loc_id, emotionNum, dailyTime) VALUES (%s, %s, %s, %s)" % (user_id, loc_id, emotion, dayTime_id)
	query_db(query, True)
	g.db.commit()

	return "emotion insertion ok"


@app.route('/loadData', methods=["GET"])
def loadData():

	user_email = session['username']
	user_id = get_user_id(user_email)

	query = "SELECT lo.latitude, lo.longitude, r.emotionNum, r.dailyTime FROM represent as r JOIN location as lo ON r.loc_id = lo.id WHERE userid = %s" % user_id
	data = query_db(query, False)

	print data

	result = []
	
	for dic in data:
		dictionary = {
						"lat" : float(dic['latitude']),
						"lon" : float(dic['longitude']),
						"emotion" : dic['emotionNum'],
						"dailyTime" : dic['dailyTime']
					}
		result.append(dictionary)

	return jsonify(results = result)	


if __name__ == '__main__':
	app.run(debug=True, port=5001)
