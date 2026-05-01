<template>
  <div class="admin-settings">
    <!-- Header -->
    <div class="settings-header">
      <div>
        <h1 class="settings-title">Settings</h1>
        <p class="settings-subtitle">Manage system configurations, roles and subscription plans</p>
      </div>
    </div>

    <!-- Tab Navigation -->
    <div class="settings-tabs">
      <button
        v-for="tab in tabs"
        :key="tab.id"
        class="tab-btn"
        :class="{ active: activeTab === tab.id }"
        @click="activeTab = tab.id"
      >
        <span v-html="tab.icon" class="tab-icon-wrap"></span>
        {{ tab.label }}
      </button>
    </div>

    <!-- Tab Content -->
    <div class="settings-content">

      <!-- ══════════════════════════════════════
           TAB: PARTNER TYPES
      ══════════════════════════════════════ -->
      <div v-if="activeTab === 'partner-types'" class="tab-pane">
        <div class="pane-header">
          <div>
            <h2>Partner Types</h2>
            <p>Manage partner categories and their default configurations</p>
          </div>
          <button class="btn-primary" @click="openPartnerTypeModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Add Type
          </button>
        </div>

        <div v-if="ptLoading" class="loading-row">
          <div class="spinner"></div> Loading...
        </div>

        <div v-else class="table-wrapper">
          <table class="data-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Code</th>
                <th>Revenue Share</th>
                <th>Frequency</th>
                <th>Permissions</th>
                <th>Partners</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="pt in partnerTypes" :key="pt.id">
                <td>
                  <div class="cell-name">{{ pt.name }}</div>
                  <div class="cell-sub">{{ pt.description || '—' }}</div>
                </td>
                <td><code class="code-tag">{{ pt.code }}</code></td>
                <td><span class="highlight">{{ pt.default_revenue_share }}%</span></td>
                <td class="capitalize">{{ pt.default_payment_frequency }}</td>
                <td>
                  <div class="perm-chips">
                    <span v-if="pt.can_upload_songs"   class="chip chip--green">Upload Songs</span>
                    <span v-if="pt.can_manage_artists" class="chip chip--blue">Manage Artists</span>
                    <span v-if="pt.can_book_ads"       class="chip chip--purple">Book Ads</span>
                  </div>
                </td>
                <td>{{ pt.partners_count ?? 0 }}</td>
                <td>
                  <button
                    class="toggle-pill"
                    :class="pt.is_active ? 'on' : 'off'"
                    @click="togglePartnerType(pt)"
                  >
                    {{ pt.is_active ? 'Active' : 'Inactive' }}
                  </button>
                </td>
                <td class="actions">
                  <button class="action-btn edit" title="Edit" @click="openPartnerTypeModal(pt)">
                     <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                      </svg>
                  </button>
                  <button
                    class="action-btn delete"
                    title="Delete"
                    @click="deletePartnerType(pt)"
                    :disabled="(pt.partners_count ?? 0) > 0"
                  >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                      </svg>
                  </button>
                </td>
              </tr>
              <tr v-if="!partnerTypes.length">
                <td colspan="8" class="empty-cell">No partner types found</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- ══════════════════════════════════════
           TAB: ROLES
      ══════════════════════════════════════ -->
      <div v-if="activeTab === 'roles'" class="tab-pane">
        <div class="pane-header">
          <div>
            <h2>User Roles</h2>
            <p>Manage roles and their permission sets</p>
          </div>
          <button class="btn-primary" @click="openRoleModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Create Role
          </button>
        </div>

        <div v-if="roleLoading" class="loading-row">
          <div class="spinner"></div> Loading...
        </div>

        <div v-else class="roles-grid">
          <div v-for="role in roles" :key="role.id" class="role-card">
            <div class="role-card__header">
              <div class="role-icon" :style="{ background: roleColor(role.level) }">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                  <circle cx="12" cy="7" r="4"/>
                </svg>
              </div>
              <div class="role-card__meta">
                <h3>{{ role.display_name }}</h3>
                <code class="code-tag">{{ role.name }}</code>
              </div>
              <div class="role-card__badges">
                <span v-if="role.is_system" class="chip chip--orange">System</span>
                <span class="chip chip--gray">Lv.{{ role.level }}</span>
                <span class="chip chip--blue">{{ role.users_count ?? 0 }} users</span>
              </div>
            </div>
            <p class="role-desc">{{ role.description || 'No description' }}</p>
            <div class="role-perms">
              <span v-for="perm in (role.permissions || []).slice(0, 6)" :key="perm.id" class="perm-tag">
                {{ perm.display_name || perm.name }}
              </span>
              <span v-if="(role.permissions || []).length > 6" class="perm-tag perm-tag--more">
                +{{ role.permissions.length - 6 }} more
              </span>
              <span v-if="!(role.permissions || []).length" class="perm-tag perm-tag--empty">No permissions</span>
            </div>
            <div class="role-card__actions">
              <button class="btn-outline" @click="openRoleModal(role)">Edit</button>
              <button
                class="btn-outline delete"
                @click="deleteRole(role)"
                :disabled="role.is_system || (role.users_count ?? 0) > 0"
              >Delete</button>
            </div>
          </div>
          <div v-if="!roles.length" class="empty-card">No roles found</div>
        </div>
      </div>

      <!-- ══════════════════════════════════════
           TAB: SUBSCRIPTION PLANS
      ══════════════════════════════════════ -->
      <div v-if="activeTab === 'subscription-plans'" class="tab-pane">
        <div class="pane-header">
          <div>
            <h2>Subscription Plans</h2>
            <p>Manage pricing plans and subscription tiers</p>
          </div>
          <button class="btn-primary" @click="openPlanModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Add Plan
          </button>
        </div>

        <div v-if="planLoading" class="loading-row">
          <div class="spinner"></div> Loading...
        </div>

        <div v-else class="plans-grid">
          <div
            v-for="plan in plans"
            :key="plan.id"
            class="plan-card"
            :class="{ 'plan-card--featured': plan.is_featured }"
          >
            <div v-if="plan.is_featured" class="featured-badge">⭐ Featured</div>

            <div class="plan-card__header">
              <div class="plan-name-row">
                <h3>{{ plan.display_name }}</h3>
                <button
                  class="toggle-pill"
                  :class="plan.is_active ? 'on' : 'off'"
                  @click="togglePlan(plan)"
                >
                  {{ plan.is_active ? 'Active' : 'Inactive' }}
                </button>
              </div>
              <div class="plan-price">
                <span class="price-amount">{{ formatPrice(plan.price, plan.currency) }}</span>
                <span class="price-period">/ {{ plan.duration_days }}d</span>
              </div>
              <div v-if="plan.original_price && plan.original_price > plan.price" class="price-original">
                Was {{ formatPrice(plan.original_price, plan.currency) }}
              </div>
            </div>

            <p class="plan-desc">{{ plan.description || '—' }}</p>

            <div class="plan-features">
              <div class="feature-row">
                <span class="feature-label">Audio Quality</span>
                <span class="feature-val quality" :class="`quality--${plan.audio_quality}`">{{ plan.audio_quality }}</span>
              </div>
              <div class="feature-row">
                <span class="feature-label">Devices</span>
                <span class="feature-val">{{ plan.max_devices ?? '∞' }}</span>
              </div>
              <div class="feature-row">
                <span class="feature-label">Downloads</span>
                <span class="feature-val">{{ plan.max_offline_downloads ?? '∞' }}</span>
              </div>
              <div class="feature-row">
                <span class="feature-label">Subscribers</span>
                <span class="feature-val highlight">{{ plan.user_subscriptions_count ?? 0 }}</span>
              </div>
            </div>

            <div class="plan-toggles">
              <span v-if="plan.ads_free"                          class="chip chip--green">Ad-free</span>
              <span v-if="plan.can_download"                      class="chip chip--blue">Download</span>
              <span v-if="plan.can_skip_unlimited"                class="chip chip--blue">Unlimited Skip</span>
              <span v-if="plan.priority_support"                  class="chip chip--purple">Priority Support</span>
              <span v-if="plan.early_access"                      class="chip chip--purple">Early Access</span>
              <span v-if="plan.can_create_collaborative_playlist" class="chip chip--gray">Collab Playlist</span>
            </div>

            <div class="plan-card__actions">
              <button class="btn-outline" @click="openPlanModal(plan)">Edit</button>
              <button
                class="btn-outline delete"
                @click="deletePlan(plan)"
                :disabled="(plan.user_subscriptions_count ?? 0) > 0"
              >Delete</button>
            </div>
          </div>
          <div v-if="!plans.length" class="empty-card">No subscription plans found</div>
        </div>
      </div>
    </div>

    <!-- ══════════════════════════════════════
         MODAL: PARTNER TYPE
    ══════════════════════════════════════ -->
    <Teleport to="body">
      <Transition name="modal-fade">
        <div v-if="showPTModal" class="s-modal-overlay" @click.self="showPTModal = false">
          <div class="s-modal">
            <div class="s-modal-header">
              <h3>{{ editingPT ? 'Edit Partner Type' : 'New Partner Type' }}</h3>
              <button class="s-modal-close" @click="showPTModal = false">✕</button>
            </div>
            <div class="s-modal-body">
              <div class="s-form-grid">
                <div class="s-form-group">
                  <label>Name <span class="s-req">*</span></label>
                  <input v-model="ptForm.name" class="s-form-input" placeholder="e.g. Music Distribution" />
                </div>
                <div class="s-form-group">
                  <label>Code <span class="s-req">*</span></label>
                  <input v-model="ptForm.code" class="s-form-input" placeholder="e.g. music_distribution" />
                </div>
                <div class="s-form-group s-form-group--full">
                  <label>Description</label>
                  <textarea v-model="ptForm.description" class="s-form-input s-form-textarea" rows="2" />
                </div>
                <div class="s-form-group">
                  <label>Revenue Share (%) <span class="s-req">*</span></label>
                  <input v-model.number="ptForm.default_revenue_share" type="number" min="0" max="100" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Payment Frequency <span class="s-req">*</span></label>
                  <select v-model="ptForm.default_payment_frequency" class="s-form-input">
                    <option value="monthly">Monthly</option>
                    <option value="quarterly">Quarterly</option>
                    <option value="yearly">Yearly</option>
                  </select>
                </div>
                <div class="s-form-group">
                  <label>Payment Threshold <span class="s-req">*</span></label>
                  <input v-model.number="ptForm.default_payment_threshold" type="number" min="0" class="s-form-input" />
                </div>
                <div class="s-form-group s-form-group--full">
                  <label class="s-label-section">Permissions</label>
                  <div class="s-checkbox-row">
                    <label class="s-checkbox-label">
                      <input type="checkbox" v-model="ptForm.can_upload_songs" /> Can Upload Songs
                    </label>
                    <label class="s-checkbox-label">
                      <input type="checkbox" v-model="ptForm.can_manage_artists" /> Can Manage Artists
                    </label>
                    <label class="s-checkbox-label">
                      <input type="checkbox" v-model="ptForm.can_book_ads" /> Can Book Ads
                    </label>
                    <label class="s-checkbox-label">
                      <input type="checkbox" v-model="ptForm.is_active" /> Active
                    </label>
                  </div>
                </div>
              </div>
              <div v-if="modalError" class="s-modal-error">{{ modalError }}</div>
            </div>
            <div class="s-modal-footer">
              <button class="btn-ghost" @click="showPTModal = false">Cancel</button>
              <button class="btn-primary" @click="savePT" :disabled="modalLoading">
                <span v-if="modalLoading" class="spinner-sm"></span>
                {{ editingPT ? 'Save Changes' : 'Create' }}
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- ══════════════════════════════════════
         MODAL: ROLE
    ══════════════════════════════════════ -->
    <Teleport to="body">
      <Transition name="modal-fade">
        <div v-if="showRoleModal" class="s-modal-overlay" @click.self="showRoleModal = false">
          <div class="s-modal s-modal--wide">
            <div class="s-modal-header">
              <h3>{{ editingRole ? 'Edit Role' : 'New Role' }}</h3>
              <button class="s-modal-close" @click="showRoleModal = false">✕</button>
            </div>
            <div class="s-modal-body">
              <div class="s-form-grid">
                <div class="s-form-group">
                  <label>Name <span class="s-req">*</span></label>
                  <input v-model="roleForm.name" class="s-form-input" placeholder="e.g. content_manager" />
                </div>
                <div class="s-form-group">
                  <label>Display Name <span class="s-req">*</span></label>
                  <input v-model="roleForm.display_name" class="s-form-input" placeholder="e.g. Content Manager" />
                </div>
                <div class="s-form-group">
                  <label>Level <span class="s-req">*</span></label>
                  <input v-model.number="roleForm.level" type="number" min="0" class="s-form-input" />
                </div>
                <div class="s-form-group s-form-group--full">
                  <label>Description</label>
                  <textarea v-model="roleForm.description" class="s-form-input s-form-textarea" rows="2" />
                </div>
              </div>

              <!-- Permissions -->
              <div class="s-perm-section">
                <label class="s-label-section">Permissions</label>
                <div v-if="permLoading" class="loading-row"><div class="spinner"></div></div>
                <div v-else class="s-perm-groups">
                  <div v-for="(perms, module) in groupedPermissions" :key="module" class="s-perm-group">
                    <div class="s-perm-group__header">
                      <label class="s-checkbox-label">
                        <input
                          type="checkbox"
                          :checked="isModuleChecked(perms)"
                          :indeterminate="isModuleIndeterminate(perms)"
                          @change="toggleModule(perms, $event)"
                        />
                        <strong>{{ module }}</strong>
                      </label>
                    </div>
                    <div class="s-perm-group__items">
                      <label v-for="perm in perms" :key="perm.id" class="s-checkbox-label">
                        <input type="checkbox" :value="perm.id" v-model="roleForm.permissions" />
                        {{ perm.display_name || perm.name }}
                      </label>
                    </div>
                  </div>
                </div>
              </div>

              <div v-if="modalError" class="s-modal-error">{{ modalError }}</div>
            </div>
            <div class="s-modal-footer">
              <button class="btn-ghost" @click="showRoleModal = false">Cancel</button>
              <button class="btn-primary" @click="saveRole" :disabled="modalLoading">
                <span v-if="modalLoading" class="spinner-sm"></span>
                {{ editingRole ? 'Save Changes' : 'Create' }}
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- ══════════════════════════════════════
         MODAL: SUBSCRIPTION PLAN
    ══════════════════════════════════════ -->
    <Teleport to="body">
      <Transition name="modal-fade">
        <div v-if="showPlanModal" class="s-modal-overlay" @click.self="showPlanModal = false">
          <div class="s-modal s-modal--wide">
            <div class="s-modal-header">
              <h3>{{ editingPlan ? 'Edit Plan' : 'New Subscription Plan' }}</h3>
              <button class="s-modal-close" @click="showPlanModal = false">✕</button>
            </div>
            <div class="s-modal-body">
              <div class="s-form-grid">
                <div class="s-form-group">
                  <label>Name <span class="s-req">*</span></label>
                  <input v-model="planForm.name" class="s-form-input" placeholder="e.g. premium" />
                </div>
                <div class="s-form-group">
                  <label>Display Name <span class="s-req">*</span></label>
                  <input v-model="planForm.display_name" class="s-form-input" placeholder="e.g. Premium" />
                </div>
                <div class="s-form-group">
                  <label>Price <span class="s-req">*</span></label>
                  <input v-model.number="planForm.price" type="number" min="0" step="0.01" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Original Price</label>
                  <input v-model.number="planForm.original_price" type="number" min="0" step="0.01" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Currency <span class="s-req">*</span></label>
                  <select v-model="planForm.currency" class="s-form-input">
                    <option value="VND">VND</option>
                    <option value="USD">USD</option>
                  </select>
                </div>
                <div class="s-form-group">
                  <label>Duration (days) <span class="s-req">*</span></label>
                  <input v-model.number="planForm.duration_days" type="number" min="1" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Trial Days</label>
                  <input v-model.number="planForm.trial_days" type="number" min="0" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Audio Quality <span class="s-req">*</span></label>
                  <select v-model="planForm.audio_quality" class="s-form-input">
                    <option value="standard">Standard</option>
                    <option value="high">High</option>
                    <option value="lossless">Lossless</option>
                  </select>
                </div>
                <div class="s-form-group">
                  <label>Max Devices</label>
                  <input v-model.number="planForm.max_devices" type="number" min="1" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Max Offline Downloads</label>
                  <input v-model.number="planForm.max_offline_downloads" type="number" min="0" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Max Playlists</label>
                  <input v-model.number="planForm.max_playlists" type="number" min="0" class="s-form-input" />
                </div>
                <div class="s-form-group">
                  <label>Sort Order</label>
                  <input v-model.number="planForm.sort_order" type="number" min="0" class="s-form-input" />
                </div>
                <div class="s-form-group s-form-group--full">
                  <label>Description</label>
                  <textarea v-model="planForm.description" class="s-form-input s-form-textarea" rows="2" />
                </div>
                <div class="s-form-group s-form-group--full">
                  <label class="s-label-section">Features</label>
                  <div class="s-checkbox-row">
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.ads_free" /> Ad-free</label>
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.can_download" /> Can Download</label>
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.can_skip_unlimited" /> Unlimited Skip</label>
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.can_create_collaborative_playlist" /> Collab Playlist</label>
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.priority_support" /> Priority Support</label>
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.early_access" /> Early Access</label>
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.is_active" /> Active</label>
                    <label class="s-checkbox-label"><input type="checkbox" v-model="planForm.is_featured" /> Featured</label>
                  </div>
                </div>
              </div>
              <div v-if="modalError" class="s-modal-error">{{ modalError }}</div>
            </div>
            <div class="s-modal-footer">
              <button class="btn-ghost" @click="showPlanModal = false">Cancel</button>
              <button class="btn-primary" @click="savePlan" :disabled="modalLoading">
                <span v-if="modalLoading" class="spinner-sm"></span>
                {{ editingPlan ? 'Save Changes' : 'Create' }}
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue'
import settingsService from '@/modules/admin/services/settings/settings.service'
import { useNotificationStore } from '@/store/notificationStore'
import Swal from 'sweetalert2'

