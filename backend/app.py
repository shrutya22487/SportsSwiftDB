from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func
from flask_mysqldb import MySQL
from sqlalchemy.exc import IntegrityError
import secrets
import pymysql.cursors

app = Flask(__name__, static_url_path='/static')

app.config['SECRET_KEY'] = secrets.token_hex(16)

user = "root"
pin = ""
host = "localhost"
db_name = "SportSwiftDB"
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{user}:{pin}@{host}/{db_name}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['MYSQL_HOST'] = 'localhost'  
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'SportSwiftDB'

mysql = MySQL(app)

connection = pymysql.connect(
    host='localhost',
    user='root',
    password='',
    database='SportSwiftDB',
    cursorclass=pymysql.cursors.DictCursor
)

def test_database_connection():
    try:
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT 1') 
        cursor.close()
        return True 
    except Exception as e:
        print(f"Database connection error: {e}")
        return False 

MAX_LOGIN_ATTEMPTS=3
def update_failed_attempts(username):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE email NATURAL JOIN customer SET failed_attempts = failed_attempts + 1 WHERE em = %s;", (username,))
    mysql.connection.commit()
    cursor.close()

def reset_failed_attempts(username):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE email NATURAL JOIN customer SET failed_attempts = 0 WHERE em = %s;", (username,))
    mysql.connection.commit()
    cursor.close()

def get_blocked(username):
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT blocked FROM email NATURAL JOIN customer NATURAL JOIN check_blocked  where em=%s;", (username,))
    failed_attempts = cursor.fetchone()
    cursor.close()
    if failed_attempts == None: 
        return 0
    return failed_attempts[0]

def fetch_products():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT Name AS ProductName, Price FROM Product")
    products = cursor.fetchall()
    cursor.close()
    return products

@app.route('/customer_dashboard')
def customer_dashboard():
    products = fetch_products()  
    return render_template('customer_dashboard.html', products=products, customer_id = session["customer"])

@app.route('/')
def index():
    if test_database_connection():
        return render_template('login.html')

def fetch_products1(search_query):
    cursor = mysql.connection.cursor()
    query = "SELECT Name AS ProductName, Price FROM Product WHERE Name LIKE %s ;"
    cursor.execute(query, ('%' + search_query + '%',))
    products = cursor.fetchall()
    cursor.close()
    return products

@app.route('/search', methods=['POST','GET'])
def search():
    search_query = request.form['search']
    products = fetch_products1(search_query)
    return render_template('search.html', products=products)

@app.route('/add_to_cart', methods=['POST'])
def add_to_cart():
    if request.method == 'POST':
        customer_id = session["customer"]
        product_id = request.form['product_id']
        Supplier_ID = request.form['Supplier_ID']
        quantity = int(request.form['quantity'])
        cursor = mysql.connection.cursor()
        try:
            cursor.execute("SELECT * FROM cart WHERE Customer_ID = %s AND Product_ID = %s AND Supplier_ID = %s", (customer_id, product_id, Supplier_ID))
            existing_product = cursor.fetchone()

            if existing_product:
                print(existing_product)
                new_quantity = existing_product[3] + quantity
                cursor.execute("UPDATE cart SET quantity = %s WHERE Customer_ID = %s AND Product_ID = %s AND Supplier_ID = %s", (new_quantity, customer_id, product_id, Supplier_ID))
            else:
                cursor.execute("INSERT INTO cart (Customer_ID, Product_ID, Supplier_ID, quantity) VALUES (%s, %s, %s, %s)", (customer_id, product_id, Supplier_ID, quantity))
            
            mysql.connection.commit()
        except Exception as e:
            mysql.connection.rollback()
        finally:
            cursor.close()
        
        return redirect(url_for('customer_dashboard'))

@app.route('/checkout')
def checkout():
    customer_id = session["customer"]
    if not customer_id:
        # flash('You need to login first.', 'error')
        return redirect(url_for('index'))

    cursor = mysql.connection.cursor()
    try:
        cursor.execute("SELECT * FROM cart INNER JOIN Product ON cart.Product_ID = Product.Product_ID WHERE Customer_ID = %s", (customer_id))
        cart_items = cursor.fetchall()
        cursor.close()
    except Exception as e:
        mysql.connection.rollback()
        cursor.close()
    return render_template('checkout.html', cart_items=cart_items)

@app.route('/delete_from_cart', methods=['POST'])
def delete_from_cart():
    product_id = request.form['product_id']
    supplier_id = request.form['supplier_id']
    
    cursor = mysql.connection.cursor()
    try:
        cursor.execute("START TRANSACTION")
        cursor.execute("DELETE FROM cart WHERE Customer_ID = %s AND Product_ID = %s AND Supplier_ID = %s", (session["customer"][0], product_id, supplier_id))
        cursor.execute("COMMIT")
        cursor.close()
        mysql.connection.commit()
    except Exception as e:
        mysql.connection.rollback()
        cursor.close()
    return redirect(url_for('checkout'))

