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
                        <!-- ── Skeleton Loading ── -->
                        <template v-if="loading">
                            <tr v-for="n in 8" :key="`skel-${n}`" class="skeleton-row">
                                <td class="user-cell">
                                    <div class="skel skel--avatar"></div>
                                    <div class="skel-text-col">
                                        <div class="skel skel--title"></div>
                                        <div class="skel skel--sub"></div>
                                    </div>
                                </td>
                                <td><div class="skel skel--sm"></div></td>
                                <td><div class="skel skel--sm"></div></td>
                                <td><div class="skel skel--md"></div></td>
                                <td><div class="skel skel--badge"></div></td>
                                <td><div class="skel skel--md"></div></td>
                                <td>
                                    <div class="social-skel">
                                        <div class="skel skel--icon"></div>
                                        <div class="skel skel--icon"></div>
                                        <div class="skel skel--icon"></div>
                                        <div class="skel skel--icon"></div>
                                    </div>
                                </td>
                                <td>
                                    <div class="action-skel">
                                        <div class="skel skel--btn"></div>
                                        <div class="skel skel--btn"></div>
                                        <div class="skel skel--btn"></div>
                                    </div>
                                </td>
                            </tr>
                        </template>

                        <!-- ── Data rows ── -->
                        <template v-else>
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
                                    <span>{{ artist.country }}</span>
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
                                        <button class="btn-action btn-edit" @click="viewUpdateArtist(artist.id)">
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
                        </template>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="!loading && artists.length > 0" class="pagination">
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

            <!-- Empty state -->
            <div v-if="!loading && artists.length === 0" class="empty-state">
                <div class="empty-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor" width="48" height="48">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z" />
                    </svg>
                </div>
                <p style="margin: 12px 0 4px; font-size: 16px; font-weight: 500;">No artists found</p>
                <p style="font-size: 14px; color: rgba(255,255,255,0.5); margin: 0;">Try adjusting your search or add a new artist.</p>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { usePartnerStore } from '@/modules/client/stores/partners/partnersStore'
import { useArtistStore, getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
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
const usePartner = usePartnerStore()

const { artists, loading } = storeToRefs(artistStore);

const CreateArtist = () => {
    router.push({ name: "client.partner.artists.add" });
}


function viewDetailArtist(id: number) {
    router.push({ name: "client.partner.artists.detail", params: { id } });
}

function viewUpdateArtist(id: number) {
    router.push({ name: "client.partner.artists.update", params: { id } });
}

async function deleteUser(id: number) {
    try {
        const result = await Swal.fire({
            title: 'Delete Artist',
            text: 'Are you sure you want to delete this artist? This action cannot be undone.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            reverseButtons: true,
        });

        if (!result.isConfirmed) return;

        loading.value = true;
        await artistStore.fetchDelete(id);
        await artistStore.fetchArtists();
        notificationStore.notify("Delete artist successful", "success");
        router.push({ name: "client.partner.artists" });

    } catch (error: any) {
        const err = error as { response?: { status?: number } }
        notificationStore.notify("Delete artist error", "error");
        if (err.response?.status === 404) router.push('/404')
        else if (err.response?.status === 401) router.push('/login')
    } finally {
        loading.value = false;
    }
}

const formatCompactNumber = (num: number | null): string => {
    if (num === null || num === undefined) return "0";
    return new Intl.NumberFormat("en", { notation: "compact", maximumFractionDigits: 1 }).format(num);
};

const formatDate = (dateString?: string): string => {
    if (!dateString) return '—'
    return new Date(dateString).toLocaleString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })
}

const totalPages = computed(() => Math.ceil(artists.value.length / itemsPerPage));
const paginationStart = computed(() => ((currentPage.value - 1) * itemsPerPage) + 1);
const paginationEnd = computed(() => Math.min(currentPage.value * itemsPerPage, artists.value.length));
const paginatedArtists = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    return artists.value.slice(start, start + itemsPerPage);
});

const loadInfoPartner = async () => {
    await usePartner.fetchPartnerInfo()
    const idPartner = usePartner.partner?.id
    if (idPartner) await artistStore.fetchGetAritistByIdPartner(idPartner)
}

const onSearch = () => {
    if (searchTimeout) clearTimeout(searchTimeout);
    searchTimeout = window.setTimeout(async () => {
        if (!keyword.value.trim()) {
            const idPartner = usePartner.partner?.id
            if (idPartner) await artistStore.fetchGetAritistByIdPartner(idPartner)
            return;
        }
        await artistStore.fetchSearchArtitst(keyword.value);
    }, 300);
}


onMounted(async () => {
    try {
        loadInfoPartner()
        await usePartner.fetchPartners()
    } catch {
        notificationStore.notify('Error fetching data', 'error')
    }
})
</script>