const notify = useNotificationStore()

// ── Tabs ───────────────────────────────────────────────────
const activeTab = ref('partner-types')
const tabs = [
  {
    id: 'partner-types',
    label: 'Partner Types',
    icon: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="2" width="16" height="20" rx="2"/><line x1="8" y1="7" x2="16" y2="7"/><line x1="8" y1="11" x2="16" y2="11"/><line x1="8" y1="15" x2="12" y2="15"/></svg>',
  },
  {
    id: 'roles',
    label: 'Roles',
    icon: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>',
  },
  {
    id: 'subscription-plans',
    label: 'Subscription Plans',
    icon: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>',
  },
]

// ── Helpers ─────────────────────────────────────────────────
const roleColors = ['#ef4444','#f97316','#eab308','#22c55e','#3b82f6','#8b5cf6','#ec4899']
const roleColor = (level: number) => roleColors[level % roleColors.length]

const formatPrice = (price: number, currency: string) => {
  if (currency === 'VND') return new Intl.NumberFormat('vi-VN').format(price) + ' ₫'
  return new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(price)
}

// ══════════════════════════════════════════════════════════════
// PARTNER TYPES
// ══════════════════════════════════════════════════════════════
const partnerTypes = ref<any[]>([])
const ptLoading    = ref(false)
const showPTModal  = ref(false)
const editingPT    = ref<any>(null)
const modalLoading = ref(false)
const modalError   = ref('')

