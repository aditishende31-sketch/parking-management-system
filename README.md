\# 🚗 Smart Parking Management System



A full-stack smart parking management system developed using \*\*Flutter\*\*, \*\*Flask\*\*, and \*\*MySQL\*\*. The application allows users to view parking slots, manage vehicles, make parking bookings, and manage different parking categories including regular, EV, and disabled parking.



\## 📌 Project Overview



The Smart Parking Management System provides a digital platform for managing parking spaces and user bookings.



The system consists of:



\* \*\*Flutter\*\* frontend for the mobile/application interface

\* \*\*Flask\*\* backend providing REST APIs

\* \*\*MySQL\*\* database for storing users, vehicles, parking slots, bookings, and related information

\* \*\*PyMySQL\*\* for communication between Flask and MySQL

\* \*\*python-dotenv\*\* for keeping database credentials outside the source code



\## ✨ Features



\### 👤 User Features



\* User registration and login

\* View available parking slots

\* View parking slot status

\* Book parking slots

\* View current and previous bookings

\* Cancel bookings

\* Vehicle management

\* Support for different parking categories



\### 🅿️ Parking Features



\* Regular parking slots

\* EV parking slots

\* Disabled parking slots

\* Slot availability tracking

\* Slot status management

\* Booking management



\### 🔧 Backend Features



\* REST API using Flask

\* Cross-Origin Resource Sharing using Flask-CORS

\* MySQL database connectivity

\* Environment-variable based database configuration

\* JSON API responses



\## 🛠️ Technology Stack



\### Frontend



| Technology      | Purpose                |

| --------------- | ---------------------- |

| Flutter         | Application UI         |

| Dart            | Programming language   |

| HTTP            | REST API communication |

| Material Design | UI components          |



\### Backend



| Technology    | Purpose                         |

| ------------- | ------------------------------- |

| Python        | Backend programming             |

| Flask         | REST API framework              |

| Flask-CORS    | Cross-origin API requests       |

| PyMySQL       | MySQL connectivity              |

| python-dotenv | Environment variable management |



\### Database



\*\*MySQL\*\*



The database stores application data such as:



\* Users

\* Vehicles

\* Parking slots

\* Bookings

\* Charging-related information



\## 🏗️ System Architecture



```text

┌──────────────────────────┐

│      Flutter Frontend    │

│       (Dart)             │

└────────────┬─────────────┘

&#x20;            │

&#x20;            │ HTTP / REST API

&#x20;            ▼

┌──────────────────────────┐

│       Flask Backend      │

│        (Python)          │

└────────────┬─────────────┘

&#x20;            │

&#x20;            │ PyMySQL

&#x20;            ▼

┌──────────────────────────┐

│      MySQL Database      │

│    parking\_system        │

└──────────────────────────┘

```



\## 📁 Project Structure



```text

smart-parking-management-system/

│

├── backend/

│   ├── app.py

│   └── requirements.txt

│

├── frontend/

│   ├── android/

│   ├── ios/

│   ├── lib/

│   ├── linux/

│   ├── macos/

│   ├── web/

│   ├── windows/

│   ├── pubspec.yaml

│   └── ...

│

├── .gitignore

└── README.md

```



\## ⚙️ Backend Setup



\### 1. Navigate to the backend



```bash

cd backend

```



\### 2. Create a virtual environment



```bash

python -m venv venv

```



\### 3. Activate the virtual environment



\#### Windows



```powershell

.\\venv\\Scripts\\Activate.ps1

```



\### 4. Install dependencies



```bash

pip install -r requirements.txt

```



\## 🔐 Environment Configuration



Database credentials are stored using environment variables rather than directly in the source code.



Create a `.env` file in the project root:



```text

DB\_HOST=localhost

DB\_USER=root

DB\_PASSWORD=YOUR\_MYSQL\_PASSWORD

```



Replace `YOUR\_MYSQL\_PASSWORD` with your own MySQL password.



\*\*Do not upload `.env` to GitHub.\*\*



The repository's `.gitignore` already excludes `.env`.



\## 🗄️ MySQL Database



Create a MySQL database named:



```sql

CREATE DATABASE parking\_system;

```



The required tables should then be created according to the database schema used by the application.



Make sure the MySQL server is running before starting the Flask backend.



\## ▶️ Running the Backend



From the project root:



```powershell

python .\\backend\\app.py

```



The Flask server runs on:



```text

http://127.0.0.1:5000

```



\## 📱 Frontend Setup



Open a new terminal and navigate to the Flutter frontend:



```powershell

cd frontend

```



Install Flutter dependencies:



```powershell

flutter pub get

```



Check connected devices:



```powershell

flutter devices

```



Run the application:



```powershell

flutter run

```



For a Flutter Android emulator, the backend can be accessed through:



```text

http://10.0.2.2:5000

```



For a physical Android device, the API address needs to be configured according to the device and network setup.



\## 📦 Flutter Dependencies



The frontend currently uses:



```yaml

cupertino\_icons: ^1.0.8

http: ^1.5.0

```



Development dependencies include:



```yaml

flutter\_test:

&#x20; sdk: flutter



flutter\_lints: ^6.0.0

```



\## 🔌 API



The Flask backend provides REST endpoints for application functionality such as:



\* User authentication

\* Parking slot information

\* Parking bookings

\* Booking cancellation

\* Vehicle management

\* Parking-related operations



The Flutter application communicates with these endpoints using HTTP requests.



\## 🅿️ Parking Slot Categories



The system supports multiple parking categories, including:



\### Regular



Standard parking spaces for regular vehicles.



\### EV



Parking spaces intended for electric vehicles.



\### Disabled



Parking spaces designated for users requiring accessible parking.



\## 🔄 Booking Flow



```text

User Login

&#x20;   ↓

View Parking Slots

&#x20;   ↓

Select Available Slot

&#x20;   ↓

Select Vehicle

&#x20;   ↓

Create Booking

&#x20;   ↓

Slot Status Updated

&#x20;   ↓

View Booking

&#x20;   ↓

Cancel Booking

```



\## 🔒 Security Considerations



The project uses environment variables for database credentials so that passwords are not stored directly in the GitHub source code.



The `.env` file is excluded through `.gitignore`.



For a production deployment, additional security improvements would be recommended, including:



\* Password hashing

\* Proper authentication/session management

\* Token-based authentication

\* Input validation

\* Secure API configuration

\* Role-based authorization

\* Production database security



\## 🚧 Current Limitations



Some parts of the project are currently implemented as a college/portfolio project and can be extended further.



Possible improvements include:



\* Complete session-based user authentication

\* Admin dashboard

\* Advanced parking analytics

\* Online payment integration

\* Real-time parking availability

\* GPS-based parking discovery

\* Push notifications

\* Password hashing and stronger authentication

\* Deployment to a cloud server



\## 🎯 Future Scope



The system can be extended into a larger smart-city parking platform with:



\* IoT-based parking sensors

\* Automatic vehicle detection

\* Number plate recognition

\* Real-time parking occupancy

\* EV charging station management

\* Online payments

\* Navigation to parking locations

\* Cloud-based administration

\* Mobile notifications



\## 👩‍💻 Author



\*\*Aditi Shende\*\*



T.E. CSE (AI \& ML)

Saraswati College of Engineering



\## 📚 Academic Project



This project was developed as a full-stack software project combining mobile application development, REST API development, database management, and parking management functionality.



