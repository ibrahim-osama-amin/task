import requests
import schedule

def monitor_application():
    try:
        response = requests.get('http://192.168.111.128:8080/', timeout=5) # You can monitor any website response codes through this 
        print(response.status_code)
        if response.status_code == 200:
            print("Application is running well.....")

        else:
            print(f"APPLICATION DOWN. FIX IT with error code {response.status_code}")
    except Exception as ex:
        print("The application is unreachable. It is a network issue")


schedule.every(5).seconds.do(monitor_application)
while True:
    schedule.run_pending()