from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)


def get_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="12345678",
        database="bus_booking"
    )


# ---------------- LOGIN ---------------- #

@app.route("/login", methods=["POST"])
def login():

    data = request.get_json()

    username = data.get("username")
    password = data.get("password")

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM login WHERE username=%s AND password=%s",
        (username, password)
    )

    user = cursor.fetchone()

    cursor.close()
    conn.close()

    if user:
        return jsonify({"success": True})

    return jsonify({"success": False})


# ---------------- GET ALL BOOKED SEATS ---------------- #

@app.route("/seats", methods=["GET"])
def get_seats():

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM seat_booking")

    seats = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(seats)


# ---------------- BOOK SEAT ---------------- #

@app.route("/bookSeat", methods=["POST"])
def book_seat():

    data = request.get_json()

    seat_no = data["seat_no"]
    passenger_name = data["passenger_name"]
    phone = data["phone"]

    conn = get_db()
    cursor = conn.cursor()

    # Check if seat already booked
    cursor.execute(
        "SELECT * FROM seat_booking WHERE seat_no=%s",
        (seat_no,)
    )

    seat = cursor.fetchone()

    if seat:

        cursor.close()
        conn.close()

        return jsonify({
            "success": False,
            "message": "Seat already booked"
        })

    cursor.execute(
        """
        INSERT INTO seat_booking
        (seat_no, passenger_name, phone, status)

        VALUES(%s,%s,%s,%s)
        """,
        (seat_no, passenger_name, phone, "Booked")
    )

    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({
        "success": True
    })


if __name__ == "__main__":
    app.run(debug=True)
    