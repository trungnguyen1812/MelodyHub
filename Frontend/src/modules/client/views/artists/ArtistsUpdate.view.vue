<template>
  <div class="user-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <header class="topbar">
      <button class="back-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Artists
      </button>
      <div class="topbar-center">
        <span class="topbar-label">Edit Artist: {{ form.name }}</span>
      </div>
      <div style="width:90px"></div>
    </header>

    <div v-if="loading" class="loading-overlay">
      <div class="spinner-large"></div>
      <p>Loading artist details...</p>
    </div>

    <div v-else class="page-body">
      <!-- Left: form -->
      <div class="form-col">

        <!-- Identity -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Artist identity</h2>
              <p class="card-sub">Basic information and public identifiers</p>
            </div>
          </div>

          <div class="fields">
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel required">Artist Name</label>
                <input v-model="form.name" type="text" placeholder="e.g. Taylor Swift" class="fcontrol" />
              </div>
              <div class="field">
                <label class="flabel required">Slug</label>
                <input v-model="form.slug" type="text" class="fcontrol" disabled />
                <span class="fhint">Slug is constant once created</span>
              </div>
            </div>

            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Country</label>
                <select v-model="form.country" class="fcontrol">
                  <option value="">Select country</option>
                  <option value="USA">🇺🇸 United States</option>
                  <option value="UK">🇬🇧 United Kingdom</option>
                  <option value="Vietnam">🇻🇳 Vietnam</option>
                  <option value="Japan">🇯🇵 Japan</option>
                  <option value="Korea">🇰🇷 South Korea</option>
                  <option value="France">🇫🇷 France</option>
                  <option value="Germany">🇩🇪 Germany</option>
                </select>
              </div>
              <div class="field">
                <label class="flabel">Website</label>
                <input v-model="form.website" type="url" placeholder="https://artist.com" class="fcontrol" />
              </div>
            </div>
          </div>
        </div>

        <!-- Media & Bio -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                 <path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.81.81a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Media & biography</h2>
              <p class="card-sub">Visual branding and storytelling</p>
            </div>
          </div>

          <div class="fields">
            <div class="field">
              <label class="flabel">Biography</label>
              <textarea v-model="form.bio" rows="4" placeholder="Artist journey, career highlights..." class="fcontrol"></textarea>
              <span class="fhint">{{ form.bio?.length || 0 }}/1000 characters</span>
            </div>

            <div class="artist-media-grid">
              <!-- Avatar -->
              <div class="field">
                <label class="flabel">Profile Photo</label>
                <div class="avatar-uploader-box shadowed" @click="avatarInput?.click()">
                  <img :src="displayAvatar" class="avatar-img" />
                  <div class="uploader-overlay">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                      <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                      <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                    </svg>
                  </div>
                </div>
                <input type="file" ref="avatarInput" accept="image/*" @change="handleAvatarChange" style="display:none" />
                <span class="fhint">Square 1:1 · Max 5MB</span>
              </div>

              <!-- Banner -->
              <div class="field flex-1">
                <label class="flabel">Header Banner</label>
                <div class="banner-uploader-box shadowed" @click="bannerInput?.click()">
                  <img :src="displayBanner" class="banner-img" />
                  <div class="uploader-overlay">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                       <path fill-rule="evenodd" d="M1 5.25A2.25 2.25 0 0 1 3.25 3h13.5A2.25 2.25 0 0 1 19 5.25v9.5A2.25 2.25 0 0 1 16.75 17H3.25A2.25 2.25 0 0 1 1 14.75v-9.5ZM14 7a1 1 0 1 1-2 0 1 1 0 0 1 2 0Zm-10.75 7.25a.75.75 0 0 0 .75.75h12a.75.75 0 0 0 .75-.75v-.466c0-.527-.247-1.018-.671-1.332L12.5 9.5a.75.75 0 0 0-1.002.103l-1.92 2.24-2.15-1.72a.75.75 0 0 0-.965.03l-3 2.5a.75.75 0 0 0-.213.639v.208Z" clip-rule="evenodd" />
                    </svg>
                  </div>
                </div>
                <input type="file" ref="bannerInput" accept="image/*" @change="handleBannerChange" style="display:none" />
                <span class="fhint">Landscape · Max 10MB</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Social Links -->
        <div class="card">
          <div class="card-head">
             <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M19.902 4.098a3.75 3.75 0 0 0-5.304 0l-4.5 4.5a3.75 3.75 0 0 0 1.035 6.037.75.75 0 0 1-.646 1.353 5.25 5.25 0 0 1-1.449-8.45l4.5-4.5a5.25 5.25 0 1 1 7.424 7.424l-1.757 1.757a.75.75 0 1 1-1.06-1.06l1.757-1.757a3.75 3.75 0 0 0 0-5.304Zm-7.398 7.398a.75.75 0 0 1 1.06 0 5.25 5.25 0 0 1 1.449 8.45l-4.5 4.5a5.25 5.25 0 1 1-7.424-7.424l1.757-1.757a.75.75 0 1 1 1.06 1.06l-1.757 1.757a3.75 3.75 0 1 0 5.304 5.304l4.5-4.5a3.75 3.75 0 0 0-1.035-6.037.75.75 0 0 1 .646-1.353Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Social networks</h2>
              <p class="card-sub">Manage external links and presence</p>
            </div>
          </div>

          <div class="fields">
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Facebook</label>
                <div class="social-input-row">
                  <div class="social-icon fb">F</div>
                  <input v-model="form.facebook_url" type="url" placeholder="https://facebook.com/..." class="fcontrol" />
                </div>
              </div>
              <div class="field">
                <label class="flabel">Instagram</label>
                <div class="social-input-row">
                  <div class="social-icon ig">I</div>
                  <input v-model="form.instagram_url" type="url" placeholder="https://instagram.com/..." class="fcontrol" />
                </div>
              </div>
            </div>
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">X (Twitter)</label>
                <div class="social-input-row">
                  <div class="social-icon tw">X</div>
                  <input v-model="form.twitter_url" type="url" placeholder="https://twitter.com/..." class="fcontrol" />
                </div>
              </div>
              <div class="field">
                <label class="flabel">YouTube</label>
                <div class="social-input-row">
                  <div class="social-icon yt">Y</div>
                  <input v-model="form.youtube_url" type="url" placeholder="https://youtube.com/..." class="fcontrol" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Settings -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M11.078 2.25c-.917 0-1.699.663-1.85 1.567L9.05 4.889c-.02.12-.115.26-.297.348a7.493 7.493 0 0 0-.986.57c-.166.115-.334.126-.45.083L6.3 5.508a1.875 1.875 0 0 0-2.282.819l-.922 1.597a1.875 1.875 0 0 0 .432 2.385l.84.692c.095.078.17.229.154.43a7.598 7.598 0 0 0 0 1.139c.015.2-.059.352-.153.43l-.841.692a1.875 1.875 0 0 0-.432 2.385l.922 1.597a1.875 1.875 0 0 0 2.282.818l1.019-.382c.115-.043.283-.031.45.082.312.214.641.405.985.57.182.088.277.228.297.35l.178 1.071c.151.904.933 1.567 1.85 1.567h1.844c.916 0 1.699-.663 1.85-1.567l.178-1.072c.02-.12.114-.26.297-.349.344-.165.673-.356.985-.57.167-.114.335-.125.45-.082l1.02.382a1.875 1.875 0 0 0 2.28-.819l.923-1.597a1.875 1.875 0 0 0-.432-2.385l-.84-.692c-.095-.078-.17-.229-.154-.43a7.614 7.614 0 0 0 0-1.139c-.016-.2.059-.352.153-.43l.84-.692c.708-.582.891-1.59.433-2.385l-.922-1.597a1.875 1.875 0 0 0-2.282-.818l-1.02.382c-.114.043-.282.031-.449-.083a7.49 7.49 0 0 0-.985-.57c-.183-.087-.277-.227-.297-.348l-.179-1.072a1.875 1.875 0 0 0-1.85-1.567h-1.843ZM12 15.75a3.75 3.75 0 1 0 0-7.5 3.75 3.75 0 0 0 0 7.5Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Management settings</h2>
              <p class="card-sub">Verification and internal parameters</p>
            </div>
          </div>

          <div class="fields">
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Account Status</label>
                <div class="status-pills">
                  <button
                    v-for="s in statusOptions"
                    :key="s.value"
                    type="button"
                    class="status-pill"
                    :class="[s.color, { active: form.status === s.value }]"
                    @click="form.status = s.value"
                  >
                    <span class="spill-dot"></span>
                    {{ s.label }}
                  </button>
                </div>
              </div>
              <div class="field">
                <label class="flabel">Partner</label>
                <input v-model="form.partner_id" type="number" placeholder="Internal ID" class="fcontrol" />
              </div>
            </div>

            <div class="toggles-row">
              <div class="toggle-card" :class="{ active: form.verified }" @click="form.verified = !form.verified">
                <div class="toggle-info">
                  <span class="tc-label">Verified Artist</span>
                  <span class="tc-sub">Show official checkmark badge</span>
                </div>
                <div class="check-box">
                  <svg v-if="form.verified" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                    <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z" clip-rule="evenodd" />
                  </svg>
                </div>
              </div>

              <div class="toggle-card" :class="{ active: form.is_featured }" @click="form.is_featured = !form.is_featured">
                <div class="toggle-info">
                  <span class="tc-label">Featured Artist</span>
                  <span class="tc-sub">Promote on homepage/explore</span>
                </div>
                <div class="check-box">
                  <svg v-if="form.is_featured" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                     <path fill-rule="evenodd" d="M10.868 2.884c-.321-.772-1.415-.772-1.736 0l-1.83 4.401-4.753.381c-.833.067-1.171 1.107-.536 1.651l3.62 3.102-1.106 4.637c-.194.813.691 1.456 1.405 1.02L10 15.591l4.069 2.485c.713.436 1.598-.207 1.404-1.02l-1.106-4.637 3.62-3.102c.635-.544.297-1.584-.536-1.65l-4.752-.382-1.831-4.401Z" clip-rule="evenodd" />
                  </svg>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- SEO -->
        <div class="card">
          <div class="card-head">
             <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">SEO discovery</h2>
              <p class="card-sub">Optimize for search engine visibility</p>
            </div>
          </div>

          <div class="fields">
            <div class="field">
              <label class="flabel">SEO Title</label>
              <input v-model="form.seo_title" type="text" placeholder="Artist | Brand Name" class="fcontrol" />
            </div>
            <div class="field">
               <label class="flabel">SEO Keywords</label>
              <input v-model="form.seo_keywords" type="text" placeholder="artist, pop, vocal, music" class="fcontrol" />
            </div>
            <div class="field">
              <label class="flabel">SEO Description</label>
              <textarea v-model="form.seo_description" rows="2" placeholder="Brief metadata description..." class="fcontrol"></textarea>
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="form-actions">
          <button type="button" class="btn ghost" @click="$router.back()" :disabled="submitting">Cancel</button>
          <button type="button" class="btn primary" @click="handleSubmit" :disabled="submitting">
            <span v-if="submitting" class="btn-spinner"></span>
            <template v-else>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                 <path d="M10.75 4.75a.75.75 0 0 0-1.5 0v4.5h-4.5a.75.75 0 0 0 0 1.5h4.5v4.5a.75.75 0 0 0 1.5 0v-4.5h4.5a.75.75 0 0 0 0-1.5h-4.5v-4.5Z" />
              </svg>
              Save Changes
            </template>
          </button>
        </div>
      </div>

      <!-- Right: preview -->
      <div class="preview-col">
        <div class="preview-sticky">
          <p class="preview-label">Artist profile preview</p>

          <!-- Artist card -->
          <div class="artist-preview-card">
             <div class="apc-banner">
               <img :src="displayBanner" class="apc-banner-img" />
             </div>
             <div class="apc-body">
               <div class="apc-avatar-wrap shadowed">
                 <img :src="displayAvatar" class="apc-avatar-img" />
               </div>
               <div class="apc-info">
                 <div class="apc-name-row">
                   <span class="apc-name">{{ form.name || 'Artist Name' }}</span>
                   <svg v-if="form.verified" class="apc-verified-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#00aaff" width="16" height="16">
                      <path fill-rule="evenodd" d="M16.403 12.652a3 3 0 0 0 0-5.304 3 3 0 0 0-3.75-3.751 3 3 0 0 0-5.305 0 3 3 0 0 0-3.751 3.75 3 3 0 0 0 0 5.305 3 3 0 0 0 3.75 3.751 3 3 0 0 0 5.305 0 3 3 0 0 0 3.751-3.75Zm-2.546-4.46a.75.75 0 0 0-1.214-.883L9.16 12.1l-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l3-4.128Z" clip-rule="evenodd" />
                   </svg>
                 </div>
                 <span class="apc-slug">@{{ form.slug || 'url-slug' }}</span>
               </div>
               <div class="apc-badges">
                 <span class="apc-tag" :class="form.status">{{ form.status }}</span>
                 <span v-if="form.is_featured" class="apc-tag featured">Featured</span>
                 <span v-if="form.country" class="apc-tag country">{{ form.country }}</span>
               </div>
             </div>
          </div>

          <!-- Quick Recap -->
          <div class="field-summary">
            <div class="fs-row">
              <span class="fs-key">ID</span>
              <span class="fs-val">#{{ route.params.id }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Last Sync</span>
              <span class="fs-val">{{ new Date().toLocaleTimeString() }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Socials</span>
              <span class="fs-val">{{ socialCount }} linked</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref ,watch , onMounted ,computed} from 'vue'
