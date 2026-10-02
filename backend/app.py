from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

# MySQL Connection
conn = pymysql.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database="parking_system"
)

cursor = conn.cursor()


@app.route("/")
def home():
    return "Parking Allotment Backend Running!"

@app.route("/login", methods=["POST"])
def login():

    data = request.json

    email = data["email"]
    password = data["password"]

    query = """
    SELECT * FROM Users
    WHERE email=%s AND password=%s
    """

    cursor.execute(query, (email, password))

    user = cursor.fetchone()

    if user:

        return {
            "message": "Login successful"
        }

    else:

        return {
            "message": "Invalid email or password"
        }, 401
    
@app.route("/test-login")
def test_login():

    query = """
    SELECT * FROM Users
    WHERE email=%s AND password=%s
    """

    cursor.execute(
        query,
        ("aditi@gmail.com", "123456")
    )

    user = cursor.fetchone()

    if user:
        return "Login Successful!"

    else:
        return "Invalid Email or Password!"
    
@app.route("/add-vehicle", methods=["POST"])
def add_vehicle():

    try:

        data = request.get_json()

        user_id = 1      # Temporary until login session is implemented

        vehicle_number = data["vehicle_number"]
        vehicle_type = data["vehicle_type"]
        fuel_type = data["fuel_type"]

        cursor.execute(
            """
            INSERT INTO Vehicles(
                user_id,
                vehicle_number,
                vehicle_type,
                fuel_type
            )
            VALUES(%s,%s,%s,%s)
            """,
            (
                user_id,
                vehicle_number,
                vehicle_type,
                fuel_type
            )
        )

        conn.commit()

        return jsonify({
            "message": "Vehicle added successfully"
        })

    except Exception as e:

        conn.rollback()

        return jsonify({
            "message": str(e)
        }),500


@app.route("/slots")
def get_slots():

    cursor.execute("""

        SELECT

        id,

        slot_no,

        floor,

        slot_type,

        status

        FROM ParkingSlots

        WHERE status='Available'

    """)

    rows = cursor.fetchall()

    slots = []

    for row in rows:

        slots.append({

            "id": row[0],

            "slot_no": row[1],

            "floor": row[2],

            "slot_type": row[3],

            "status": row[4]

        })

    return jsonify(slots)

@app.route("/delete-vehicle", methods=["POST"])
def delete_vehicle():

    try:

        data = request.get_json()

        vehicle_id = data["vehicle_id"]

        cursor.execute(
            """
            DELETE FROM Vehicles
            WHERE id=%s
            """,
            (vehicle_id,)
        )

        conn.commit()

        return jsonify({
            "message": "Vehicle deleted successfully"
        })

    except Exception as e:

        conn.rollback()

        return jsonify({
            "message": str(e)
        }), 500

@app.route("/update-vehicle", methods=["POST"])
def update_vehicle():

    try:

        data = request.get_json()

        vehicle_id = data["vehicle_id"]
        vehicle_number = data["vehicle_number"]
        vehicle_type = data["vehicle_type"]
        fuel_type = data["fuel_type"]

        cursor.execute(
            """
            UPDATE Vehicles
            SET
                vehicle_number=%s,
                vehicle_type=%s,
                fuel_type=%s
            WHERE id=%s
            """,
            (
                vehicle_number,
                vehicle_type,
                fuel_type,
                vehicle_id
            )
        )

        conn.commit()

        return jsonify({
            "message": "Vehicle updated successfully"
        })

    except Exception as e:

        conn.rollback()

        return jsonify({
            "message": str(e)
        }), 500

@app.route("/book-slot", methods=["POST"])
def book_slot():

    try:

        data = request.get_json()

        data = request.get_json()

        slot_id = data["slot_id"]
        vehicle_id = data["vehicle_id"]

        user_id = 1
        
        # Check availability
        cursor.execute(
            """
            SELECT status
            FROM ParkingSlots
            WHERE id=%s
            """,
            (slot_id,)
        )

        slot = cursor.fetchone()

        if not slot:
            return jsonify({"message": "Slot not found"}), 404

        if slot[0] != "Available":
            return jsonify({"message": "Slot already reserved"}), 400

        # Create booking
        cursor.execute(
            """
            INSERT INTO Bookings
            (user_id, vehicle_id, slot_id)
            VALUES(%s,%s,%s)
            """,
            (user_id, vehicle_id, slot_id)
        )

        # Reserve slot
        cursor.execute(
            """
            UPDATE ParkingSlots
            SET status='Reserved'
            WHERE id=%s
            """,
            (slot_id,)
        )

        conn.commit()

        return jsonify({
            "message": "Slot booked successfully"
        })

    except Exception as e:

        conn.rollback()

        print(e)

        return jsonify({
            "message": str(e)
        }),500

