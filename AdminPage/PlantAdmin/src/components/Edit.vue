<template>
    <div>
        <!-- Hiệu ứng loading -->
        <div v-if="isLoading"
            class="fixed top-0 left-0 w-full h-full flex justify-center items-center bg-black bg-opacity-50 z-50">
            <div class="border-4 border-white border-opacity-30 rounded-full w-16 h-16 animate-spin"></div>
        </div>
        <Header></Header>
        <div class="container mx-auto px-4 py-8">
            <h2 class="text-2xl font-bold mb-4">Chỉnh sửa thông tin cây {{ plantInfor.name }}</h2>
            <!-- Hien thi hinh anh hien tai -->
            <div class="flex items-center mb-4">
                <div v-if="plantInfor.images" class="mb-4 text-center">
                    <h3 class="text-lg font-semibold mb-2">Hình ảnh hiện tại</h3>
                    <img :src="plantInfor.images[0]" alt="Hình ảnh hiện tại" class="max-w-sm">
                </div>
                <!-- Chon hinh anh moi -->
                <div class="mb-4 ml-8">
                    <input type="file" @change="handleImageChange" class="hidden" ref="imageInput">
                    <button @click="$refs.imageInput.click()"
                        class="px-4 py-2 bg-gray-200 text-gray-800 rounded-sm hover:bg-gray-300">Chọn hình ảnh
                        mới</button>
                </div>
                <div v-if="newImage" class=" text-center">
                    <h3 class="text-lg font-semibold mb-2">Hình ảnh mới</h3>
                    <img :src="newImage" alt="Hình ảnh mới" class="max-w-sm mb-2 ml-8">
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="name" class="block mb-2 font-semibold">Tên:</label>
                    <input type="text" id="name" v-model="plantInfor.name" class="w-full px-4 py-2 border rounded-md">
                </div>
                <div>
                    <label for="scientificName" class="block mb-2 font-semibold">Tên khoa học:</label>
                    <input type="text" id="scientificName" v-model="plantInfor.scientificName"
                        class="w-full px-4 py-2 border rounded-md">
                </div>
                <div class="col-span-2">
                    <label for="description" class="block mb-2 font-semibold">Mô tả:</label>
                    <textarea id="description" v-model="plantInfor.description" rows="6"
                        class="w-full px-4 py-2 border rounded-md"></textarea>
                </div>
                <div class="col-span-2">
                    <label for="info" class="block mb-2 font-semibold">Thông tin:</label>
                    <textarea id="info" v-model="plantInfor.info" rows="6"
                        class="w-full px-4 py-2 border rounded-md"></textarea>
                </div>
            </div>
            <button @click="updatePlantInfo"
                class="mt-4 px-6 py-3 bg-blue-500 text-white rounded-md hover:bg-blue-600">Lưu
                thay đổi</button>
        </div>
        <!-- {{ id }} -->
    </div>

</template>

<script setup>
import Header from './Header.vue';
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import axios from 'axios';
import { ref } from 'vue';

const route = useRoute()
const id = computed(() => route.params.id)
const plantInfor = ref(null);

const newImage = ref(null)
const imageUpdate = ref(null);
const isLoading = ref(false);

const data = async (id) => {
    try {
        isLoading.value = true;
        const response = await axios.get(`http://127.0.0.1:8008/admin/getPLant/${id.value}`)
        // console.log(response);
        return response.data.result;
    } catch (error) {
        console.log(error);
    } finally {
        isLoading.value = false;
    }
}
data(id).then((result) => {
    console.log(result);
    plantInfor.value = result
})


const handleImageChange = (e) => {
    const file = e.target.files[0];
    imageUpdate.value = file;
    console.log(imageUpdate.value);
    if (file) {
        const reader = new FileReader();
        reader.onload = () => {
            newImage.value = reader.result;
        };
        reader.readAsDataURL(file);
    }
}


const updatePlantInfo = async () => {
    try {
        isLoading.value = true
        const API_URL = `http://127.0.0.1:8008/admin/updatePlant/${id.value}`

        const formdata = new FormData();

        formdata.append('name', plantInfor.value.name);
        formdata.append('scientificName', plantInfor.value.scientificName);
        formdata.append('description', plantInfor.value.description);
        formdata.append('info', plantInfor.value.info);
        if (imageUpdate.value) {
            formdata.append('images', imageUpdate.value);
            // console.log(newImage);
        }

        const response = await axios.post(API_URL, formdata);
        console.log(response.data);
    } catch (error) {
        console.log(error);
    } finally {
        isLoading.value = false;
    }
}
data(id).then((result) => {
    console.log(result);
    plantInfor.value = result
})
</script>


<style scoped>
/* @keyframes spin {
    from {
        transform: rotate(0deg);
    }

    to {
        transform: rotate(360deg);
    }
}

.animate-spin {
    animation: spin 1s linear infinite;
} */
</style>