const ptFormDefault = () => ({
  code: '', name: '', description: '',
  can_upload_songs: false, can_manage_artists: false, can_book_ads: false,
  default_revenue_share: 70,
  default_payment_frequency: 'monthly' as 'monthly' | 'quarterly' | 'yearly',
  default_payment_threshold: 100,
  is_active: true,
})
const ptForm = reactive(ptFormDefault())

const loadPartnerTypes = async () => {
  ptLoading.value = true
  try {
    const { data } = await settingsService.getPartnerTypes()
    partnerTypes.value = data.data ?? []
  } catch { notify.notify('Failed to load partner types', 'error') }
  finally { ptLoading.value = false }
}

const openPartnerTypeModal = (pt?: any) => {
  modalError.value = ''
  editingPT.value = pt ?? null
  if (pt) {
    Object.assign(ptForm, {
      code: pt.code, name: pt.name, description: pt.description ?? '',
      can_upload_songs: pt.can_upload_songs, can_manage_artists: pt.can_manage_artists,
      can_book_ads: pt.can_book_ads,
      default_revenue_share: pt.default_revenue_share,
      default_payment_frequency: pt.default_payment_frequency,
      default_payment_threshold: pt.default_payment_threshold,
      is_active: pt.is_active,
    })
  } else {
    Object.assign(ptForm, ptFormDefault())
  }
  showPTModal.value = true
}

