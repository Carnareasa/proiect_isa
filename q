import RPi.GPIO as GPIO
import time
from Adafruit_CharLCD import Adafruit_CharLCD

# Set the GPIO mode
GPIO.setmode(GPIO.BCM)

# Set the pin numbers for the rows and columns
columns = [6, 13, 19, 26]
rows = [16, 20, 21, 5]

# Set the password
password = "1234"

# Set up the keypad
for column in columns:
    GPIO.setup(column, GPIO.OUT)
for row in rows:
    GPIO.setup(row, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Set up the LCD
lcd = Adafruit_CharLCD(rs=26, en=19, d4=13, d5=6, d6=5, d7=16,
                       cols=16, rows=2, i2c_address=0x27)

# Function to check the password
def check_password(input_password):
    if input_password == password:
        lcd.clear()
        lcd.message("Password correct\nAccess granted")
        return True
    else:
        lcd.clear()
        lcd.message("Password incorrect\nAccess denied")
        return False

# Main loop
while True:
    input_password = ""
    lcd.clear()
    lcd.message("Enter password:")
    for column in columns:
        GPIO.output(column, 0)
        for row in rows:
            if GPIO.input(row) == 0:
                input_password += str(rows.index(row)+1)
                time.sleep(0.5)
        GPIO.output(column, 1)
    if check_password(input_password):
        break
