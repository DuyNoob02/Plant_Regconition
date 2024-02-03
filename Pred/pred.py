from flask import Flask, request, jsonify
from PIL import Image
from keras.preprocessing import image
from keras.applications.resnet50 import preprocess_input, decode_predictions
from keras.models import load_model
import tensorflow as tf
import numpy as np

app = Flask(__name__)

interpreter = tf.lite.Interpreter(model_path='../assets/ResNet50.tflite')
interpreter.allocate_tensors()


def predict_img(image):
    # Xu ly anh va chuan bi du lieu dau vao cho mo hinh
    input_tensor_index = interpreter.get_input_details()[0]['index']
    input_shape = interpreter.get_input_details()[0]['shape']

    img = Image.open(image).convert("RGB").resize((input_shape[1], input_shape[2]))
    img_array = np.expand_dims(np.array(img) / 255.0, axis=0)
    interpreter.set_tensor(input_tensor_index, img_array.astype(np.float32))

    # Chay mo hinh va nhan ket qua
    interpreter.invoke()
    output_tensor_index = interpreter.get_output_details()[0]['index']
    predictions = interpreter.get_tensor(output_tensor_index)

    return predictions

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'})
    print(request.files)
    image = request.files['image']

    class_names = ['BacHa', 'BachDongNu', 'CamThaoDat', 'CayOi', 'CoManTrau', 'CoMuc', 'DanhDanh', 'DauTam', 'DiaLien', 'DiepCa', 
                  'DiepHaChau', 'DinhLang', 'DonLaDo', 'DuaCan', 'HungChanh', 'KeDauNgua', 'KimHoaThao', 
                  'KimNgan', 'KimTienThao', 'LaLot', 'MaDe', 'NgaiCuu', 'NhanTran', 'PhenDen', 'RauMa', 'SaiDat', 'SoHuyet']
    # Du doan va nhan ket qua
    predictions = predict_img(image)
    
    # Lay ra lop co xac suat cao nhat
    predicted_class_index = np.argmax(predictions)
    # predicted_class_probability = predictions[0][predicted_class_index]

    predicted_class_name = class_names[predicted_class_index]


    return jsonify({
        'predited_class_name': predicted_class_name,
        # 'predictions_class_probability': predicted_class_probability
        })

if __name__ == '__main__':
    app.run(debug=True)