import keras
import os
import cv2
import numpy as np
import re
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import LeakyReLU
from keras.layers import Flatten 
from tensorflow.keras.callbacks import TensorBoard
from keras.callbacks import ModelCheckpoint


(X_train, y_train), (X_valid, y_valid) = mnist.load_data()



# alcune immagini del MNIST sono malclassificate quindi correggo

y_train[59915] = 7
y_train[43454] = 3
y_train[10994] = 9
y_train[30049] = 4
y_train[32342] = 7
y_train[2720] = 7
y_train[178] = 0
y_train[212] = 1
y_train[340] = 1
y_train[500] = 2



###################################################################################################
            #giusto come esercizio di stile aggiungo altri dati oltre quelli del MNIST


input_folder = './input_images'
labels_file_path = './Labels.txt'
img_height, img_width, num_channels = 28, 28, 1


image_size = (img_height, img_width)  
num_channels = 1  


def load_and_preprocess_images(input_dir, image_size):
    images = []

    
    def natural_sort_key(s):
        return [int(text) if text.isdigit() else text.lower() for text in re.split('(\d+)', s)]
    
    
    file_names = sorted([file for file in os.listdir(input_dir) if file.lower().endswith('.png')], key=natural_sort_key)
    
    for file_name in file_names:
        file_path = os.path.join(input_dir, file_name)
        
        image = cv2.imread(file_path, cv2.IMREAD_GRAYSCALE)

        if image is not None:
            image_resized = cv2.resize(image, image_size)
            
            image_resized = 255 - image_resized
            image_normalized = image_resized / 255.0
            
            
            image_reshaped = image_normalized.reshape((image_size[0], image_size[1], num_channels)).astype('float32')
            
            images.append(image_reshaped)
    
    return np.array(images)


def load_labels(file_path):
    with open(file_path, 'r') as file:
        
        content = file.read().strip()
        
        
        labels_str = content.replace('[', ' ').replace(']', ' ').split()
        
        
        labels = [int(label) for label in labels_str if label]
        
        return np.array(labels)




###################################################################################################

X_train = X_train.reshape(60000, img_height, img_width, num_channels).astype('float32')
X_valid = X_valid.reshape(10000, img_height, img_width, num_channels).astype('float32')

X_train /= 255
X_valid /= 255


n_classes = 10


extra_X_train = load_and_preprocess_images(input_folder, image_size)
extra_y_train = load_labels(labels_file_path)



y_train = keras.utils.to_categorical(y_train, n_classes)
extra_y_train = keras.utils.to_categorical(extra_y_train, n_classes)
y_valid = keras.utils.to_categorical(y_valid, n_classes)



new_X_train = np.concatenate((X_train, extra_X_train), axis=0)
new_y_train = np.concatenate((y_train, extra_y_train), axis=0)




model = Sequential()





model.add(Conv2D(32, kernel_size=(3, 3), padding='same', input_shape=(img_height, img_width, num_channels)))
model.add(LeakyReLU(alpha=0.01))

model.add(Conv2D(128, kernel_size=(3, 3), padding='same'))
model.add(LeakyReLU(alpha=0.01))
model.add(MaxPooling2D(pool_size=(2,2)))
model.add(Dropout(0.3))


model.add(Conv2D(128, kernel_size=(3, 3), padding='same'))
model.add(LeakyReLU(alpha=0.01))


#Questo è un unico layer
model.add(Conv2D(256, kernel_size=(3, 3)))
model.add(LeakyReLU(alpha=0.01))
model.add(MaxPooling2D(pool_size=(2,2)))
model.add(Dropout(0.3))
model.add(Flatten())


model.add(Dense(256, activation='relu')) 
model.add(Dropout(0.5))

model.add(Dense(128))
model.add(LeakyReLU(alpha=0.01))
model.add(Dropout(0.5))

model.add(Dense(128, activation='relu')) 
model.add(Dropout(0.5))

model.add(Dense(256, activation='relu')) 
model.add(Dropout(0.5))


model.add(Dense(n_classes, activation='softmax')) 

model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])

tensorboard = TensorBoard(log_dir='logs/conv-net')

checkpoint_accuracy = ModelCheckpoint(
        filepath = 'newBestAccuracyModel.keras',
        monitor='val_accuracy',
        save_best_only=True,
        verbose=1
    )

checkpoint_loss = ModelCheckpoint(
        filepath = 'newBestLossModel.keras',
        monitor='val_loss',
        save_best_only=True,
        verbose=1
    )

model.fit(new_X_train, new_y_train, batch_size=128, epochs=25, verbose=1, validation_data=(X_valid, y_valid), callbacks=[checkpoint_accuracy, checkpoint_loss])


inp = input("Salvare? y/n\n")

if inp == 'y':
    model.save('./Convolutional_digits_calssifier.keras')

