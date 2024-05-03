from flask import Flask, request, jsonify
from keras.models import load_model
import numpy as np
from PIL import Image
import io
from tensorflow.keras.applications.resnet50 import preprocess_input  

app = Flask(__name__)

# Load the SavedModel
model = load_model('../ResNet50Model/ResNet50')

@app.route('/predict', methods=['POST'])
def predict():
    # Get the image file from the request
    file = request.files['image']
    
    # Đọc dữ liệu ảnh như là dữ liệu nhị phân
    img_bytes = file.read()

    # Tạo một đối tượng BytesIO từ dữ liệu nhị phân của ảnh
    img_stream = io.BytesIO(img_bytes)
    
    # Load ảnh bằng PIL
    img = Image.open(img_stream)
    img = img.convert('RGB')  # Chuyển sang ảnh RGB nếu cần
    
    # Resize ảnh thành kích thước 224x224
    img = img.resize((224, 224))
    
    # Convert ảnh thành mảng numpy và tiền xử lý
    img_array = np.array(img)
    img_array = preprocess_input(img_array)

    # Add batch dimension
    img_array = np.expand_dims(img_array, axis=0)
    
    # Perform prediction
    predictions = model.predict(img_array)

    # Get the predicted class label
    class_labels = ['BacHa', 'BachDongNu', 'CamThaoDat', 'CayOi', 'CoManTrau', 'CoMuc', 'DanhDanh', 'DauTam', 'DiaLien', 'DiepCa', 
    'DiepHaChau', 'DinhLang', 'DonLaDo', 'DuaCan', 'HungChanh', 'KeDauNgua', 'KimHoaThao', 
    'KimNgan', 'KimTienThao', 'LaLot', 'MaDe', 'NgaiCuu', 'NhanTran', 'PhenDen', 'RauMa', 'SaiDat', 'SoHuyet', 'TiaTo', 'TrinhNuHoangCung', 'VuSuaDat']
    predicted_class_index = np.argmax(predictions)
    predicted_class_label = class_labels[predicted_class_index]

    # Return the prediction result
    return jsonify({
        'class_label': predicted_class_label,
        'predictions': predictions.tolist()
    })  

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