import router from "@/modules/router";
import { useRoute } from "vue-router";
import type { CreateArtistPayload } from "@/modules/client/interfaces/artists/create-artist.payload";
import { useArtistStore , getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
import { usePartnerStore } from '@/modules/client/stores/partners/partnersStore';
import { useNotificationStore } from "@/store/notificationStore";

const notificationStore = useNotificationStore();
const artistStore = useArtistStore();
const partnerStore = usePartnerStore();
const loading = ref(false);

// Media refs
const avatarPreview = ref<string>('')
const bannerPreview = ref<string>('')
const avatarInput = ref<HTMLInputElement | null>(null)
const bannerInput = ref<HTMLInputElement | null>(null)
const avatarFile = ref<File | null>(null);
const bannerFile = ref<File | null>(null);
const defaultAvatar = 'https://via.placeholder.com/500?text=Artist'
const defaultBanner = 'https://via.placeholder.com/1920x500?text=Banner'
const errors = reactive<Record<string, string>>({});
const error = ref<string | null>(null);
const route = useRoute();
const submitting = ref(false);


const statusOptions = [
  { value: 'active', label: 'Active', color: 'green' },
  { value: 'inactive', label: 'Inactive', color: 'gray' },
  { value: 'pending', label: 'Pending', color: 'amber' },
  { value: 'rejected', label: 'Rejected', color: 'red' },
] as const

// Form
const form = reactive<CreateArtistPayload>({
    name: "",
    slug: "",
    bio: "",
    avatar: null,
    banner: null,
    country: "",
    website: "",
    facebook_url: "",
    instagram_url: "",
    twitter_url: "",
    youtube_url: "",
    verified: false,
    is_featured: false,
    partner_id: null,
    status: "active",
    seo_title: "",
    seo_description: "",
    seo_keywords: "",
});

// Methods
// Load user data
const loadArtistData = async () => {
    try {
        loading.value = true;

        const id = Number(route.params.id);

        const res = await artistStore.fetchShow(id);

        if (res && res.data) {
            Object.assign(form, res.data.data);
        }

    } catch (error: any) {

        const status = error?.response?.status;

        if (status === 404) {
            router.push('/404');
        } else if (status === 401) {
            router.push('/login');
        } else {
            console.error('Error loading artist:', error);
        }

    } finally {
        loading.value = false;
    }
};

const handleAvatarChange = (event: Event) => {
    const target = event.target as HTMLInputElement;
    const file = target.files?.[0];
    
    if (!file) return;
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
        notificationStore.notify('Please select an image file!', 'error');
        target.value = '';
        return;
    }
    
    // Validate file size (max 10MB)
    if (file.size > 10 * 1024 * 1024) {
        notificationStore.notify('File too large! Maximum 10MB', 'error');
        target.value = '';
        return;
    }
    
    // Check image resolution
    const img = new Image();
    const objectUrl = URL.createObjectURL(file);
    
    img.onload = () => {
        URL.revokeObjectURL(objectUrl);
        avatarFile.value = file;
    };
    
    img.onerror = () => {
        URL.revokeObjectURL(objectUrl);
        notificationStore.notify('Cannot read image file!', 'error');
        target.value = '';
    };
    
    img.src = objectUrl;
};