const savePT = async () => {
  modalError.value = ''
  if (!ptForm.name || !ptForm.code) { modalError.value = 'Name and Code are required'; return }
  modalLoading.value = true
  try {
    if (editingPT.value) {
      await settingsService.updatePartnerType(editingPT.value.id, { ...ptForm })
      notify.notify('Partner type updated', 'success')
    } else {
      await settingsService.createPartnerType({ ...ptForm })
      notify.notify('Partner type created', 'success')
    }
    showPTModal.value = false
    await loadPartnerTypes()
  } catch (e: any) {
    modalError.value = e?.response?.data?.message ?? 'Failed to save'
  } finally { modalLoading.value = false }
}

const togglePartnerType = async (pt: any) => {
  try {
    const { data } = await settingsService.togglePartnerType(pt.id)
    const idx = partnerTypes.value.findIndex(p => p.id === pt.id)
    if (idx !== -1) partnerTypes.value[idx] = { ...partnerTypes.value[idx], ...data.data }
  } catch { notify.notify('Failed to toggle status', 'error') }
}

const deletePartnerType = async (pt: any) => {
  const result = await Swal.fire({
    title: `Delete "${pt.name}"?`,
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Delete',
    confirmButtonColor: '#ef4444',
    background: '#181c22', color: '#f0f4f8',
  })
  if (!result.isConfirmed) return
  try {
    await settingsService.deletePartnerType(pt.id)
    notify.notify('Partner type deleted', 'success')
    await loadPartnerTypes()
  } catch (e: any) {
    notify.notify(e?.response?.data?.message ?? 'Failed to delete', 'error')
  }
}

// ══════════════════════════════════════════════════════════════
// ROLES
// ══════════════════════════════════════════════════════════════
const roles         = ref<any[]>([])
const allPerms      = ref<any[]>([])
const roleLoading   = ref(false)
const permLoading   = ref(false)
const showRoleModal = ref(false)
const editingRole   = ref<any>(null)