@app.route("/my-bookings")
def my_bookings():

    user_id = 1

    cursor.execute(
        """
        SELECT

        b.id,

        p.slot_no,

        v.vehicle_number,

        b.booking_time

        FROM Bookings b

        JOIN ParkingSlots p
        ON b.slot_id=p.id

        JOIN Vehicles v
        ON b.vehicle_id=v.id

        WHERE b.user_id=%s

        ORDER BY b.id DESC
        """,

        (user_id,)
    )

    rows = cursor.fetchall()

    bookings = []

    for row in rows:

        bookings.append({

            "booking_id": row[0],

            "slot_no": row[1],

            "vehicle_number": row[2],

            "booking_time": str(row[3])

        })

    return jsonify(bookings)

@app.route("/my-vehicles")
def my_vehicles():

        user_id = 1      # Temporary until we use the logged-in user's ID

        cursor.execute(
            """
            SELECT
                id,
                vehicle_number,
                vehicle_type,
                fuel_type
            FROM Vehicles
            WHERE user_id=%s
            ORDER BY id DESC
            """,
            (user_id,)
        )

        rows = cursor.fetchall()

        vehicles = []

        for row in rows:

            vehicles.append({

                "id": row[0],
                "vehicle_number": row[1],
                "vehicle_type": row[2],
                "fuel_type": row[3]

            })

        return jsonify(vehicles)

@app.route("/cancel-booking", methods=["POST"])
def cancel_booking():

    try:

        data = request.get_json()

        booking_id = data["booking_id"]

        # Find the slot linked to this booking
        cursor.execute(
            """
            SELECT slot_id
            FROM Bookings
            WHERE id=%s
            """,
            (booking_id,)
        )

        booking = cursor.fetchone()

        if not booking:

            return jsonify({
                "message": "Booking not found"
            }), 404

        slot_id = booking[0]

        # Make slot available again
        cursor.execute(
            """
            UPDATE ParkingSlots
            SET status='Available'
            WHERE id=%s
            """,
            (slot_id,)
        )

        cursor.execute(
            """
            DELETE FROM ChargingSessions
            WHERE booking_id=%s
            """,
            (booking_id,)
        )

        # Delete booking
        cursor.execute(
            """
            DELETE FROM Bookings
            WHERE id=%s
            """,
            (booking_id,)
        )

        conn.commit()

        return jsonify({
            "message": "Booking cancelled successfully"
        })

    except Exception as e:

        conn.rollback()

        print(e)

        return jsonify({
            "message": str(e)
        }), 500
    
@app.route("/start-charging", methods=["POST"])
def start_charging():

    try:

        data = request.get_json()

        booking_id = data["booking_id"]

        # Check whether booking exists
        cursor.execute(
            """
            SELECT id
            FROM Bookings
            WHERE id=%s
            """,
            (booking_id,)
        )

        booking = cursor.fetchone()

        if not booking:
            return jsonify({
                "message": "Booking not found"
            }), 404

        # Check whether charging is already running
        cursor.execute(
            """
            SELECT id
            FROM ChargingSessions
            WHERE booking_id=%s
            AND end_time IS NULL
            """,
            (booking_id,)
        )

        existing_session = cursor.fetchone()

        if existing_session:

            return jsonify({
                "message": "Charging is already running"
            }), 400

        # Create charging session
        cursor.execute(
            """
            INSERT INTO ChargingSessions(
                booking_id,
                start_time,
                units_consumed,
                amount
            )
            VALUES(
                %s,
                NOW(),
                0,
                0
            )
            """,
            (booking_id,)
        )

        conn.commit()

        return jsonify({
            "message": "Charging started successfully"
        })

    except Exception as e:

        conn.rollback()

        return jsonify({
            "message": str(e)
        }), 500

