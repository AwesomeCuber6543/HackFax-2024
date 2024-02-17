import cv2
import numpy as np
import time
import PoseModule as pm
from flask import Flask, Blueprint, jsonify, request
import threading
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")

accounts = client["Accounts"]



app = Flask(__name__)
squats_counter = {'count': 0}
crunch_counter = {'count': 0}
left_counter = {'count': 0}
right_counter = {'count': 0}
pushup_counter = {'count': 0}

class positionRecognition:

    def runRecognition(self):


        cap = cv2.VideoCapture(1)
        detector = pm.poseDetector()
        countLeft = 0
        countRight = 0
        countCrunch = 0
        countSquat = 0
        dirLeft = 0
        dirRight = 0
        dirCrunch = 0
        dirSquat = 0
        pTime = 0
        while True:
            success, img = cap.read()
            img = cv2.resize(img, (1280, 720))
            img = detector.findPose(img, True)
            lmList = detector.findPosition(img, False)
            # print(lmList)
            if len(lmList) != 0:
                # Right Arm
                angle1 = detector.findAngle(img, 12, 14, 16)
                perRight = np.interp(angle1, (210, 310), (0, 100))
                barRight = np.interp(angle1, (220, 310), (650, 100))
                # Left Arm
                angle = detector.findAngle(img, 11, 13, 15)
                per = np.interp(angle, (210, 310), (0, 100))
                bar = np.interp(angle, (220, 310), (650, 100))
                # Squat (Left Leg)
                angleSquat = detector.findAngle(img, 23, 25, 27)
                perSquat = np.interp(angleSquat, (85, 160), (100, 0))
                # Crunch
                angleCrunch = detector.findAngle(img, 11, 23, 25)
                perCrunch = np.interp(angleCrunch, (240, 290), (0, 100))


                # Check for the dumbbell curls for left arm
                color = (255, 255, 255)
                if per == 100:
                    color = (0, 0, 0)
                    if dirLeft == 0:
                        countLeft += 0.5
                        dirLeft = 1
                if per == 0:
                    color = (0, 255, 255)
                    if dirLeft == 1:
                        countLeft += 0.5
                        dirLeft = 0

                # Check for curls on right
                if perRight == 100:
                    color = (0, 0, 0)
                    if dirRight == 0:
                        countRight += 0.5
                        dirRight = 1
                if perRight == 0:
                    color = (0, 255, 255)
                    if dirRight == 1:
                        countRight += 0.5
                        dirRight = 0


                # Check for Crunches
                if perCrunch == 100:
                    color = (0, 0, 0)
                    if dirCrunch == 0:
                        countCrunch += 0.5
                        dirCrunch = 1
                if perCrunch == 0:
                    color = (0, 255, 255)
                    if dirCrunch == 1:
                        countCrunch += 0.5
                        dirCrunch = 0

                # Check for squats
                if perSquat == 100:
                    color = (0, 0, 0)
                    if dirSquat == 0:
                        countSquat += 0.5
                        dirSquat = 1
                if perSquat == 0:
                    color = (0, 255, 255)
                    if dirSquat == 1:
                        countSquat += 0.5
                        dirSquat = 0
                # print(countLeft)
                        
                squats_counter['count'] = countSquat
                left_counter['count'] = countLeft
                right_counter['count'] = countRight
                crunch_counter['count'] = countCrunch

                # Draw Bar
                # cv2.rectangle(img, (1100, 100), (1175, 650), color, 2)
                # cv2.rectangle(img, (1100, int(bar)), (1175, 650), color, cv2.FILLED)
                cv2.putText(img, f'{int(per)} %', (1100, 75), cv2.FONT_HERSHEY_PLAIN, 4,
                            color, 4)
                # cv2.rectangle(img, (1100, 100), (1175, 650), color, 2)
                # cv2.rectangle(img, (800, int(barRight)), (875, 650), color, cv2.FILLED)
                cv2.putText(img, f'{int(perRight)} %', (800, 75), cv2.FONT_HERSHEY_PLAIN, 4,
                            color, 4)
                
                cv2.putText(img, f'{int(perCrunch)} %', (1100, 250), cv2.FONT_HERSHEY_PLAIN, 4,
                            color, 4)
                
                cv2.putText(img, f'{int(perSquat)} %', (800, 250), cv2.FONT_HERSHEY_PLAIN, 4,
                            color, 4)

                # Draw Curl Count
                cv2.rectangle(img, (0, 450), (250, 720), (0, 255, 0), cv2.FILLED)
                cv2.putText(img, str(int(countSquat)), (45, 670), cv2.FONT_HERSHEY_PLAIN, 15,
                            (255, 0, 0), 25)
                # cv2.putText(img, str(int(countRight)), (250, 670), cv2.FONT_HERSHEY_PLAIN, 15,
                #             (255, 0, 0), 25)
                

            cTime = time.time()
            fps = 1 / (cTime - pTime)
            pTime = cTime
            cv2.putText(img, str(int(fps)), (50, 100), cv2.FONT_HERSHEY_PLAIN, 5,
                        (255, 0, 0), 5)

            cv2.imshow("Image", img)
            cv2.waitKey(1)



def run_cv():
    mr = positionRecognition()
    mr.runRecognition()


@app.route('/get_number_squats', methods=['GET'])
def get_number_squats():

        try:
            return jsonify(squats_counter), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404
        
@app.route('/get_number_left_bicep', methods=['GET'])
def get_number_left_bicep():

        try:
            return jsonify(left_counter), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404
        

@app.route('/get_number_right_bicep', methods=['GET'])
def get_number_right_bicep():

        try:
            return jsonify(right_counter), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404
        
@app.route('/get_number_crunches', methods=['GET'])
def get_number_crunches():

        try:
            return jsonify(crunch_counter), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404





if __name__ == "__main__":
    flask_thread = threading.Thread(target=lambda: app.run(host='0.0.0.0', port=2526))

    flask_thread.daemon = True

    flask_thread.start()
    run_cv()