const handleBannerChange = (event: Event) => {
    const target = event.target as HTMLInputElement;
    const file = target.files?.[0];
    
    if (!file) return;
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
        notificationStore.notify('Please select an image file!', 'error');
        target.value = '';
        return;
    }
    
    // Validate file size (max 15MB for banner)
    if (file.size > 15 * 1024 * 1024) {
        notificationStore.notify('File too large! Maximum 15MB', 'error');
        target.value = '';
        return;
    }
    
    // Check image resolution
    const img = new Image();
    const objectUrl = URL.createObjectURL(file);
    
    img.onload = () => {
        URL.revokeObjectURL(objectUrl);
        bannerFile.value = file;
    };
    
    img.onerror = () => {
        URL.revokeObjectURL(objectUrl);
        notificationStore.notify('Cannot read image file!', 'error');
        target.value = '';
    };
    
    img.src = objectUrl;
};

const socialCount = computed(() => {
  let count = 0;
  if(form.facebook_url) count++;
  if(form.instagram_url) count++;
  if(form.twitter_url) count++;
  if(form.youtube_url) count++;
  return count;
});

const handleSubmit = async () => {
    try {
        submitting.value = true;
        error.value = null;
        
        Object.keys(errors).forEach(key => delete errors[key]);
        
        const payload: CreateArtistPayload = { ...form };
        
        if (avatarInput.value) {
            payload.avatar = avatarFile.value;
        }
        if (bannerFile.value) {
            payload.banner = bannerFile.value;
        }
        
        // Remove empty strings
        Object.keys(payload).forEach(key => {
            if (key !== 'password' && key !== 'avatar' && key !== 'banner' && payload[key as keyof CreateArtistPayload] === '') {
                delete payload[key as keyof CreateArtistPayload];
            }
        });
        
        const id = Number(route.params.id);
        
        await artistStore.fetchUpdate(id, payload);
        
        notificationStore.notify("User updated successfully", "success");
        router.push({ name: "client.partner.artists" });
        
    } catch (error: any) {
        console.error('=== UPDATE ERROR ===', error.response?.data);
        
        if (error.response?.data?.errors) {
            Object.keys(error.response.data.errors).forEach(key => {
                errors[key] = error.response.data.errors[key][0];
            });
        } else {
            error.value = error.response?.data?.message || 'Failed to update user';
        }
    } finally {
        submitting.value = false;
    }
};