const roleFormDefault = () => ({
  name: '', display_name: '', description: '', level: 10, is_system: false,
  permissions: [] as number[],
})
const roleForm = reactive(roleFormDefault())

const groupedPermissions = computed(() => {
  const groups: Record<string, any[]> = {}
  for (const p of allPerms.value) {
    const mod = p.module?.display_name || p.module?.name || `Module #${p.module_id}` || 'General'
    if (!groups[mod]) groups[mod] = []
    groups[mod].push(p)
  }
  return groups
})

const isModuleChecked      = (perms: any[]) => perms.every(p => roleForm.permissions.includes(p.id))
const isModuleIndeterminate = (perms: any[]) =>
  perms.some(p => roleForm.permissions.includes(p.id)) && !isModuleChecked(perms)

const toggleModule = (perms: any[], e: Event) => {
  const checked = (e.target as HTMLInputElement).checked
  const ids = perms.map(p => p.id)
  if (checked) {
    roleForm.permissions = [...new Set([...roleForm.permissions, ...ids])]
  } else {
    roleForm.permissions = roleForm.permissions.filter(id => !ids.includes(id))
  }
}

const loadRoles = async () => {
  roleLoading.value = true
  try {
    const { data } = await settingsService.getRoles()
    roles.value = data.data ?? []
  } catch { notify.notify('Failed to load roles', 'error') }
  finally { roleLoading.value = false }
}

const loadPermissions = async () => {
  if (allPerms.value.length) return
  permLoading.value = true
  try {
    const { data } = await settingsService.getPermissions()
    allPerms.value = data.data ?? []
  } catch { notify.notify('Failed to load permissions', 'error') }
  finally { permLoading.value = false }
}

const openRoleModal = async (role?: any) => {
  modalError.value = ''
  editingRole.value = role ?? null
  if (role) {
    Object.assign(roleForm, {
      name: role.name, display_name: role.display_name,
      description: role.description ?? '', level: role.level,
      is_system: role.is_system,
      permissions: (role.permissions ?? []).map((p: any) => p.id),
    })
  } else {
    Object.assign(roleForm, roleFormDefault())
  }
  showRoleModal.value = true
  await loadPermissions()
}

const saveRole = async () => {
  modalError.value = ''
  if (!roleForm.name || !roleForm.display_name) { modalError.value = 'Name and Display Name are required'; return }
  modalLoading.value = true
  try {
    if (editingRole.value) {
      await settingsService.updateRole(editingRole.value.id, { ...roleForm })
      notify.notify('Role updated', 'success')
    } else {
      await settingsService.createRole({ ...roleForm })
      notify.notify('Role created', 'success')
    }
    showRoleModal.value = false
    await loadRoles()
  } catch (e: any) {
    modalError.value = e?.response?.data?.message ?? 'Failed to save'
  } finally { modalLoading.value = false }
}

const deleteRole = async (role: any) => {
  const result = await Swal.fire({
    title: `Delete role "${role.display_name}"?`,
    text: role.is_system ? 'System roles cannot be deleted.' : 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Delete',
    confirmButtonColor: '#ef4444',
    background: '#181c22', color: '#f0f4f8',
  })
  if (!result.isConfirmed) return
  try {
    await settingsService.deleteRole(role.id)
    notify.notify('Role deleted', 'success')
    await loadRoles()
  } catch (e: any) {
    notify.notify(e?.response?.data?.message ?? 'Failed to delete', 'error')
  }
}

// ══════════════════════════════════════════════════════════════
// SUBSCRIPTION PLANS
// ══════════════════════════════════════════════════════════════
const plans         = ref<any[]>([])
const planLoading   = ref(false)
const showPlanModal = ref(false)
const editingPlan   = ref<any>(null)

const planFormDefault = () => ({
  name: '', display_name: '', description: '',
  price: 0, original_price: undefined as number | undefined,
  currency: 'VND', duration_days: 30, trial_days: 0,
  max_playlists: undefined as number | undefined,
  max_songs_per_playlist: undefined as number | undefined,
  max_offline_downloads: undefined as number | undefined,
  max_devices: 1,
  can_download: false, audio_quality: 'standard' as 'standard' | 'high' | 'lossless',
  ads_free: false, can_skip_unlimited: false,
  can_create_collaborative_playlist: false,
  priority_support: false, early_access: false,
  is_active: true, is_featured: false, sort_order: 999,
})
const planForm = reactive(planFormDefault())

const loadPlans = async () => {
  planLoading.value = true
  try {
    const { data } = await settingsService.getSubscriptionPlans()
    plans.value = data.data ?? []
  } catch { notify.notify('Failed to load plans', 'error') }
  finally { planLoading.value = false }
}

const openPlanModal = (plan?: any) => {
  modalError.value = ''
  editingPlan.value = plan ?? null
  if (plan) {
    Object.assign(planForm, {
      name: plan.name, display_name: plan.display_name, description: plan.description ?? '',
      price: plan.price, original_price: plan.original_price,
      currency: plan.currency, duration_days: plan.duration_days, trial_days: plan.trial_days,
      max_playlists: plan.max_playlists, max_songs_per_playlist: plan.max_songs_per_playlist,
      max_offline_downloads: plan.max_offline_downloads, max_devices: plan.max_devices,
      can_download: plan.can_download, audio_quality: plan.audio_quality,
      ads_free: plan.ads_free, can_skip_unlimited: plan.can_skip_unlimited,
      can_create_collaborative_playlist: plan.can_create_collaborative_playlist,
      priority_support: plan.priority_support, early_access: plan.early_access,
      is_active: plan.is_active, is_featured: plan.is_featured, sort_order: plan.sort_order,
    })
  } else {
    Object.assign(planForm, planFormDefault())
  }
  showPlanModal.value = true
}

