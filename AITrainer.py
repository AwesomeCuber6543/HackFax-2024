import cv2
import numpy as np
import time
import PoseModule as pm
from flask import Flask, Blueprint, jsonify, request
import threading



app = Flask(__name__)

class moveRecognition:

    def runRecognition(self):


        cap = cv2.VideoCapture(1)
        detector = pm.poseDetector()
        countLeft = 0
        countRight = 0
        dirLeft = 0
        dirRight = 0
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
                angle = detector.findAngle(img, 11, 13, 15,False)
                per = np.interp(angle, (210, 310), (0, 100))
                bar = np.interp(angle, (220, 310), (650, 100))
                # print(angle, per)

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
                print(countLeft)

                # Draw Bar
                cv2.rectangle(img, (1100, 100), (1175, 650), color, 2)
                cv2.rectangle(img, (1100, int(bar)), (1175, 650), color, cv2.FILLED)
                cv2.putText(img, f'{int(per)} %', (1100, 75), cv2.FONT_HERSHEY_PLAIN, 4,
                            color, 4)
                cv2.rectangle(img, (1100, 100), (1175, 650), color, 2)
                cv2.rectangle(img, (800, int(barRight)), (875, 650), color, cv2.FILLED)
                cv2.putText(img, f'{int(perRight)} %', (800, 75), cv2.FONT_HERSHEY_PLAIN, 4,
                            color, 4)

                # Draw Curl Count
                cv2.rectangle(img, (0, 450), (250, 720), (0, 255, 0), cv2.FILLED)
                cv2.putText(img, str(int(countLeft)), (45, 670), cv2.FONT_HERSHEY_PLAIN, 15,
                            (255, 0, 0), 25)
                cv2.putText(img, str(int(countRight)), (250, 670), cv2.FONT_HERSHEY_PLAIN, 15,
                            (255, 0, 0), 25)
                

            cTime = time.time()
            fps = 1 / (cTime - pTime)
            pTime = cTime
            cv2.putText(img, str(int(fps)), (50, 100), cv2.FONT_HERSHEY_PLAIN, 5,
                        (255, 0, 0), 5)

            cv2.imshow("Image", img)
            cv2.waitKey(1)



def run_cv():
    mr = moveRecognition()
    mr.runRecognition()


if __name__ == "__main__":
    flask_thread = threading.Thread(target=lambda: app.run(host='0.0.0.0', port=2526))

    flask_thread.daemon = True

    flask_thread.start()
    run_cv()
