import cv2
import numpy as np
import time
import PoseModule as pm
from flask import Flask, Blueprint, jsonify, request
import threading
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")

accounts = client["Accounts"]
db1 = client["ExerciseDB"] 
collection = db1["exercises"]
db2 = client["Food"]



app = Flask(__name__)
squats_counter = {'count': 0, 'justReset':False}
crunch_counter = {'count': 0, 'justReset':False}
left_counter = {'count': 0, 'justReset':False}
right_counter = {'count': 0, 'justReset':False}
pushup_counter = {'count': 0, 'justReset':False}
overheadpress_counter = {'count': 0, 'justReset':False}

class positionRecognition:

    def runRecognition(self):


        cap = cv2.VideoCapture(0)
        detector = pm.poseDetector()
        countLeft = 0
        countRight = 0
        countCrunch = 0
        countSquat = 0
        countPushup = 0
        countPress = 0
        dirLeft = 0
        dirRight = 0
        dirCrunch = 0
        dirSquat = 0
        dirPushup = 0
        dirPress = 0
        maxPress = 0
        pTime = 0
        while True:
            if(squats_counter['justReset'] == True):
                countSquat = 0
                squats_counter['justReset'] = False
            if(left_counter['justReset'] == True):
                countLeft = 0
                left_counter['justReset'] = False
            if(right_counter['justReset'] == True):
                countRight = 0
                right_counter['justReset'] = False
            if(crunch_counter['justReset'] == True):
                countCrunch = 0
                crunch_counter['justReset'] = False
            if(pushup_counter['justReset'] == True):
                countPushup = 0
                pushup_counter['justReset'] = False
            if(overheadpress_counter['justReset'] == True):
                countPress = 0
                overheadpress_counter['justReset'] = False

            
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

                #Pushup
                anglePushup = detector.findAngle(img, 12, 14, 16)
                perPushup = np.interp(anglePushup, (180, 250), (0, 100))

                # overhead press
                anglePress = detector.findAngle(img, 12, 14, 16)
                perPress = np.interp(anglePress, (300, 220), (0, 100))


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


                # Pushup
                if perPushup == 100:
                    color = (0, 0, 0)
                    if dirPushup == 0:
                        countPushup += 0.5
                        dirPushup = 1
                if perPushup == 0:
                    color = (0, 255, 255)
                    if dirPushup == 1:
                        countPushup += 0.5
                        dirPushup = 0

                # Overhead Press
                if perPress == 100:
                    color = (0, 0, 0)
                    if dirPress == 0:
                        countPress += 0.5
                        dirPress = 1
                if perPress == 0:
                    color = (0, 255, 255)
                    if dirPress == 1:
                        countPress += 0.5
                        dirPress = 0
                        
                squats_counter['count'] = countSquat
                left_counter['count'] = countLeft
                right_counter['count'] = countRight
                crunch_counter['count'] = countCrunch
                pushup_counter['count'] = countPushup
                overheadpress_counter['count'] = countPress

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
                # cv2.rectangle(img, (0, 450), (250, 720), (0, 255, 0), cv2.FILLED)
                cv2.putText(img, str(int(countPress)), (45, 670), cv2.FONT_HERSHEY_PLAIN, 15,
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


@app.route('/start_workout', methods=['GET'])
def start_workout():

        try:
            squats_counter['justReset'] = True
            crunch_counter['justReset'] = True
            left_counter['justReset'] = True
            right_counter['justReset'] = True
            pushup_counter['justReset'] = True
            overheadpress_counter['justReset'] = True
            return jsonify({'message': 'Workout Started'}), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404

@app.route('/get_number_squats', methods=['GET'])
def get_number_squats():

        try:
            # print(squats_counter)
            return jsonify({'count':squats_counter['count']}), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404
        
@app.route('/get_number_left_bicep', methods=['GET'])
def get_number_left_bicep():

        try:
            return jsonify({'count':left_counter['count']}), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404

@app.route('/get_number_right_bicep', methods=['GET'])
def get_number_right_bicep():

        try:
            return jsonify({'count':right_counter['count']}), 200
        except:

        # else:
            return jsonify({'message': 'Object not found'}), 404
        
@app.route('/get_number_crunches', methods=['GET'])
def get_number_crunches():

        try:
            return jsonify({'count':crunch_counter['count']}), 200
        except:
            return jsonify({'message': 'Object not found'}), 404
        
@app.route('/get_number_pushups', methods=['GET'])
def get_number_pushups():

        try:
            return jsonify({'count':pushup_counter['count']}), 200
        except:
            return jsonify({'message': 'Object not found'}), 404
        
@app.route('/get_number_press', methods=['GET'])
def get_number_press():

        try:
            return jsonify({'count':overheadpress_counter['count']}), 200
        except:
            return jsonify({'message': 'Object not found'}), 404
        
@app.route('/add_new_exercise', methods=['POST'])
def add_new_exercise():
    try:
        data = request.json
        collection.insert_one(data)
        return jsonify({'message': 'Exercise added successfully'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@app.route('/add_nutrition_data', methods=['POST'])
def add_nutrition_data():
    try:
        data = request.json
        db2["nutrition_data"].insert_one(data)
        return jsonify({'message': 'Nutrition data added successfully'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@app.route('/get_all_nutrition_data', methods=['GET'])
def get_all_nutrition_data():
    try:
        nutrition_data = list(db2["nutrition_data"].find({}, {'_id': 0}))
        return jsonify(nutrition_data), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@app.route('/delete_all_nutrition_data', methods=['POST'])
def delete_all_nutrition_data():
    try:
        db2["nutrition_data"].delete_many({})
        return jsonify({'message': 'All nutrition data deleted successfully'}), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@app.route('/total_calories', methods=['GET'])
def total_calories():
    try: 
        total_calories = 0
        cursor = db2["nutrition_data"].find({}, {'calories': 1, '_id': 0})
        for document in cursor:
            calories = document.get('calories')
            if calories and calories != '-':
                total_calories += int(calories)
        return jsonify({'total_calories': total_calories}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/get_exercise_data', methods=['GET'])
def get_exercise_data():
    try:
        exercise_data = list(collection.find({}, {'_id': 0}))
        # print(exercise_data)
        return jsonify(exercise_data), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    
@app.route('/delete_exercise_entry', methods=['POST'])
def delete_exercise_entry():
    try:
        data = request.json
        print(data)
        date = data.get('date')
        exercise_name = data.get('exercise_name')
        completeReps = data.get('complete_reps')  # Include reps in the deletion criteria
        partialReps = data.get('partial_reps')
        
        if not date or not exercise_name or completeReps is None:
            return jsonify({'message': 'Date, exercise name, and reps are required fields'}), 400
        
        result = collection.delete_one({'date': date, 'exercise_name': exercise_name, 'complete_reps': completeReps, 'partial_reps': partialReps})
        
        if result.deleted_count == 1:
            return jsonify({'message': 'Exercise entry deleted successfully'}), 200
        else:
            return jsonify({'message': 'Exercise entry not found'}), 404
    except Exception as e:
        return jsonify({'message': str(e)}), 500






if __name__ == "__main__":
    flask_thread = threading.Thread(target=lambda: app.run(host='0.0.0.0', port=2526))

    flask_thread.daemon = True

    flask_thread.start()
    run_cv()