const savePlan = async () => {
  modalError.value = ''
  if (!planForm.name || !planForm.display_name) { modalError.value = 'Name and Display Name are required'; return }
  modalLoading.value = true
  try {
    const payload = { ...planForm }
    if (!payload.original_price)        delete payload.original_price
    if (!payload.max_playlists)         delete payload.max_playlists
    if (!payload.max_songs_per_playlist) delete payload.max_songs_per_playlist
    if (!payload.max_offline_downloads) delete payload.max_offline_downloads

    if (editingPlan.value) {
      await settingsService.updateSubscriptionPlan(editingPlan.value.id, payload)
      notify.notify('Plan updated', 'success')
    } else {
      await settingsService.createSubscriptionPlan(payload as any)
      notify.notify('Plan created', 'success')
    }
    showPlanModal.value = false
    await loadPlans()
  } catch (e: any) {
    modalError.value = e?.response?.data?.message ?? 'Failed to save'
  } finally { modalLoading.value = false }
}

const togglePlan = async (plan: any) => {
  try {
    const { data } = await settingsService.toggleSubscriptionPlan(plan.id)
    const idx = plans.value.findIndex(p => p.id === plan.id)
    if (idx !== -1) plans.value[idx] = { ...plans.value[idx], ...data.data }
  } catch { notify.notify('Failed to toggle status', 'error') }
}

const deletePlan = async (plan: any) => {
  const result = await Swal.fire({
    title: `Delete plan "${plan.display_name}"?`,
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Delete',
    confirmButtonColor: '#ef4444',
    background: '#181c22', color: '#f0f4f8',
  })
  if (!result.isConfirmed) return
  try {
    await settingsService.deleteSubscriptionPlan(plan.id)
    notify.notify('Plan deleted', 'success')
    await loadPlans()
  } catch (e: any) {
    notify.notify(e?.response?.data?.message ?? 'Failed to delete', 'error')
  }
}

// ── Load on tab change ──────────────────────────────────────
watch(activeTab, (tab) => {
  if (tab === 'partner-types'      && !partnerTypes.value.length) loadPartnerTypes()
  if (tab === 'roles'              && !roles.value.length)        loadRoles()
  if (tab === 'subscription-plans' && !plans.value.length)        loadPlans()
}, { immediate: true })
</script>

<!--
  ╔══════════════════════════════════════════════════════════════════╗
  ║  QUAN TRỌNG: Chỉ dùng <style> (KHÔNG scoped)                   ║
  ║  Lý do: Teleport đẩy modal ra ngoài component tree,            ║
  ║  scoped CSS sẽ không match được các element đó.                 ║
  ║  Tất cả class modal dùng prefix "s-" để tránh xung đột global. ║
  ╚══════════════════════════════════════════════════════════════════╝