@app.route('/profile', methods=['GET', 'POST'])
def profile():
    return render_template('profile.html')

@app.route('/update_profile', methods=['POST'])
def update_profile():
    try:
        new_email = request.form.get('email')
        new_password = request.form.get('password')
        print(new_email)
        original_email =  session["customer"]
        cursor = mysql.connection.cursor()
        
        if new_email and new_email != original_email:
            cursor.execute("START TRANSACTION")
            update_email_query = '''SET SQL_SAFE_UPDATES=0;
            UPDATE email NATURAL JOIN CUSTOMER SET em = %s WHERE Customer_ID = %s;
            SET SQL_SAFE_UPDATES=1;'''
            cursor.execute(update_email_query, (str(new_email), original_email[0]))
            cursor.execute("COMMIT")

        if new_password :
            cursor.execute("START TRANSACTION")
            update_password_query = "UPDATE customer SET password = %s WHERE Customer_ID = %s"
            cursor.execute(update_password_query, (new_password, original_email[0]))
            cursor.execute("COMMIT")
        cursor.close()  
        mysql.connection.commit()
        flash('Profile updated successfully', 'success')  
        return redirect('/profile')
    except Exception as e:
        mysql.connection.rollback()
        flash('An error occurred while updating profile', 'error')
        cursor.close()
        return redirect('/profile')

@app.route('/pay', methods=['POST'])
def pay():
    cursor = mysql.connection.cursor()
    try:
        # Insert items from cart into Orders table
        cursor.execute("INSERT INTO Orders (Customer_ID, Product_ID, Supplier_ID, quantity) SELECT Customer_ID, Product_ID, Supplier_ID, quantity FROM cart WHERE Customer_ID = %s", (session["customer"],))
        
        # Execute the trigger manually to update Sale_Stats
        cursor.execute("""
            INSERT INTO Sale_Stats (Quantity, Product_ID, -Supplier_ID)
            SELECT quantity, Product_ID, Supplier_ID FROM cart WHERE Customer_ID = %s
        """, (session["customer"],))
        
        # Delete items from cart
        cursor.execute("DELETE FROM cart WHERE Customer_ID = %s", (session["customer"],))
        
        mysql.connection.commit()
        cursor.close()
    except Exception as e:
        mysql.connection.rollback()
        cursor.close()
    return redirect(url_for('customer_dashboard'))


@app.route('/supplier_dashboard')
def supplier_info():
    with connection.cursor() as cursor:
        sql_query = """
            SELECT Supplier_ID, Name FROM product WHERE Supplier_ID=%s;
            """
        cursor.execute(sql_query, (session["supplier"],))
        data = cursor.fetchall()

    return render_template('supplier_info.html', data=data)

def validate_customer(username, password):
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT Customer_ID FROM email NATURAL JOIN customer where em=%s and Password=%s;", (username, password))
    user = cursor.fetchone()
    cursor.close()
    return user  

def DropTriggerLogin(username):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE email NATURAL JOIN customer SET failed_attempts = failed_attempts + 1 WHERE em = %s;", (username,))
    mysql.connection.commit()
    cursor.close()

def validate_supplier(username, password):
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT Supplier_ID FROM email NATURAL JOIN Supplier where em=%s and password=%s;", (username, password))
    user = cursor.fetchone()
    cursor.close()
    return user 

@app.route('/update_product_name', methods=['POST'])
def update_product_name():
    new_name = request.form.get('new_name')
    
    with connection.cursor() as cursor:
        cursor.execute("SET SQL_SAFE_UPDATES=0")
        cursor.execute("START TRANSACTION")
        sql_query = """
            UPDATE Product
            SET Name = %s
            WHERE Supplier_ID = %s;
        """
        cursor.execute(sql_query, (new_name, session["supplier"]))
        cursor.execute("SET SQL_SAFE_UPDATES=1")

        cursor.execute("COMMIT")
        connection.commit()
    return redirect('/supplier_dashboard')

@app.route('/login', methods=['POST'])
def login():
    user_type = request.form['user_type']
    if user_type == 'customer':
        username = request.form['customer_id']
        password = request.form['password']
        failed_attempts = get_blocked(username)
        
        if failed_attempts:
            flash('Your account is locked due to too many failed login attempts. Please contact support.','error')
            return redirect(url_for('index'))

        customer = validate_customer(username, password)
        if customer:
            session["customer"] = customer
            reset_failed_attempts(username)  
            return redirect(url_for('customer_dashboard'))
        else:
            DropTriggerLogin(username) 
            flash('Invalid username or password')
            return redirect(url_for('index'))
    elif user_type == 'supplier':
        username = request.form['customer_id']
        password = request.form['password']
        supp = validate_supplier(username, password)
        if supp:
            session["supplier"] = supp
            return redirect(url_for('supplier_info'))
        else:
            flash('Invalid username or password')
            return redirect(url_for('index'))
    else:
        return "Invalid user type"

if __name__ == "__main__":
    app.run(debug=True)