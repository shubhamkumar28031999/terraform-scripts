import logging
import os.path
from locust import HttpUser, TaskSet, task, constant
from faker import Faker
import json
import environmentVariable

USERS = environmentVariable.user

fake = Faker()


def generator(number_of_records):
    CRED = []
    counter = 1
    for _ in range(number_of_records):
        CRED.append({"email": "admin" + str(counter) + "@example.com", "password": "1password",
                     "firstname": fake.first_name(), "lastname": fake.last_name(),
                     "streetAddress": fake.address(), "postalCode": fake.postcode(),
                     "city": fake.city(), "phoneNumber": fake.phone_number(),
                     "birthday": fake.date(),"customerID":""})
        counter += 1
    with open('user_Credentials.json', 'w') as file:
        json.dump(CRED, file, indent=4)
    return CRED

if not os.path.exists("user_Credentials.json"):
    USER_CREDENTIALS = generator(USERS)
else:
    f = open("user_Credentials.json", "r")
    USER_CREDENTIALS = list(json.load(f))
    f.close()

class LoginWithUniqueUsersSteps(TaskSet):
    email = "NOT_FOUND"
    password = "NOT_FOUND"
    firstname = "NOT_FOUND"
    lastname = "NOT_FOUND"
    streetAddress = "NOT_FOUND"
    postalCode = "NOT_FOUND"
    city = "NOT_FOUND"
    phoneNumber = "NOT_FOUND"
    birthday = "NOT_FOUND"
    value = "NOT FOUND"
    customerID=[]

    @task
    def on_start(self):
        if len(USER_CREDENTIALS) > 0:
            temp = USER_CREDENTIALS.pop()
            
            self.email = temp["email"]
            self.password = temp["password"]
            self.firstname = temp["firstname"]
            self.lastname = temp["lastname"]
            self.streetAddress = temp["streetAddress"]
            self.postalCode = temp["postalCode"]
            self.city = temp["city"]
            self.phoneNumber = temp["phoneNumber"]
            self.birthday = temp["birthday"]
            self.x_Auth_token= ""
        logging.info('Sign in with %s email and %s password', self.email, self.password)
        with  self.client.post("/auth/signup", json={'email': self.email, 'password': self.password},catch_response=True) as response:
            print(response.json())
            if ("email") in response.json():
                if response.status_code == 200:
                    response.success()
                    print(f"Partial account creation for {self.email}")
                else:
                    response.failure("HTTP 200 OK not received")
            else:
                response.failure("Failed to Create account")

        with  self.client.post("/auth", json={'email': self.email, 'password': self.password}, catch_response=True) as response2:
            print(response2.json())
            if ("token") in response2.json():
                if response2.status_code == 200:
                    response2.success()
                    print(f"Successfully logged in for {self.email}")
                    self.x_Auth_token= json.loads(response2.text)['token']
                    headers = {"X-Auth-Token": self.x_Auth_token}
                    
                    json_data={"firstname": self.firstname,
                                                    "lastname": self.lastname,
                                                    "streetAddress": self.streetAddress,
                                                    "postalCode": self.postalCode,
                                                    "city": self.city,
                                                    "phoneNumber": self.phoneNumber,
                                                    "birthday": self.birthday}
                    
                    with  self.client.post("/customers", json=json_data,headers=headers,catch_response=True) as response3:
                        print(response3.json())
                        if ("email") in response3.json():
                            if response3.status_code == 200:
                                response3.success()
                                res2 = self.client.get("/user", headers=headers, catch_response=True)
                                print(f"Successfully created account for {self.email} with below deatils \n {response3.json()}")
                                self.customerID.append({"email":self.email, "password": self.password,
                                "firstname": self.firstname, "lastname": self.lastname,
                                "streetAddress": self.streetAddress, "postalCode": self.postalCode,
                                "city": self.city, "phoneNumber": self.phoneNumber,
                                "birthday": self.birthday,"token":self.x_Auth_token,"customerID":json.loads(res2.text)["customerId"]})
                            else:
                                response3.failure("HTTP 200 OK not received")
                        else:
                            response3.failure("Valid response not returned")
                                                    
                else:
                    response2.failure("HTTP 200 OK not received")
            else:
                response2.failure("Failed to login")


            self.customerID.append({"email":self.email, "password": self.password,
                     "firstname": self.firstname, "lastname": self.lastname,
                     "streetAddress": self.streetAddress, "postalCode": self.postalCode,
                     "city": self.city, "phoneNumber": self.phoneNumber,
                     "birthday": self.birthday,"token":self.x_Auth_token,"customerID":json.loads(res2.text)["customerId"]})

    @task
    def stop(self):
        with open('customerID.json', 'w') as file:
            json.dump(self.customerID, file, indent=4)



class Login(HttpUser):
    host = "http://" + environmentVariable.host + ":8080"
    wait_time = constant(1)
    tasks = [LoginWithUniqueUsersSteps]
