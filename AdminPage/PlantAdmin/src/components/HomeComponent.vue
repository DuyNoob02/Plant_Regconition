<template>
  <div>
    <Header></Header>
    <ListItem></ListItem>
  </div>
</template>

<script setup>

import axios from 'axios';
import Header from './Header.vue';
import ListItem from './ListItem.vue';
const data = async () => {
  try {
    const response = await axios.get('http://127.0.0.1:8008/admin/getPlant', {

    })
    return response.data
  } catch (error) {

  }
}
data().then((result) => {
  console.log(result);
})

</script>

<style scoped></style>