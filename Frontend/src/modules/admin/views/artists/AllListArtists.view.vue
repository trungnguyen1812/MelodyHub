<template>
    <div class="dashboard-container">
        <div class="header-section">
            <div class="title-container">
                <h1>Artists Management</h1>
                <p class="subtitle">Manage All Artists Accounts</p>
            </div>
            <div class="header-actions">
                <button @click="CreateArtist" class="btn-add-user">
                    <span class="btn-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                            stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                        </svg>
                    </span>
                    Add New Artists
                </button>

                <div class="search-box">
                    <input type="text" placeholder="Search artists..." v-model="keyword" @input="onSearch">
                    <span class="search-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                            stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
                        </svg>
                    </span>
                </div>
            </div>
        </div>
        <!-- Recent Users Table -->
        <div class="table-section">
            <div class="section-header">
                <h2>Recent Artists</h2>
                <button class="btn-view-all" @click="router.back()">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                        <path fill-rule="evenodd"
                            d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z"
                            clip-rule="evenodd" />
                    </svg>
                    Back
                </button>
            </div>
            <div class="table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>Artists</th>
                            <th>Followers</th>
                            <th>Total songs</th>
                            <th>Country</th>
                            <th>Status</th>
                            <th>Join Date</th>
                            <th>Social</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="artist in paginatedArtists" :key="artist.id">
                            <td class="user-cell">
                                <div class="user-avatar">
                                    <img :src="getFullImageUrl(artist.avatar_url)" :alt="artist.name"
                                        class="avatar-img" />
                                </div>
                                <div class="user-info">
                                    <p class="user-name" :title="artist.name">{{ artist.name }}</p>
                                </div>
                            </td>
                            <td>{{ formatCompactNumber(artist.total_followers) }}</td>
                            <td>{{ formatCompactNumber(artist.total_songs) }}</td>
                            <td>
                                <span>
                                    {{ artist.country }}
                                </span>
                            </td>
                            <td>
                                <span :class="`status-badge status-${artist.status}`">
                                    {{ artist.status }}
                                </span>
                            </td>
                            <td>{{ formatDate(artist.created_at ?? "") }}</td>
                            <td>
                                <div class="social-icons">
                                    <a v-if="artist.facebook_url" :href="artist.facebook_url" target="_blank" class="social-icon facebook">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                                            <path d="M24 12c0-6.627-5.373-12-12-12S0 5.373 0 12c0 5.99 4.388 10.954 10.125 11.854V15.47H7.078v-3.47h3.047V9.356c0-3.007 1.792-4.688 4.533-4.688 1.312 0 2.686.234 2.686.234v2.953H15.83c-1.49 0-1.955.925-1.955 1.874V12h3.328l-.532 3.469h-2.796v8.385C19.612 22.954 24 17.99 24 12z"/>
                                        </svg>
                                    </a>
                                    <a v-if="artist.instagram_url" :href="artist.instagram_url" target="_blank" class="social-icon instagram">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                                            <path d="M12 2.163c3.204 0 3.584.012 4.85.07 1.188.054 1.98.257 2.675.545.73.284 1.334.676 1.928 1.27.594.594.986 1.198 1.27 1.928.288.695.49 1.487.545 2.675.058 1.266.07 1.646.07 4.85s-.012 3.584-.07 4.85c-.054 1.188-.257 1.98-.545 2.675-.284.73-.676 1.334-1.27 1.928-.594.594-1.198.986-1.928 1.27-.695.288-1.487.49-2.675.545-1.266.058-1.646.07-4.85.07s-3.584-.012-4.85-.07c-1.188-.054-1.98-.257-2.675-.545-.73-.284-1.334-.676-1.928-1.27-.594-.594-.986-1.198-1.27-1.928-.288-.695-.49-1.487-.545-2.675-.058-1.266-.07-1.646-.07-4.85s.012-3.584.07-4.85c.054-1.188.257-1.98.545-2.675.284-.73.676-1.334 1.27-1.928.594-.594 1.198-.986 1.928-1.27.695-.288 1.487-.49 2.675-.545 1.266-.058 1.646-.07 4.85-.07zM12 0C8.741 0 8.332.014 7.052.072c-1.267.058-2.147.283-2.912.603-.79.33-1.466.78-2.124 1.437-.657.658-1.107 1.334-1.437 2.124-.32.765-.545 1.645-.603 2.912C.014 8.332 0 8.741 0 12s.014 3.668.072 4.948c.058 1.267.283 2.147.603 2.912.33.79.78 1.466 1.437 2.124.658.657 1.334 1.107 2.124 1.437.765.32 1.645.545 2.912.603C8.332 23.986 8.741 24 12 24s3.668-.014 4.948-.072c1.267-.058 2.147-.283 2.912-.603.79-.33 1.466-.78 2.124-1.437.657-.658 1.107-1.334 1.437-2.124.32-.765.545-1.645.603-2.912.058-1.28.072-1.689.072-4.948s-.014-3.668-.072-4.948c-.058-1.267-.283-2.147-.603-2.912-.33-.79-.78-1.466-1.437-2.124-.658-.657-1.334-1.107-2.124-1.437-.765-.32-1.645-.545-2.912-.603C15.668.014 15.259 0 12 0z"/>
                                        </svg>
                                    </a>
                                    <a v-if="artist.twitter_url" :href="artist.twitter_url" target="_blank" class="social-icon x">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                                            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                                        </svg>
                                    </a>
                                    <a v-if="artist.youtube_url" :href="artist.youtube_url" target="_blank" class="social-icon youtube">
                                        <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                                            <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
                                        </svg>
                                    </a>
                                </div>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-action btn-edit"  @click="viewUpdateArtist(artist.id)">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                            <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                                            <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                                        </svg>
                                    </button>
                                    <button class="btn-action btn-delete" @click="deleteUser(artist.id)">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                            <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clip-rule="evenodd" />
                                        </svg>
                                    </button>
                                    <button class="btn-action btn-view" @click="viewDetailArtist(artist.id)">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                            <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                                            <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div v-if="loading" class="loading-overlay">
                    <div class="spinner">
                        <div class="dot"></div>
                        <div class="dot"></div>
                        <div class="dot"></div>
                    </div>
                    <span>Loading data...</span>
                </div>
            </div>
            <!-- Pagination -->
            <div v-if="artists.length > 0" class="pagination">
                <div class="pagination-info">
                    Showing {{ paginationStart }} to {{ paginationEnd }} of {{ artists.length }} entries
                </div>
                <div class="pagination-controls">
                    <button class="pagination-btn" :disabled="currentPage === 1" @click="currentPage--">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-4">
                            <path fill-rule="evenodd" d="M11.78 5.22a.75.75 0 0 1 0 1.06L8.06 10l3.72 3.72a.75.75 0 1 1-1.06 1.06l-4.25-4.25a.75.75 0 0 1 0-1.06l4.25-4.25a.75.75 0 0 1 1.06 0Z" clip-rule="evenodd" />
                        </svg>
                    </button>
                    <span class="pagination-current">{{ currentPage }} / {{ totalPages }}</span>
                    <button class="pagination-btn" :disabled="currentPage === totalPages" @click="currentPage++">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-4">
                            <path fill-rule="evenodd" d="M8.22 5.22a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
    <div v-if="loading" class="loading-state">
        Loading artists...
    </div>
    <div v-else-if="artists.length === 0" class="empty-state">
        <div class="empty-icon">👥</div>
        <p>No artists found</p>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted ,computed} from 'vue';

