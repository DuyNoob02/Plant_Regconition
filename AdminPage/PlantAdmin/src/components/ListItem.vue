<template>
    <div class="px-32">

        <div ref="firstElement" class="w-[1px] h-0"></div>

        <div class="flex h-full flex-col overflow-y-scroll  bg-white shadow-xl">
            <div class="flex-1 overflow-y-auto px-4 py-6 sm:px-6 ">
                <!-- <div class="flex items-start justify-between">
                    <h2 class="text-lg font-medium text-gray-900" id="slide-over-title">Shopping
                        cart</h2>
                    <div class="ml-3 flex h-7 items-center">
                        <button type="button" class="relative -m-2 p-2 text-gray-400 hover:text-gray-500">
                            <span class="absolute -inset-0.5"></span>
                            <span class="sr-only">Close panel</span>
                            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                stroke="currentColor" aria-hidden="true">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </button>
                    </div>
                </div> -->
                <template v-for="item in listItem">
                    <div class="mt-8">
                        <div class="flow-root ">
                            <ul role="list" class="-my-6 divide-y divide-gray-200">
                                <li class="flex py-6 group">

                                    <div
                                        class="h-32 w-32 m-auto flex-shrink-0 overflow-hidden rounded-md border border-gray-200">
                                        <img :src="item.images[0]"
                                            alt="Salmon orange fabric pouch with match zipper, gray zipper pull, and adjustable hip belt."
                                            class="h-full w-full object-cover object-center">
                                    </div>

                                    <div class="ml-4 flex flex-1 flex-col">
                                        <div>
                                            <div class="flex justify-between text-base font-medium text-gray-900">
                                                <h3>
                                                    {{ item.name }}
                                                </h3>

                                            </div>
                                            <p class="mt-1 text-sm text-gray-500"><b>Tên khoa học: </b>
                                                {{ item.scientificName }}</p>
                                        </div>
                                        <div class="text-sm">
                                            <p class="text-gray-500 line-clamp-2"> Mô tả: {{ item.description }}</p>
                                        </div>
                                        <div class="text-sm">
                                            <p class="text-gray-500 line-clamp-2">Thông tin dược liệu: {{ item.info }}
                                            </p>
                                        </div>
                                    </div>
                                    <div class="ml-auto flex flex-col">
                                        <!-- <router-link :to="{ name: 'edit', params: { name: 'edit' } }">
                                            User profile
                                        </router-link> -->
                                        <router-link :to="{ name: 'edit', params: { id: item._id } }"
                                            class="opacity-0 my-auto group-hover:opacity-100 px-8 py-3 bg-blue-500 text-white">
                                            Chỉnh sửa</router-link>
                                        <!-- <router-link :to="{ name: 'edit', params: { id: item._id } }"
                                            class="opacity-0 my-auto group-hover:opacity-100 px-8 py-3 bg-blue-500 text-white" ">Chỉnh sửa</router-link> -->
                                    </div>
                                </li>

                                <!-- More products... -->
                            </ul>
                        </div>
                    </div>
                </template>
            </div>
        </div>





        <div class="mt-4 flex justify-center mb-10">
            <nav class=" isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                <a href="#" @click="prevPage()" :class="{'pointer-events-none': currentPage === 1}"
                    class="relative inline-flex items-center rounded-l-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                    <span class="sr-only">Previous</span>
                    <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd"
                            d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z"
                            clip-rule="evenodd" />
                    </svg>
                </a>
                <!-- <template v-for="i in totalPage">
                    <button :class="{ 'bg-indigo-400 text-gray-100': currentPage == i }" @click="getListItem(i)"
                        aria-current="page"
                        class="relative z-10 inline-flex items-center green-gray-400 px-4 py-2 text-sm font-semibold text-gray-100 focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">{{
                    i }}</button>
                </template> -->
                <template v-for="i in totalPage" :key="i" >
                    <button
                        :class="{ 'bg-indigo-400 text-gray-100': currentPage === i, 'text-black bg-white': currentPage !== i }"
                        @click="getListItem(i)" aria-current="page"
                        class="relative z-10 inline-flex items-center green-gray-400 px-4 py-2 text-sm font-semibold focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">{{
                    i }}</button>
                </template>
                <!-- Current: "z-10 bg-indigo-600 text-white focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600", Default: "text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:outline-offset-0" -->
                <a href="#" @click="nextPage()" :class="{ 'pointer-events-none': currentPage === totalPage }"
                    class="relative inline-flex items-center rounded-r-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                    <span class="sr-only">Next</span>
                    <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd"
                            d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                            clip-rule="evenodd" />
                    </svg>
                </a>
            </nav>
        </div>
        <!-- </template> -->

    </div>

</template>

<script setup>
import axios from 'axios';
import { ref } from 'vue'
import { useRouter } from 'vue-router';

const router = useRouter()

const listItem = ref([]);
const totalPage = ref(0);

const currentPage = ref(1);
const firstElement = ref(null)

const data = async (i) => {
    try {
        const response = await axios.get(`http://127.0.0.1:8008/admin/getPlant?page=${i}`, {

        })
        return response.data
    } catch (error) {

    }
}

function getListItem(i) {
    data(i).then((result) => {
        listItem.value = result.result
        totalPage.value = result.totalPage
        currentPage.value = i
        console.log(totalPage.value);
        console.log(firstElement.value);
        if (firstElement.value != null) {
            firstElement.value.scrollIntoView({ behavior: "instant", block: "end", inline: "nearest" });
        }

    })
}
getListItem(1)

// function gotoEdit(id) {
//     router.push({ name: 'Edit', params:{id}})
// }


function prevPage() {
    if(this.currentPage > 1){
        this.currentPage--;
        getListItem(this.currentPage--);
    }
}

function nextPage() {
    if(this.currentPage < this.totalPage){
        this.currentPage++;
        getListItem(this.currentPage++);
    }
}

</script>

<style lang="scss" scoped></style>