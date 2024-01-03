from locust import task, TaskSet, HttpUser, constant
import json
from faker import Faker
from random import choice
import environmentVariable

fake = Faker()

ec2_instance_ip = environmentVariable.host

f = open("customerID.json", "r")
data = list(json.load(f))
f.close()

class loginWithDifferentAccount(TaskSet):

    @task
    def policies(self):
        random_user = choice(data)["customerID"]
        res = self.client.get(":8090/customers/" + random_user + "/policies")
        print("--------------------------------------------------")
        print(f"Showing policy of {random_user} with email \n", res.text)

class MyLoadTester(HttpUser):
    host = "http://" + environmentVariable.host
    wait_time = constant(1)
    tasks = [loginWithDifferentAccount]
