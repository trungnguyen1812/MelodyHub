<template>
  <vue-office-docx 
    :src="docxUrl"
    style="height: 100vh;"
    @rendered="handleRendered"
  />
</template>

<script setup>
import VueOfficeDocx from '@vue-office/docx'
import '@vue-office/docx/lib/index.css'

// Cách 1: URL công khai
const docxUrl = 'https://your-domain.com/storage/file.docx'

// Cách 2: File upload (ArrayBuffer)
const handleFileUpload = (event) => {
  const file = event.target.files[0]
  const reader = new FileReader()
  reader.onload = () => {
    docxUrl.value = reader.result // ArrayBuffer
  }
  reader.readAsArrayBuffer(file)
}
</script>