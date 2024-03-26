<template>
    <div class="h-screen flex">
        <div class="flex w-1/2 bg-gradient-to-tr from-blue-800 to-purple-700 i justify-around items-center"
            style="background-image: url(https://res.cloudinary.com/dytehhg2f/image/upload/v1710775149/PlantReg/AdminPage_Assets/Untitled_design_eczqoa.png);background-position: center center; background-size: 100% 100%;">
            <!-- <div class="bg-gray-200 bg-opacity-80 p-20 rounded-lg">
                <h1 class="text-amber-500 font-bold text-4xl font-sans">Medicinal Plants Admin</h1>
                <p class="text-white mt-1">Trang dành cho người quản trị</p>
                <button type="submit"
                    class="block w-28 bg-white text-indigo-800 mt-4 py-2 rounded-2xl font-bold mb-2">Read More</button>
            </div> -->
        </div>
        <div class="flex w-1/2 justify-center items-center bg-white">

            <form class="bg-white" @submit.prevent="login">
                <h1 class="text-gray-800 font-bold text-2xl mb-1">Hello Again!</h1>
                <p class="text-sm font-normal text-gray-600 mb-7">Welcome Back</p>
                <div class="flex items-center border-2 py-2 px-3 rounded-2xl mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none"
                        viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
                    </svg>
                    <input v-model="username" class="pl-2 outline-none border-none" type="text" name="" id=""
                        placeholder="Username" />
                </div>
                <div class="flex items-center border-2 py-2 px-3 rounded-2xl">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" viewBox="0 0 20 20"
                        fill="currentColor">
                        <path fill-rule="evenodd"
                            d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"
                            clip-rule="evenodd" />
                    </svg>
                    <input v-model="password" class="pl-2 outline-none border-none" type="text" name="" id=""
                        placeholder="Password" />
                </div>
                <button type="submit"
                    class="block w-full bg-indigo-600 mt-4 py-2 rounded-2xl text-white font-semibold mb-2">Login</button>
                <!-- <span class="text-sm ml-2 hover:text-blue-500 cursor-pointer">Forgot Password ?</span> -->
            </form>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
// import HomeComponent from './HomeComponent.vue';
export default {
    data() {
        return {
            username: '',
            password: ''
        }
    },
    methods: {
        async login() {
            try {
                const response = await axios.post('http://127.0.0.1:8008/admin/login', {
                    username: this.username,
                    password: this.password
                });
                console.log(response.status);
                if (response.status == 200) {
                    const { accessToken, refreshToken, username } = response.data;
                    localStorage.setItem('username', username);
                    localStorage.setItem('AC', accessToken);
                    localStorage.setItem('RT', refreshToken);
                    // console.log('asdas');
                    this.$router.push({ path: '/home'})
                }
            } catch (error) {

            }
        }
    }
}
</script>

<style>
/* CSS được đặt ở đây */
</style>