-->
<style>
/* ── Keyframes ─────────────────────────────────────────────────────────────── */
@keyframes spin    { to { transform: rotate(360deg); } }
@keyframes fadeUp  { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

/* ══════════════════════════════════════════════════════════════════════════════
   PAGE LAYOUT
══════════════════════════════════════════════════════════════════════════════ */
.admin-settings {
  min-height: 100vh;
  background: #0f1117;
  color: #e5e7eb;
  font-family: 'DM Sans', system-ui, sans-serif;
}

/* ── Header ────────────────────────────────────────────────────────────────── */
.settings-header {
  padding: 28px 32px 20px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
}
.settings-title {
  font-size: 26px;
  font-weight: 700;
  background: linear-gradient(135deg, #fff 0%, #60a5fa 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  margin: 0 0 6px;
}
.settings-subtitle { color: #9ca3af; font-size: 13px; margin: 0; }

/* ── Tabs ──────────────────────────────────────────────────────────────────── */
.settings-tabs {
  display: flex;
  gap: 2px;
  padding: 0 32px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
  background: rgba(15,17,23,0.8);
}
.tab-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  background: transparent;
  border: none;
  color: #9ca3af;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
}
.tab-btn:hover  { color: #e5e7eb; background: rgba(255,255,255,0.04); }
.tab-btn.active { color: #3b82f6; border-bottom-color: #3b82f6; }
.tab-icon-wrap  { display: flex; align-items: center; }

/* ── Content ───────────────────────────────────────────────────────────────── */
.settings-content { padding: 28px 32px; }
.tab-pane         { animation: fadeUp 0.25s ease; }

/* ── Pane header ───────────────────────────────────────────────────────────── */
.pane-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}
.pane-header h2 { font-size: 18px; font-weight: 600; margin: 0 0 4px; }
.pane-header p  { color: #9ca3af; font-size: 13px; margin: 0; }

/* ══════════════════════════════════════════════════════════════════════════════
   SHARED BUTTONS
══════════════════════════════════════════════════════════════════════════════ */
.btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 8px 16px;
  background: #3b82f6;
  border: none;
  border-radius: 8px;
  color: #fff;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-primary:hover    { background: #2563eb; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }

.btn-ghost {
  padding: 8px 16px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 8px;
  color: #e5e7eb;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-ghost:hover { background: rgba(255,255,255,0.1); }

.btn-outline {
  padding: 5px 12px;
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 6px;
  color: #9ca3af;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-outline:hover        { background: rgba(255,255,255,0.08); color: #e5e7eb; }
.btn-outline.delete:hover { background: rgba(239,68,68,0.15); border-color: #ef4444; color: #ef4444; }
.btn-outline:disabled     { opacity: 0.35; cursor: not-allowed; }

/* ══════════════════════════════════════════════════════════════════════════════
   TABLE
══════════════════════════════════════════════════════════════════════════════ */
.table-wrapper {
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 12px;
  overflow-x: auto;
}
.data-table { width: 100%; border-collapse: collapse; }
.data-table th,
.data-table td  { padding: 11px 16px; text-align: left; border-bottom: 1px solid rgba(255,255,255,0.04); }
.data-table th  { font-size: 11px; font-weight: 600; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; background: rgba(255,255,255,0.02); }
.data-table td  { font-size: 13px; }
.data-table tr:last-child td { border-bottom: none; }
.data-table tr:hover td      { background: rgba(255,255,255,0.02); }
.cell-name   { font-weight: 500; color: #f1f5f9; }
.cell-sub    { font-size: 11px; color: #9ca3af; margin-top: 2px; }
.empty-cell  { text-align: center; color: #9ca3af; padding: 32px !important; }
.actions     { display: flex; gap: 6px; }

.action-btn         { background: none; border: none; cursor: pointer; padding: 5px; border-radius: 6px; transition: all 0.2s; display: inline-flex; align-items: center; }
.action-btn.edit    { color: #3b82f6; }
.action-btn.edit:hover   { background: rgba(59,130,246,0.12); }
.action-btn.delete  { color: #ef4444; }
.action-btn.delete:hover { background: rgba(239,68,68,0.12); }
.action-btn:disabled     { opacity: 0.3; cursor: not-allowed; }

/* ══════════════════════════════════════════════════════════════════════════════
   CHIPS & TAGS
══════════════════════════════════════════════════════════════════════════════ */
.chip         { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: 10px; font-weight: 600; letter-spacing: 0.03em; }
.chip--green  { background: rgba(34,197,94,0.12);  color: #4ade80; }
.chip--blue   { background: rgba(59,130,246,0.12);  color: #60a5fa; }
.chip--purple { background: rgba(139,92,246,0.12);  color: #a78bfa; }
.chip--orange { background: rgba(249,115,22,0.12);  color: #fb923c; }
.chip--gray   { background: rgba(255,255,255,0.07); color: #9ca3af; }
.perm-chips   { display: flex; flex-wrap: wrap; gap: 4px; }

.code-tag   { font-family: 'JetBrains Mono', monospace; font-size: 11px; background: rgba(255,255,255,0.06); padding: 2px 7px; border-radius: 4px; color: #94a3b8; }
.highlight  { color: #60a5fa; font-weight: 600; }
.capitalize { text-transform: capitalize; }

/* ── Toggle pill ───────────────────────────────────────────────────────────── */
.toggle-pill        { padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s; }
.toggle-pill.on     { background: rgba(34,197,94,0.12);  color: #4ade80; }
.toggle-pill.off    { background: rgba(255,255,255,0.06); color: #9ca3af; }
.toggle-pill:hover  { opacity: 0.8; }

/* ── Loading ───────────────────────────────────────────────────────────────── */
.loading-row { display: flex; align-items: center; gap: 10px; padding: 32px; color: #9ca3af; font-size: 13px; }
.spinner     { width: 20px; height: 20px; border: 2px solid rgba(255,255,255,0.1); border-top-color: #3b82f6; border-radius: 50%; animation: spin 0.8s linear infinite; flex-shrink: 0; }
.spinner-sm  { width: 13px; height: 13px; border: 2px solid rgba(255,255,255,0.3); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; display: inline-block; }

/* ══════════════════════════════════════════════════════════════════════════════
   ROLES GRID
══════════════════════════════════════════════════════════════════════════════ */
.roles-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 16px; }

.role-card         { background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.07); border-radius: 14px; padding: 18px; transition: border-color 0.2s; }
.role-card:hover   { border-color: rgba(59,130,246,0.25); }
.role-card__header { display: flex; align-items: flex-start; gap: 12px; margin-bottom: 10px; }
.role-icon         { width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; color: #fff; flex-shrink: 0; }
.role-card__meta   { flex: 1; min-width: 0; }
.role-card__meta h3 { font-size: 15px; font-weight: 600; margin: 0 0 3px; }
.role-card__badges { display: flex; flex-wrap: wrap; gap: 4px; flex-shrink: 0; }
.role-desc         { font-size: 12px; color: #9ca3af; margin: 0 0 12px; line-height: 1.5; }
.role-perms        { display: flex; flex-wrap: wrap; gap: 5px; margin-bottom: 14px; }

.perm-tag         { padding: 2px 8px; background: rgba(59,130,246,0.08); border-radius: 4px; font-size: 10px; font-weight: 500; color: #60a5fa; }
.perm-tag--more   { background: rgba(255,255,255,0.06); color: #9ca3af; }
.perm-tag--empty  { background: rgba(255,255,255,0.04); color: #6b7280; }

.role-card__actions { display: flex; gap: 8px; padding-top: 12px; border-top: 1px solid rgba(255,255,255,0.05); }

.empty-card { grid-column: 1 / -1; text-align: center; padding: 40px; color: #9ca3af; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.07); border-radius: 14px; }

/* ══════════════════════════════════════════════════════════════════════════════
   PLANS GRID
══════════════════════════════════════════════════════════════════════════════ */
.plans-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }

.plan-card            { background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.07); border-radius: 16px; padding: 20px; position: relative; transition: border-color 0.2s; }
.plan-card:hover      { border-color: rgba(255,255,255,0.12); }
.plan-card--featured  { border-color: rgba(59,130,246,0.35); background: rgba(59,130,246,0.04); }

.featured-badge { position: absolute; top: -11px; left: 50%; transform: translateX(-50%); background: #3b82f6; color: #fff; padding: 3px 12px; border-radius: 20px; font-size: 11px; font-weight: 600; white-space: nowrap; }

.plan-card__header { margin-bottom: 12px; }
.plan-name-row     { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
.plan-name-row h3  { font-size: 17px; font-weight: 600; margin: 0; }
.plan-price        { display: flex; align-items: baseline; gap: 4px; }
.price-amount      { font-size: 22px; font-weight: 700; color: #f1f5f9; }
.price-period      { font-size: 12px; color: #9ca3af; }
.price-original    { font-size: 12px; color: #9ca3af; text-decoration: line-through; margin-top: 2px; }
.plan-desc         { font-size: 12px; color: #9ca3af; margin: 0 0 14px; line-height: 1.5; }
.plan-features     { margin-bottom: 12px; }

.feature-row        { display: flex; justify-content: space-between; align-items: center; padding: 5px 0; border-bottom: 1px solid rgba(255,255,255,0.04); font-size: 12px; }
.feature-row:last-child { border-bottom: none; }
.feature-label      { color: #9ca3af; }
.feature-val        { font-weight: 500; color: #e5e7eb; }
.quality            { text-transform: capitalize; }
.quality--standard  { color: #9ca3af; }
.quality--high      { color: #60a5fa; }
.quality--lossless  { color: #a78bfa; }

.plan-toggles       { display: flex; flex-wrap: wrap; gap: 5px; margin-bottom: 14px; }
.plan-card__actions { display: flex; gap: 8px; padding-top: 12px; border-top: 1px solid rgba(255,255,255,0.05); }

/* ══════════════════════════════════════════════════════════════════════════════
   MODAL  — prefix "s-" để tránh conflict với Tailwind / các thư viện khác
   KHÔNG dùng scoped vì Teleport đẩy DOM ra ngoài component tree
══════════════════════════════════════════════════════════════════════════════ */
.s-modal-overlay {
  position: fixed !important;
  inset: 0 !important;
  background: rgba(0,0,0,0.75) !important;
  backdrop-filter: blur(6px);
  -webkit-backdrop-filter: blur(6px);
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  z-index: 9999 !important;
  padding: 20px;
}

.s-modal {
  background: #181c22;
  border: 1px solid rgba(255,255,255,0.12);
  border-radius: 16px;
  width: 100%;
  max-width: 520px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 24px 64px rgba(0,0,0,0.7);
  color: #e5e7eb;
}
.s-modal--wide { max-width: 720px; }

.s-modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 24px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
  flex-shrink: 0;
}
.s-modal-header h3 { font-size: 16px; font-weight: 600; margin: 0; color: #f1f5f9; }

.s-modal-close { background: none; border: none; color: #9ca3af; font-size: 18px; cursor: pointer; padding: 2px 8px; border-radius: 4px; line-height: 1; transition: all 0.2s; }
.s-modal-close:hover { background: rgba(255,255,255,0.08); color: #fff; }

.s-modal-body   { padding: 20px 24px; overflow-y: auto; flex: 1; }

.s-modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 24px;
  border-top: 1px solid rgba(255,255,255,0.07);
  flex-shrink: 0;
}

.s-modal-error { margin-top: 12px; padding: 10px 14px; background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.2); border-radius: 8px; color: #f87171; font-size: 13px; }

/* ── Modal form grid ───────────────────────────────────────────────────────── */
.s-form-grid        { display: grid; grid-template-columns: 1fr 1fr; gap: 14px 20px; }
.s-form-group       { display: flex; flex-direction: column; gap: 5px; }
.s-form-group--full { grid-column: 1 / -1; }

.s-form-group label {
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #9ca3af;
}
.s-req { color: #ef4444; }

.s-form-input {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 8px;
  padding: 9px 12px;
  color: #f1f5f9;
  font-size: 13px;
  outline: none;
  transition: border-color 0.2s;
  width: 100%;
  box-sizing: border-box;
  font-family: inherit;
}
.s-form-input:focus       { border-color: rgba(59,130,246,0.5); background: rgba(59,130,246,0.04); }
.s-form-input::placeholder { color: rgba(255,255,255,0.2); }
.s-form-input option      { background: #1e2330; }
.s-form-textarea          { resize: vertical; min-height: 64px; }

.s-label-section {
  font-size: 12px !important;
  font-weight: 600 !important;
  color: #e5e7eb !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
  margin-bottom: 8px;
  display: block;
}

.s-checkbox-row  { display: flex; flex-wrap: wrap; gap: 10px 20px; }
.s-checkbox-label {
  display: flex;
  align-items: center;
  gap: 7px;
  font-size: 13px;
  color: #d1d5db;
  text-transform: none;
  letter-spacing: 0;
  cursor: pointer;
}
.s-checkbox-label input[type="checkbox"] { width: 15px; height: 15px; accent-color: #3b82f6; cursor: pointer; }

/* ── Permissions in Role modal ─────────────────────────────────────────────── */
.s-perm-section { margin-top: 16px; }
.s-perm-groups  { display: flex; flex-direction: column; gap: 12px; max-height: 320px; overflow-y: auto; padding-right: 4px; }

.s-perm-group           { background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.06); border-radius: 10px; overflow: hidden; }
.s-perm-group__header   { padding: 8px 14px; background: rgba(255,255,255,0.03); border-bottom: 1px solid rgba(255,255,255,0.05); }
.s-perm-group__items    { padding: 10px 14px; display: flex; flex-wrap: wrap; gap: 8px 20px; }

/* ── Modal transition ──────────────────────────────────────────────────────── */
.modal-fade-enter-active,
.modal-fade-leave-active { transition: all 0.2s ease; }
.modal-fade-enter-from,
.modal-fade-leave-to     { opacity: 0; transform: scale(0.97); }

/* ══════════════════════════════════════════════════════════════════════════════
   RESPONSIVE
══════════════════════════════════════════════════════════════════════════════ */
@media (max-width: 768px) {
  .settings-header, .settings-content { padding: 20px; }
  .settings-tabs  { padding: 0 20px; overflow-x: auto; }
  .roles-grid, .plans-grid { grid-template-columns: 1fr; }
  .pane-header    { flex-direction: column; gap: 12px; }
  .s-form-grid    { grid-template-columns: 1fr; }
}
</style>