<style scoped>
/* ── Base ── */
.dashboard-container {
    height: auto;
    width: 100%;
    border-radius: 14px;
    margin-top: 7px;
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    display: flex;
    flex-direction: column;
    padding: 25px;
    position: relative;
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

/* ── Table Section ── */
.table-section {
    flex: 1;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(0, 170, 255, 0.2);
    display: flex;
    flex-direction: column;
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
}

.users-table td {
    padding: 15px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    vertical-align: middle;
}

/* ── Skeleton Loading ── */
@keyframes shimmer {
    0%   { background-position: -600px 0; }
    100% { background-position: 600px 0; }
}

.skel {
    border-radius: 6px;
    background: linear-gradient(
        90deg,
        rgba(255, 255, 255, 0.04) 25%,
        rgba(255, 255, 255, 0.10) 50%,
        rgba(255, 255, 255, 0.04) 75%
    );
    background-size: 600px 100%;
    animation: shimmer 1.5s infinite linear;
}

.skeleton-row td {
    padding: 12px 15px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.skeleton-row .user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.skel-text-col {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.skel--avatar  { width: 40px; height: 40px; border-radius: 50%; flex-shrink: 0; }
.skel--title   { width: 90px;  height: 13px; }
.skel--sub     { width: 55px;  height: 11px; }
.skel--sm      { width: 48px;  height: 13px; }
.skel--md      { width: 80px;  height: 13px; }
.skel--badge   { width: 65px;  height: 22px; border-radius: 20px; }
.skel--icon    { width: 32px;  height: 32px; border-radius: 8px; flex-shrink: 0; }
.skel--btn     { width: 32px;  height: 32px; border-radius: 8px; flex-shrink: 0; }

.social-skel,
.action-skel {
    display: flex;
    gap: 6px;
    align-items: center;
}

/* ── Avatar & User Cell ── */
.user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    overflow: hidden;
    border-radius: 50%;
    background: linear-gradient(135deg, #00aaff, #00ffaa);
    flex-shrink: 0;
}

.avatar-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
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

/* ── Status Badge ── */
.status-badge {
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
    display: inline-block;
    white-space: nowrap;
    background: rgba(153, 153, 153, 0.2);
    color: #cccccc;
    border: 1px solid rgba(153, 153, 153, 0.3);
}

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

/* ── Social Icons ── */
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

.social-icon:hover { transform: translateY(-2px); border-color: currentColor; }
.social-icon.facebook:hover { background: #1877f2; color: white; box-shadow: 0 4px 12px rgba(24,119,242,0.3); }
.social-icon.instagram:hover { background: #e4405f; color: white; box-shadow: 0 4px 12px rgba(228,64,95,0.3); }
.social-icon.x:hover { background: #000; color: white; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }
.social-icon.youtube:hover { background: #ff0000; color: white; box-shadow: 0 4px 12px rgba(255,0,0,0.3); }

/* ── Action Buttons ── */
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

.btn-action:hover { transform: translateY(-2px); }
.btn-edit:hover   { background: #00aaff; color: white; border-color: #00aaff; box-shadow: 0 4px 12px rgba(0,170,255,0.3); }
.btn-view:hover   { background: #00ffaa; color: #1d455e; border-color: #00ffaa; box-shadow: 0 4px 12px rgba(0,255,170,0.3); }
.btn-delete:hover { background: #ff4444; color: white; border-color: #ff4444; box-shadow: 0 4px 12px rgba(255,68,68,0.3); }

/* ── Back Button ── */
.btn-view-all {
    background: transparent;
    border: 1px solid rgba(0, 170, 255, 0.5);
    color: #00aaff;
    padding: 8px 16px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 6px;
}

.btn-view-all:hover {
    background: rgba(0, 170, 255, 0.1);
}

/* ── Pagination ── */
.pagination {
    padding: 12px 16px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 8px;
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

/* ── Empty State ── */
.empty-state {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 60px 40px;
    color: rgba(255, 255, 255, 0.5);
    text-align: center;
}

/* ── Scrollbar ── */
.table-container::-webkit-scrollbar { width: 6px; }
.table-container::-webkit-scrollbar-thumb { background: rgba(0, 170, 255, 0.6); border-radius: 3px; }
.table-container::-webkit-scrollbar-track { background: transparent; }

/* ── Responsive ── */
@media (max-width: 1024px) {
    .header-section { flex-direction: column; align-items: flex-start; gap: 20px; }
    .header-actions { width: 100%; justify-content: space-between; }
    .search-box input { width: 200px; }
}

@media (max-width: 768px) {
    .dashboard-container { padding: 15px; }
    .header-actions { flex-direction: column; gap: 15px; align-items: flex-start; }
    .search-box input { width: 100%; }
    .users-table { display: block; overflow-x: auto; }
    .table-section .section-header { flex-direction: column; align-items: flex-start; gap: 15px; }
}

@media (max-width: 480px) {
    .title-container h1 { font-size: 24px; }
    .users-table th, .users-table td { padding: 8px; font-size: 13px; }
    .btn-action { width: 28px; height: 28px; }
    .status-badge { padding: 4px 8px; font-size: 11px; }
}
</style>