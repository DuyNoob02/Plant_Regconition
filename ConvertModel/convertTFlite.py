import tensorflow as tf

# Đường dẫn đến mô hình TensorFlow SavedModel hoặc Keras Model
model_path = "D:/CTU/NienLuanNganh/App/ResNet50Model"

# Đường dẫn để lưu trữ mô hình TFLite
tflite_model_path = "D:/CTU/NienLuanNganh/App/assets/ResNet50.tflite"

# Load mô hình TensorFlow
model = tf.keras.models.load_model(model_path)

# Tạo converter
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# Chuyển đổi mô hình
tflite_model = converter.convert()

# Lưu trữ mô hình TFLite vào tệp
with open(tflite_model_path, "wb") as f:
    f.write(tflite_model)