import { useArtistStore, getFullImageUrl } from '@/modules/admin/stores/artists/artistsStore';

import { storeToRefs } from "pinia";
import router from '@/modules/router';
import Swal from 'sweetalert2';
import { useNotificationStore } from "@/store/notificationStore";

const keyword = ref("");
const notificationStore = useNotificationStore();
let searchTimeout: number | null = null;
const currentPage = ref(1);
const itemsPerPage = 10;
const artistStore = useArtistStore();


const { artists, loading } = storeToRefs(artistStore);



const CreateArtist =()=>{
    router.push({name:"admin.artistsmanager.add"});
}

const onSearch = ()=>{
    if (searchTimeout)clearTimeout(searchTimeout);
    searchTimeout = window.setTimeout(async() => {
        if (!keyword.value.trim()) {
            await artistStore.fetchArtists();
            return;
        }
         await artistStore.fetchSearchArtitst(
            keyword.value
        );
    }, 300);
}


// FOR ARTISTS
function viewDetailArtist(id: number) {
    router.push({
        name: "admin.artistsmanager.detail",
        params: { id } 
    });
}

function viewUpdateArtist( id: number) {
    router.push({
        name: "admin.artistsmanager.update",
        params: { id }
    });
}


async function deleteUser(id: number) {
    try {
        const result = await Swal.fire({
            title: 'Delete User',
            text: 'Are you sure you want to delete this user? This action cannot be undone.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            reverseButtons: true,
            customClass: {
                confirmButton: 'btn btn-danger',
                cancelButton: 'btn btn-secondary'
            }
        });

        if (!result.isConfirmed) return;

        loading.value = true;
        await artistStore.fetchDelete(id);
        await artistStore.fetchArtists();
        notificationStore.notify("Delete artist successful", "success");

        router.push({name:"admin.artistsmanager.all"});

    } catch (error: any) {
        const err = error as { response?: { status?: number } }
        notificationStore.notify("Delete artist error", "error");
        if (err.response?.status === 404) {
            router.push('/404')
        } else if (err.response?.status === 401) {
            router.push('/login')
        } else {

        }

    } finally {
        loading.value = false;
    }
}