const displayAvatar = computed(() => {
    if (avatarFile.value) {
        return URL.createObjectURL(avatarFile.value);
    }
    
    if (form.avatar_url) {
        return getFullImageUrl(form.avatar_url);
    }
    
    return defaultAvatar;
});

const displayBanner = computed(()=>{
    if (bannerFile.value) {
        return URL.createObjectURL(bannerFile.value);
    }
    
    if (form.banner_url) {
        return getFullImageUrl(form.banner_url);
    }
    
    return defaultBanner;
});

onMounted(() => {
    loadArtistData();
});

function autoSlug(): void {
  form.slug = form.name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9\s-]/g, '')
    .trim()
    .replace(/\s+/g, '-')
}

watch(
    () => form.name,
    () => {
        autoSlug()
    }
)
</script>

<style scoped>
/* Ported from ArtistsAdd.view.vue with minor adjustments for absolute consistency */

/* ── Base ───────────────────────────────────────── */
.user-shell {
  min-height: 100vh; background: #080e14;
  font-family: 'DM Sans', 'Segoe UI', sans-serif; color: #e8edf2;
  position: relative;
}
.bg-grid {
  position: fixed; inset: 0; pointer-events: none; z-index: 0;
  background-image:
    linear-gradient(rgba(0,160,255,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,160,255,0.03) 1px, transparent 1px);
  background-size: 40px 40px;
}