@app.route("/stop-charging", methods=["POST"])
def stop_charging():

    try:

        data = request.get_json()

        booking_id = data["booking_id"]
        units = float(data["units"])

        if units < 0:
            return jsonify({
                "message": "Units consumed cannot be negative"
            }), 400

        rate = 8.0

        amount = units * rate

        # Find active charging session
        cursor.execute(
            """
            SELECT id
            FROM ChargingSessions
            WHERE booking_id=%s
            AND end_time IS NULL
            ORDER BY id DESC
            LIMIT 1
            """,
            (booking_id,)
        )

        session = cursor.fetchone()

        if not session:

            return jsonify({
                "message": "No active charging session found"
            }), 404

        session_id = session[0]

        # Stop charging
        cursor.execute(
            """
            UPDATE ChargingSessions
            SET
                end_time=NOW(),
                units_consumed=%s,
                amount=%s
            WHERE id=%s
            """,
            (
                units,
                amount,
                session_id
            )
        )

        conn.commit()

        return jsonify({

            "message": "Charging stopped successfully",

            "units_consumed": units,

            "rate_per_unit": rate,

            "amount": amount

        })

    except Exception as e:

        conn.rollback()

        return jsonify({
            "message": str(e)
        }), 500
    
@app.route("/my-ev-bookings")
def my_ev_bookings():

    user_id = 1

    cursor.execute(
        """
        SELECT
            b.id AS booking_id,
            b.booking_time,
            ps.slot_no,
            v.vehicle_number,
            v.vehicle_type,
            v.fuel_type
        FROM Bookings b

        JOIN ParkingSlots ps
            ON b.slot_id = ps.id

        JOIN Vehicles v
            ON b.vehicle_id = v.id

        WHERE b.user_id=%s
        AND v.fuel_type='EV'

        ORDER BY b.id DESC
        """,
        (user_id,)
    )

    rows = cursor.fetchall()

    bookings = []

    for row in rows:

        bookings.append({
            "booking_id": row[0],
            "booking_time": str(row[1]),
            "slot_no": row[2],
            "vehicle_number": row[3],
            "vehicle_type": row[4],
            "fuel_type": row[5]
        })

    return jsonify(bookings)

@app.route("/charging-history")
def charging_history():

    try:

        user_id = 1

        cursor.execute(
            """
            SELECT
                cs.id AS charging_id,
                cs.booking_id,
                cs.start_time,
                cs.end_time,
                cs.units_consumed,
                cs.amount,
                ps.slot_no,
                v.vehicle_number,
                v.vehicle_type,
                v.fuel_type

            FROM ChargingSessions cs

            JOIN Bookings b
                ON cs.booking_id = b.id

            JOIN ParkingSlots ps
                ON b.slot_id = ps.id

            JOIN Vehicles v
                ON b.vehicle_id = v.id

            WHERE b.user_id=%s

            ORDER BY cs.id DESC
            """,
            (user_id,)
        )

        rows = cursor.fetchall()

        history = []

        for row in rows:

            history.append({

                "charging_id": row[0],

                "booking_id": row[1],

                "start_time": (
                    str(row[2])
                    if row[2] is not None
                    else None
                ),

                "end_time": (
                    str(row[3])
                    if row[3] is not None
                    else None
                ),

                "units_consumed": (
                    float(row[4])
                    if row[4] is not None
                    else 0
                ),

                "amount": (
                    float(row[5])
                    if row[5] is not None
                    else 0
                ),

                "slot_no": row[6],

                "vehicle_number": row[7],

                "vehicle_type": row[8],

                "fuel_type": row[9]

            })

        return jsonify(history)

    except Exception as e:

        return jsonify({
            "message": str(e)
        }), 500

@app.route("/charging-status/<int:booking_id>")
def charging_status(booking_id):

    try:

        cursor.execute(
            """
            SELECT
                id,
                start_time,
                end_time,
                units_consumed,
                amount
            FROM ChargingSessions
            WHERE booking_id=%s
            ORDER BY id DESC
            LIMIT 1
            """,
            (booking_id,)
        )

        session = cursor.fetchone()

        # No charging session yet
        if not session:

            return jsonify({
                "status": "Not Started",
                "charging_id": None,
                "start_time": None,
                "end_time": None,
                "units_consumed": 0,
                "amount": 0
            })

        charging_id = session[0]
        start_time = session[1]
        end_time = session[2]
        units = session[3]
        amount = session[4]

        # Charging currently running
        if end_time is None:

            return jsonify({
                "status": "Charging",
                "charging_id": charging_id,
                "start_time": str(start_time),
                "end_time": None,
                "units_consumed": float(units or 0),
                "amount": float(amount or 0)
            })

        # Charging completed
        return jsonify({
            "status": "Completed",
            "charging_id": charging_id,
            "start_time": str(start_time),
            "end_time": str(end_time),
            "units_consumed": float(units or 0),
            "amount": float(amount or 0)
        })

    except Exception as e:

        return jsonify({
            "message": str(e)
        }), 500

if __name__ == "__main__":
    app.run(debug=True)