const formatCompactNumber = (num: number | null): string => {
  if (num === null || num === undefined) return "0";

  return new Intl.NumberFormat("en", {
    notation: "compact",
    maximumFractionDigits: 1,
  }).format(num);
};

const formatDate = (dateString?: string): string => {
    if (!dateString) return '—'
    return new Date(dateString).toLocaleString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
    })
}

const totalPages = computed(() => Math.ceil(artists.value.length / itemsPerPage));
const paginationStart = computed(() => ((currentPage.value - 1) * itemsPerPage) + 1);
const paginationEnd = computed(() => Math.min(currentPage.value * itemsPerPage, artists.value.length));

const paginatedArtists = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return artists.value.slice(start, end);
});

onMounted(() => {
    artistStore.fetchArtists();
});
</script>

<style scoped>
/* Base Styles */
.dashboard-container {
    height: 82vh;
    width: 100%;
    border-radius: 14px;
    margin-top: 7px;
    display: block;
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    display: flex;
    flex-direction: column;
    padding: 25px;
    position: relative;

    font-family: 'Afacad', sans-serif;
    color: white;
}

.header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}


.user-avatar {
    width: 45px;
    height: 45px;
    overflow: hidden;
    border-radius: 50%;
    background: #f0f0f0;
}

.avatar-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.title-container h1 {
    font-size: 28px;
    font-weight: 600;
    margin: 0;
    background: linear-gradient(90deg, #00aaff, #00ffaa);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.subtitle {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
    margin-top: 5px;
    margin-bottom: 0;
}

.header-actions {
    display: flex;
    gap: 20px;
    align-items: center;
}

.btn-add-user {
    background: linear-gradient(135deg, #00aaff, #0088cc);
    border: none;
    color: white;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s ease;
    font-family: 'Afacad', sans-serif;
}

.btn-add-user:hover {
    background: linear-gradient(135deg, #0088cc, #006699);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0, 170, 255, 0.4);
}

.btn-icon {
    font-size: 18px;
    font-weight: bold;
}

.search-box {
    position: relative;
}

.search-box input {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(0, 170, 255, 0.3);
    border-radius: 8px;
    padding: 10px 40px 10px 15px;
    color: white;
    width: 250px;
    font-family: 'Afacad', sans-serif;
    transition: all 0.3s ease;
}

.search-box input:focus {
    outline: none;
    border-color: #00aaff;
    box-shadow: 0 0 10px rgba(0, 170, 255, 0.3);
}

.search-icon {
    position: absolute;
    right: 15px;
    top: 50%;
    transform: translateY(-50%);
    color: rgba(255, 255, 255, 0.6);
}

/* Stats Grid */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
    margin-bottom: 30px;
}

.stat-card {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 15px;
    border: 1px solid rgba(0, 170, 255, 0.2);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.stat-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    opacity: 0.8;
}

.card-neon-blue::before {
    background: linear-gradient(90deg, #00aaff, #00ccff);
}

.card-neon-green::before {
    background: linear-gradient(90deg, #00ffaa, #00cc88);
}

.card-neon-purple::before {
    background: linear-gradient(90deg, #aa00ff, #cc00ff);
}

.card-neon-orange::before {
    background: linear-gradient(90deg, #ffaa00, #ff8800);
}

.stat-card:hover {
    transform: translateY(-5px);
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(0, 170, 255, 0.4);
    box-shadow: 0 10px 20px rgba(0, 170, 255, 0.1);
}

.stat-icon {
    font-size: 32px;
    width: 60px;
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 10px;
}

.stat-content h3 {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
    margin: 0 0 5px 0;
    font-weight: 500;
}

.stat-number {
    font-size: 28px;
    font-weight: 600;
    margin: 0 0 5px 0;
}

.stat-change {
    font-size: 12px;
    margin: 0;
    color: rgba(255, 255, 255, 0.6);
}

.stat-change.positive {
    color: #00ffaa;
}

.stat-change.neutral {
    color: #aaaaff;
}

/* Table Section */
.table-section {
    flex: 1;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(0, 170, 255, 0.2);
    display: flex;
    height: 20vh;
    flex-direction: column;
    overflow-y: auto;
    overflow-x: hidden;
}

.table-section .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.table-section .section-header h2 {
    font-size: 20px;
    margin: 0;
    color: rgba(255, 255, 255, 0.9);
}

.table-container {
    flex: 1;
    overflow-y: auto;
}

.users-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}

.users-table thead {
    background: rgb(29, 69, 94);
    position: sticky;
    top: 0;
    z-index: 10;
}

.users-table th {
    padding: 15px;
    text-align: left;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.7);
    border-bottom: 1px solid rgba(0, 170, 255, 0.3);
    white-space: nowrap;
    z-index: 99999;
}

.users-table td {
    padding: 15px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    vertical-align: middle;
}

.table-checkbox {
    width: 18px;
    height: 18px;
    cursor: pointer;
    accent-color: #00aaff;
}

.user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #00aaff, #00ffaa);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
    color: white;
}

.user-info {
    display: flex;
    flex-direction: column;
}

.user-name {
    margin: 0;
    font-weight: 500;
    color: white;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    max-width: 100px;
}
.user-id {
    margin: 0;
    font-size: 12px;
    color: rgba(255, 255, 255, 0.6);
}

/* Badges */
.role-badge,
.status-badge {
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
    display: inline-block;
    white-space: nowrap;
}

/* Role badges - fixed for your data structure */
/* Boss / Owner */
.role-badge.role-boss {
    background: rgba(124, 58, 237, 0.2);
    color: #a78bfa;
    border: 1px solid rgba(124, 58, 237, 0.3);
}

/* Administrator */
.role-badge.role-admin {
    background: rgba(255, 0, 0, 0.2);
    color: #ff6666;
    border: 1px solid rgba(255, 0, 0, 0.3);
}

/* Content Manager */
.role-badge.role-content_manager {
    background: rgba(0, 170, 255, 0.2);
    color: #66ccff;
    border: 1px solid rgba(0, 170, 255, 0.3);
}

/* Partner / Producer */
.role-badge.role-partner {
    background: rgba(0, 255, 170, 0.2);
    color: #66ffcc;
    border: 1px solid rgba(0, 255, 170, 0.3);
}

/* Moderator */
.role-badge.role-moderator {
    background: rgba(255, 153, 0, 0.2);
    color: #ffb366;
    border: 1px solid rgba(255, 153, 0, 0.3);
}

/* VIP Yearly */
.role-badge.role-user_vip_yearly {
    background: rgba(234, 179, 8, 0.2);
    color: #facc15;
    border: 1px solid rgba(234, 179, 8, 0.3);
}

/* VIP Monthly */
.role-badge.role-user_vip_monthly {
    background: rgba(202, 138, 4, 0.2);
    color: #eab308;
    border: 1px solid rgba(202, 138, 4, 0.3);
}

/* Free User */
.role-badge.role-user_free {
    background: rgba(153, 153, 153, 0.2);
    color: #cccccc;
    border: 1px solid rgba(153, 153, 153, 0.3);
}

/* Status badges - fixed for your data structure */
.status-badge.status-active {
    background: rgba(0, 255, 0, 0.2);
    color: #66ff66;
    border: 1px solid rgba(0, 255, 0, 0.3);
}

.status-badge.status-inactive {
    background: rgba(255, 255, 0, 0.2);
    color: #ffff66;
    border: 1px solid rgba(255, 255, 0, 0.3);
}

.status-badge.status-pending {
    background: rgba(255, 165, 0, 0.2);
    color: #ffcc66;
    border: 1px solid rgba(255, 165, 0, 0.3);
}

/* Default status badge if status is unknown */
.status-badge {
    background: rgba(153, 153, 153, 0.2);
    color: #cccccc;
    border: 1px solid rgba(153, 153, 153, 0.3);
}

/* Action Buttons */
.action-buttons {
    display: flex;
    gap: 8px;
}

.btn-action {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: white;
    width: 32px;
    height: 32px;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
    font-size: 14px;
}

.btn-action:hover {
    background: rgba(255, 255, 255, 0.2);
    transform: scale(1.1);
}

.btn-edit:hover {
    background: rgba(0, 170, 255, 0.3);
    border-color: #00aaff;
}

.btn-delete:hover {
    background: rgba(255, 0, 0, 0.3);
    border-color: #ff0000;
}

.btn-view:hover {
    background: rgba(0, 255, 0, 0.3);
    border-color: #00ff00;
}

.btn-view-all {
    background: transparent;
    border: 1px solid rgba(0, 170, 255, 0.5);
    color: #00aaff;
    padding: 8px 16px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-family: 'Afacad', sans-serif;
    font-size: 14px;
}

.btn-view-all:hover {
    background: rgba(0, 170, 255, 0.1);
    transform: translateX(5px);
}

/* Loading State */
.loading-state {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 200px;
    color: rgba(255, 255, 255, 0.7);
}

/* Empty State */
.empty-state {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    min-height: 200px;
    color: rgba(255, 255, 255, 0.7);
    text-align: center;
    padding: 40px;
}

.empty-state .empty-icon {
    font-size: 48px;
    margin-bottom: 20px;
    opacity: 0.5;
}

/* Scrollbar Styling */
.dashboard-container::-webkit-scrollbar,
.table-container::-webkit-scrollbar {
    width: 6px;
}

.dashboard-container::-webkit-scrollbar-thumb,
.table-container::-webkit-scrollbar-thumb {
    background: rgba(0, 170, 255, 0.6);
    border-radius: 3px;
}

.dashboard-container::-webkit-scrollbar-track,
.table-container::-webkit-scrollbar-track {
    background: transparent;
}

/* Neon Pulse Animation */
@keyframes neonPulse {

    0%,
    100% {
        box-shadow:
            0 0 8px rgba(0, 170, 255, 0.7),
            0 0 16px rgba(0, 170, 255, 0.55),
            0 0 24px rgba(0, 170, 255, 0.35),
            0 8px 25px rgba(0, 0, 0, 0.45);
    }

    50% {
        box-shadow:
            0 0 12px rgba(0, 170, 255, 0.8),
            0 0 20px rgba(0, 170, 255, 0.65),
            0 0 30px rgba(0, 170, 255, 0.45),
            0 8px 30px rgba(0, 0, 0, 0.5);
    }
}

/* Responsive Design */
@media (max-width: 1400px) {
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 1200px) {
    .dashboard-container {
        padding: 20px;
    }

    .users-table th,
    .users-table td {
        padding: 12px;
        font-size: 14px;
    }
}

@media (max-width: 1024px) {
    .header-section {
        flex-direction: column;
        align-items: flex-start;
        gap: 20px;
    }

    .header-actions {
        width: 100%;
        justify-content: space-between;
    }

    .search-box input {
        width: 200px;
    }
}

@media (max-width: 768px) {
    .dashboard-container {
        padding: 15px;
        height: auto;
        min-height: 82vh;
    }

    .stats-grid {
        grid-template-columns: 1fr;
    }

    .header-actions {
        flex-direction: column;
        gap: 15px;
        align-items: flex-start;
    }

    .search-box input {
        width: 100%;
    }

    .users-table {
        display: block;
        overflow-x: auto;
    }

    .action-buttons {
        flex-wrap: wrap;
        justify-content: center;
    }

    .table-section .section-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }

    .btn-view-all {
        align-self: flex-end;
    }
}

@media (max-width: 480px) {
    .dashboard-container {
        padding: 12px;
    }

    .title-container h1 {
        font-size: 24px;
    }

    .stat-card {
        flex-direction: column;
        text-align: center;
        padding: 15px;
    }

    .stat-icon {
        width: 50px;
        height: 50px;
        font-size: 24px;
        margin-bottom: 10px;
    }

    .users-table th,
    .users-table td {
        padding: 8px;
        font-size: 13px;
    }

    .user-avatar {
        width: 35px;
        height: 35px;
        font-size: 13px;
    }

    .role-badge,
    .status-badge {
        padding: 4px 8px;
        font-size: 11px;
    }

    .btn-action {
        width: 28px;
        height: 28px;
        font-size: 12px;
    }
}

/* From Uiverse.io by devkatyall */
/* The design is inspired from Galahhad*/

.popup {
    --burger-line-width: 1.125em;
    --burger-line-height: 0.125em;
    --burger-offset: 0.625em;
    --burger-bg: #1d455e;
    --burger-color: #333;
    --burger-line-border-radius: 0.1875em;
    --burger-diameter: 2em;
    --burger-btn-border-radius: calc(var(--burger-diameter) / 2);
    --burger-line-transition: 0.3s;
    --burger-transition: all 0.1s ease-in-out;
    --burger-hover-scale: 1.1;
    --burger-active-scale: 0.95;
    --burger-enable-outline-color: var(--burger-bg);
    --burger-enable-outline-width: 0.125em;
    --burger-enable-outline-offset: var(--burger-enable-outline-width);
    /* nav */
    --nav-padding-x: 0.25em;
    --nav-padding-y: 0.625em;
    --nav-border-radius: 0.375em;
    --nav-border-color: #ccc;
    --nav-border-width: 0.0625em;
    --nav-shadow-color: rgba(0, 0, 0, 0.2);
    --nav-shadow-width: 0 1px 5px;
    --nav-bg: rgba(71, 65, 65, 0.984);
    --nav-font-family: "Poppins", sans-serif;
    --nav-default-scale: 0.8;
    --nav-active-scale: 1;
    --nav-position-left: 0;
    --nav-position-right: unset;
    /* if you want to change sides just switch one property */
    /* from properties to "unset" and the other to 0 */
    /* title */
    --nav-title-size: 0.625em;
    --nav-title-color: #777;
    --nav-title-padding-x: 1rem;
    --nav-title-padding-y: 0.25em;
    /* nav button */
    --nav-button-padding-x: 1rem;
    --nav-button-padding-y: 0.375em;
    --nav-button-border-radius: 0.375em;
    --nav-button-font-size: 17px;
    --nav-button-hover-bg: #1d455e;
    --nav-button-hover-text-color: #fff;
    --nav-button-distance: 0.875em;
    /* underline */
    --underline-border-width: 0.0625em;
    --underline-border-color: #ccc;
    --underline-margin-y: 0.3125em;
}

/* popup settings 👆 */

.popup {
    display: inline-block;
    text-rendering: optimizeLegibility;
    position: relative;
}

.popup input {
    display: none;
}

.burger {
    display: flex;
    position: relative;
    align-items: center;
    justify-content: center;
    background: var(--burger-bg);
    width: var(--burger-diameter);
    height: var(--burger-diameter);
    border-radius: var(--burger-btn-border-radius);
    border: none;
    cursor: pointer;
    overflow: hidden;
    transition: var(--burger-transition);
    outline: var(--burger-enable-outline-width) solid transparent;
    outline-offset: 0;
}

.popup-window {
    transform: scale(var(--nav-default-scale));
    visibility: hidden;
    opacity: 0;
    position: absolute;
    padding: var(--nav-padding-y) var(--nav-padding-x);
    background: var(--nav-bg);
    font-family: var(--nav-font-family);
    color: var(--nav-text-color);
    border-radius: var(--nav-border-radius);
    box-shadow: var(--nav-shadow-width) var(--nav-shadow-color);
    border: var(--nav-border-width) solid var(--nav-border-color);
    top: calc(var(--burger-diameter) + var(--burger-enable-outline-width) + var(--burger-enable-outline-offset));
    left: var(--nav-position-left);
    right: var(--nav-position-right);
    transition: var(--burger-transition);
    margin-top: 10px;
    z-index: 999;
}

.popup-window legend {
    padding: var(--nav-title-padding-y) var(--nav-title-padding-x);
    margin: 0;
    color: var(--nav-title-color);
    font-size: var(--nav-title-size);
    text-transform: uppercase;
}

.popup-window ul {
    margin: 0;
    padding: 0;
    list-style-type: none;
}

.popup-window ul button {
    outline: none;
    width: 100%;
    border: none;
    background: none;
    display: flex;
    align-items: center;
    color: var(--burger-color);
    font-size: var(--nav-button-font-size);
    padding: var(--nav-button-padding-y) var(--nav-button-padding-x);
    white-space: nowrap;
    border-radius: var(--nav-button-border-radius);
    cursor: pointer;
    column-gap: var(--nav-button-distance);
}

.popup-window ul li:nth-child(1) svg,
.popup-window ul li:nth-child(2) svg {
    color: #1d455e;
}

.popup-window ul li:nth-child(4) svg,
.popup-window ul li:nth-child(5) svg {
    color: rgb(153, 153, 153);
}

.popup-window ul li:nth-child(7) svg {
    color: red;
}

.popup-window hr {
    margin: var(--underline-margin-y) 0;
    border: none;
    border-bottom: var(--underline-border-width) solid var(--underline-border-color);
}

/* actions */

.popup-window ul button:hover,
.popup-window ul button:focus-visible,
.popup-window ul button:hover svg,
.popup-window ul button:focus-visible svg {
    color: var(--nav-button-hover-text-color);
    background: var(--nav-button-hover-bg);
}

.burger:hover {
    transform: scale(var(--burger-hover-scale));
}

.burger:active {
    transform: scale(var(--burger-active-scale));
}

.burger:focus:not(:hover) {
    outline-color: var(--burger-enable-outline-color);
    outline-offset: var(--burger-enable-outline-offset);
}

.popup input:checked+.burger span:nth-child(1) {
    top: 50%;
    transform: translateY(-50%) rotate(45deg);
}

.popup input:checked+.burger span:nth-child(2) {
    bottom: 50%;
    transform: translateY(50%) rotate(-45deg);
}

.popup input:checked+.burger span:nth-child(3) {
    transform: translateX(calc(var(--burger-diameter) * -1 - var(--burger-line-width)));
}

.popup input:checked~nav {
    transform: scale(var(--nav-active-scale));
    visibility: visible;
    opacity: 1;
}


.loading-overlay {
    margin: 0 auto;
    background-color: #161d1f;
    backdrop-filter: blur(3px);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    z-index: 10;
    border-radius: inherit;
}



.spinner {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
}

.dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background-color: #1d455e;
    animation: bounce 1.4s infinite ease-in-out both;
}

.dot:nth-child(1) {
    animation-delay: -0.32s;
}

.dot:nth-child(2) {
    animation-delay: -0.16s;
}

@keyframes bounce {

    0%,
    80%,
    100% {
        transform: scale(0);
    }

    40% {
        transform: scale(1.0);
    }
}

.social-icons {
    display: flex;
    gap: 8px;
    align-items: center;
}

.social-icon {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.1);
    color: #fff;
    transition: all 0.2s ease;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.social-icon:hover {
    transform: translateY(-2px);
    border-color: currentColor;
}

.social-icon.facebook:hover {
    background: #1877f2;
    color: white;
    box-shadow: 0 4px 12px rgba(24, 119, 242, 0.3);
}

.social-icon.instagram:hover {
    background: #e4405f;
    color: white;
    box-shadow: 0 4px 12px rgba(228, 64, 95, 0.3);
}

.social-icon.x:hover {
    background: #000;
    color: white;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.social-icon.youtube:hover {
    background: #ff0000;
    color: white;
    box-shadow: 0 4px 12px rgba(255, 0, 0, 0.3);
}

/* Action Buttons - Đẹp và đồng bộ */
.action-buttons {
    display: flex;
    gap: 6px;
}

.btn-action {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(255, 255, 255, 0.05);
    color: rgba(255, 255, 255, 0.7);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
}

.btn-action:hover {
    transform: translateY(-2px);
}

.btn-edit:hover {
    background: #00aaff;
    color: white;
    border-color: #00aaff;
    box-shadow: 0 4px 12px rgba(0, 170, 255, 0.3);
}

.btn-view:hover {
    background: #00ffaa;
    color: #1d455e;
    border-color: #00ffaa;
    box-shadow: 0 4px 12px rgba(0, 255, 170, 0.3);
}

.btn-delete:hover {
    background: #ff4444;
    color: white;
    border-color: #ff4444;
    box-shadow: 0 4px 12px rgba(255, 68, 68, 0.3);
}

/* Checkbox và Pagination giữ nguyên */
.checkbox-col {
    width: 40px;
}

.table-checkbox {
    width: 18px;
    height: 18px;
    cursor: pointer;
    accent-color: #00aaff;
}

/* Pagination - Thêm vào cuối table nếu chưa có */
.pagination {
    padding: 12px 16px; 
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.pagination-info {
    color: rgba(255, 255, 255, 0.6);
    font-size: 14px;
}

.pagination-controls {
    display: flex;
    gap: 12px;
    align-items: center;
}

.pagination-btn {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(255, 255, 255, 0.05);
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
}

.pagination-btn:hover:not(:disabled) {
    background: #00aaff;
    border-color: #00aaff;
}

.pagination-btn:disabled {
    opacity: 0.3;
    cursor: not-allowed;
}

.pagination-current {
    font-weight: 600;
    color: #00aaff;
}


</style>