/* ── Topbar ─────────────────────────────────────── */
.topbar {
  position: sticky; top: 0; z-index: 20;
  display: flex; align-items: center; justify-content: space-between;
  padding: 16px 28px; border-bottom: 1px solid rgba(255,255,255,0.06);
  background: rgba(8,14,20,0.85); backdrop-filter: blur(12px);
}
.back-btn {
  display: flex; align-items: center; gap: 6px; padding: 7px 14px;
  background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7); border-radius: 8px; cursor: pointer; font-size: 13px;
}
.topbar-center { flex: 1; margin-left: 24px; }
.topbar-label { font-size: 15px; font-weight: 600; color: rgba(255,255,255,0.5); }

/* ── Page Body ───────────────────────────────────── */
.page-body {
  position: relative; z-index: 1; display: grid;
  grid-template-columns: 1fr 320px; gap: 24px;
  max-width: 1100px; margin: 0 auto; padding: 28px 24px 60px;
}

.card {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px; padding: 24px; margin-bottom: 16px;
}
.card-head {
  display: flex; align-items: center; gap: 14px; margin-bottom: 22px;
  padding-bottom: 18px; border-bottom: 1px solid rgba(255,255,255,0.06);
}
.card-icon {
  width: 44px; height: 44px; border-radius: 12px; background: rgba(0,160,255,0.1);
  border: 1px solid rgba(0,160,255,0.2); display: flex; align-items: center; justify-content: center;
}
.card-title { font-size: 16px; font-weight: 600; color: #fff; margin:0 0 3px; }
.card-sub { font-size: 13px; color: rgba(255,255,255,0.4); margin:0; }

/* ── Form Controls ──────────────────────────────── */
.fields { display: flex; flex-direction: column; gap: 16px; }
.field { display: flex; flex-direction: column; gap: 6px; }
.field-row.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.flabel { font-size: 13px; font-weight: 500; color: rgba(255,255,255,0.6); }
.flabel.required::after { content: ' *'; color: #ff5555; }
.fcontrol {
  background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
  border-radius: 9px; padding: 10px 13px; color: #fff; font-size: 14px; width:100%; box-sizing: border-box;
}
.fcontrol:focus { outline: none; border-color: #00aaff; background: rgba(255,255,255,0.08); }
.fcontrol:disabled { opacity: 0.5; cursor: not-allowed; }
.fhint { font-size: 11px; color: rgba(255,255,255,0.3); }

/* Media Grid */
.artist-media-grid { display: flex; gap: 24px; align-items: flex-start; }
.avatar-uploader-box {
  width: 140px; height: 140px; border-radius: 50%; overflow: hidden; border: 2px dashed rgba(255,255,255,0.15); position: relative; cursor: pointer;
}
.banner-uploader-box {
  height: 140px; border-radius: 12px; overflow: hidden; border: 2px dashed rgba(255,255,255,0.15); position: relative; cursor: pointer; width: 100%;
}
.uploader-overlay {
  position: absolute; inset: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; opacity: 0; transition: 0.2s;
}
.avatar-uploader-box:hover .uploader-overlay, .banner-uploader-box:hover .uploader-overlay { opacity: 1; }
.avatar-img, .banner-img { width: 100%; height: 100%; object-fit: cover; }
.shadowed { box-shadow: 0 8px 30px rgba(0,0,0,0.4); }

/* Social */
.social-input-row { position: relative; }
.social-icon {
  position: absolute; left: 10px; top: 50%; transform: translateY(-50%);
  width: 24px; height: 24px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 800;
}
.social-icon.fb { background: #1877f2; color: #fff; }
.social-icon.ig { background: linear-gradient(45deg, #f09433, #e6683c, #dc2743, #cc2366, #bc1888); color: #fff; }
.social-icon.tw { background: #000; color: #fff; }
.social-icon.yt { background: #ff0000; color: #fff; }
.social-input-row .fcontrol { padding-left: 44px; }

/* Status Pills */
.status-pills { display: flex; flex-wrap: wrap; gap: 8px; }
.status-pill {
  display: flex; align-items: center; gap: 6px; padding: 7px 14px; border-radius: 100px;
  border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.5); font-size: 13px; cursor: pointer;
}
.spill-dot { width: 7px; height: 7px; border-radius: 50%; background: currentColor; opacity:0.5; }
.status-pill.active .spill-dot { opacity: 1; }
.status-pill.green.active { background: rgba(0,200,120,0.12); border-color: rgba(0,200,120,0.4); color: #00c87a; }
.status-pill.amber.active { background: rgba(250,200,0,0.1); border-color: rgba(250,200,0,0.35); color: #fac800; }
.status-pill.red.active { background: rgba(226,75,74,0.12); border-color: rgba(226,75,74,0.4); color: #e24b4a; }
.status-pill.gray.active { background: rgba(255,255,255,0.07); border-color: rgba(255,255,255,0.2); color: rgba(255,255,255,0.7); }

/* Toggles */
.toggles-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 12px; }
.toggle-card {
  display: flex; align-items: center; justify-content: space-between; padding: 14px 18px;
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; cursor: pointer; transition: 0.2s;
}
.toggle-card:hover { background: rgba(255,255,255,0.05); }
.toggle-card.active { border-color: #00aaff; background: rgba(0,160,255,0.05); }
.tc-label { display: block; font-size: 14px; font-weight: 600; color: #fff; }
.tc-sub { display: block; font-size: 11px; color: rgba(255,255,255,0.4); }
.check-box {
  width: 22px; height: 22px; border-radius: 6px; border: 2px solid rgba(255,255,255,0.1);
  display: flex; align-items: center; justify-content: center; color: #00aaff; transition: 0.2s;
}
.active .check-box { border-color: #00aaff; background: #00aaff; color: #000; }

/* ── Form Actions ──────────────────────────────── */
.form-actions { display: flex; justify-content: flex-end; gap: 12px; padding-top: 20px; }
.btn {
  display: flex; align-items: center; gap: 7px; padding: 10px 22px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: 0.2s;
}
.btn.ghost { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.6); }
.btn.primary { background: #00aaff; color: #000; }
.btn.primary:hover:not(:disabled) { background: #33bbff; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(0,170,255,0.35); }
.btn-spinner { width: 16px; height: 16px; border: 2px solid rgba(0,0,0,0.2); border-top-color: #000; border-radius: 50%; animation: spin 0.6s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Artist Preview Card ────────────────────────── */
.artist-preview-card {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; overflow: hidden;
}
.apc-banner { height: 100px; background: rgba(255,255,255,0.05); }
.apc-banner-img { width: 100%; height: 100%; object-fit: cover; }
.apc-body { padding: 0 20px 20px; margin-top: -30px; position: relative; }
.apc-avatar-wrap {
  width: 64px; height: 64px; border-radius: 50%; border: 3px solid #0f1216; overflow: hidden; background: #222; margin-bottom: 12px;
}
.apc-avatar-img { width: 100%; height: 100%; object-fit: cover; }
.apc-name-row { display: flex; align-items: center; gap: 6px; }
.apc-name { font-size: 16px; font-weight: 700; color: #fff; }
.apc-slug { font-size: 12px; color: rgba(255,255,255,0.4); display: block; margin-top: -2px; }
.apc-badges { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 12px; }
.apc-tag { font-size: 10px; padding: 2px 8px; border-radius: 100px; text-transform: capitalize; background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.5); }
.apc-tag.active { color: #00c87a; background: rgba(0,200,120,0.1); }
.apc-tag.featured { color: #fac800; background: rgba(250,200,0,0.1); }

.preview-col { position: relative; }
.preview-sticky { position: sticky; top: 80px; display: flex; flex-direction: column; gap: 12px; }
.preview-label { font-size: 11px; font-weight: 600; color: rgba(255,255,255,0.3); text-transform: uppercase; }

.field-summary { padding: 8px 16px; display: flex; flex-direction: column; gap: 8px; }
.fs-row { display: flex; justify-content: space-between; font-size: 12px; }
.fs-key { color: rgba(255,255,255,0.3); }
.fs-val { color: rgba(255,255,255,0.7); }

.loading-overlay { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 400px; gap: 16px; }
.spinner-large { width: 40px; height: 40px; border: 3px solid rgba(255,255,255,0.05); border-top-color: #00aaff; border-radius: 50%; animation: spin 1s linear infinite; }

@media (max-width: 900px) {
  .page-body { grid-template-columns: 1fr; }
  .preview-col { display: none; }
}
</style>