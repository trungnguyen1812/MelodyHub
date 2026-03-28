<template>
  <div class="songs-management">
    <!-- Header -->
    <div class="header">
      <div class="header-left">
        <h1 class="title">Songs Management</h1>
        <p class="subtitle">Manage All Music Tracks</p>
      </div>
      <div class="header-right">
        <button class="btn-add" @click="ViewAddSong">
          <span class="btn-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <circle cx="12" cy="12" r="10"/>
              <line x1="12" y1="8" x2="12" y2="16"/>
              <line x1="8" y1="12" x2="16" y2="12"/>
            </svg>
          </span>
          Add New Song
        </button>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat-card stat-card--blue">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M9 18V5l12-2v13"/>
            <circle cx="6" cy="18" r="3"/>
            <circle cx="18" cy="16" r="3"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Total Songs</span>
          <span class="stat-value">{{ songStore.meta?.total ?? 0 }}</span>
          <span class="stat-change positive">↑ 18% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--green">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <polygon points="5 3 19 12 5 21 5 3"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Published</span>
          <span class="stat-value">{{  0 }}</span>
          <span class="stat-change positive">↑ 12% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--purple">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M3 18v-6a9 9 0 0 1 18 0v6"/>
            <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3z"/>
            <path d="M3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Premium</span>
          <span class="stat-value">{{ 0 }}</span>
          <span class="stat-change positive">↑ 5% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--orange">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Top Liked</span>
          <span class="stat-value">{{ 0 }}</span>
          <span class="stat-change positive">↑ 30% from last month</span>
        </div>
      </div>
    </div>
    <div class="songs-list-page">
      
      <!-- Toolbar -->
      <div class="toolbar">
        <div class="toolbar__left">
          <div class="search-box">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="search-icon">
              <circle cx="11" cy="11" r="8"/>
              <line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input v-model="searchQuery" type="text" placeholder="Search title, artist..." @input="onSearchInput" />
            <button v-if="searchQuery" class="search-clear" @click="searchQuery = ''; onFilterChange()">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>

          <select v-model="selectedStatus" class="filter-select" @change="onFilterChange">
            <option value="">All Status</option>
            <option value="published">Published</option>
            <option value="draft">Draft</option>
            <option value="blocked">Blocked</option>
            <option value="processing">Processing</option>
          </select>

          <select v-model="selectedQuality" class="filter-select" @change="onFilterChange">
            <option value="">All Quality</option>
            <option value="standard">Standard</option>
            <option value="high">High</option>
            <option value="lossless">Lossless</option>
          </select>

          <div v-if="hasActiveFilters" class="filter-indicator">
            <span class="filter-dot"></span>
            <button class="filter-clear-all" @click="clearAllFilters">Clear all</button>
          </div>
        </div>

        <div class="toolbar__right">
          
          <select v-model="sortBy" class="filter-select" @change="onFilterChange">
            <option value="newest">Newest First</option>
            <option value="oldest">Oldest First</option>
            <option value="title">Title A–Z</option>
            <option value="plays">Most Played</option>
          </select>
          <div class="view-toggle">
            <button class="view-btn" :class="{ active: viewMode === 'table' }" @click="viewMode = 'table'" title="Table view">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/>
                <line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/>
                <line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/>
              </svg>
            </button>
            <button class="view-btn" :class="{ active: viewMode === 'grid' }" @click="viewMode = 'grid'" title="Grid view">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
              </svg>
            </button>
          </div>
          <div>
            <button class="btn-view-all" @click="ViewAllSongs">View All →</button>
          </div>
          <Transition name="fade">
            <div v-if="selectedIds.length > 0" class="bulk-actions">
              <span class="bulk-count">{{ selectedIds.length }} selected</span>
              <button class="bulk-btn bulk-btn--danger" @click="confirmBulkDelete">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <polyline points="3 6 5 6 21 6"/>
                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                </svg>
                Delete
              </button>
              <button class="bulk-btn bulk-btn--neutral" @click="selectedIds = []">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
                Cancel
              </button>
            </div>
          </Transition>
        </div>
      </div>

      <!-- Loading skeleton -->
      <div v-if="songStore.loading" class="loading-wrap">
        <div v-if="viewMode === 'table'" class="skeleton-table">
          <div v-for="n in 8" :key="n" class="skeleton-row">
            <div class="skel skel--check"></div>
            <div class="skel-song-cell">
              <div class="skel skel--cover"></div>
              <div class="skel-text-col">
                <div class="skel skel--title"></div>
                <div class="skel skel--sub"></div>
              </div>
            </div>
            <div class="skel skel--md"></div>
            <div class="skel skel--sm"></div>
            <div class="skel skel--badge"></div>
            <div class="skel skel--sm"></div>
            <div class="skel skel--plays"></div>
            <div class="skel skel--badge"></div>
            <div class="skel skel--sm"></div>
          </div>
        </div>
        <div v-else class="skeleton-grid">
          <div v-for="n in 12" :key="n" class="skeleton-card">
            <div class="skel skel--cover-lg"></div>
            <div class="skel-card-body">
              <div class="skel skel--title"></div>
              <div class="skel skel--sub"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Error -->
      <div v-else-if="songStore.error" class="error-state">
        <div class="error-icon">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <circle cx="12" cy="12" r="10"/>
            <line x1="12" y1="8" x2="12" y2="12"/>
            <line x1="12" y1="16" x2="12.01" y2="16"/>
          </svg>
        </div>
        <p class="error-title">Something went wrong</p>
        <p class="error-msg">{{ songStore.error }}</p>
        <button class="btn-retry" @click="loadSongs">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="1 4 1 10 7 10"/>
            <path d="M3.51 15a9 9 0 1 0 .49-3.51"/>
          </svg>
          Retry
        </button>
      </div>

      <template v-else>
        <!-- TABLE VIEW -->
        <Transition name="view-switch" mode="out-in">
          <div v-if="viewMode === 'table'" key="table" class="table-section">
            <div class="table-wrapper">
              <table class="songs-table">
                <thead>
                  <tr>
                    <th class="th-check">
                      <label class="checkbox-wrap">
                        <input type="checkbox" @change="toggleAll" :checked="allChecked" :indeterminate="someChecked" />
                        <span class="checkbox-custom"></span>
                      </label>
                    </th>
                    <th class="th-sortable" @click="setSortBy('title')">
                      <span class="th-inner">
                        Song
                        <svg class="sort-icon" :class="{ active: sortBy === 'title' }" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                          <polyline points="18 15 12 9 6 15"/>
                        </svg>
                      </span>
                    </th>
                    <th>Artist</th>
                    <!-- <th>Album</th> -->
                    <th>Quality</th>
                    <th class="th-sortable" @click="setSortBy('duration')">
                      <span class="th-inner">
                        Duration
                        <svg class="sort-icon" :class="{ active: sortBy === 'duration' }" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                          <polyline points="18 15 12 9 6 15"/>
                        </svg>
                      </span>
                    </th>
                    <th class="th-sortable" @click="setSortBy('plays')">
                      <span class="th-inner">
                        Plays
                        <svg class="sort-icon" :class="{ active: sortBy === 'plays' }" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                          <polyline points="18 15 12 9 6 15"/>
                        </svg>
                      </span>
                    </th>
                    <th>Status</th>
                    <th class="th-sortable" @click="setSortBy('newest')">
                      <span class="th-inner">
                        Date
                        <svg class="sort-icon" :class="{ active: sortBy === 'newest' || sortBy === 'oldest' }" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                          <polyline points="18 15 12 9 6 15"/>
                        </svg>
                      </span>
                    </th>
                    <th class="th-actions">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <TransitionGroup name="row">
                    <tr
                      v-for="(song, i) in songStore.songs"
                      :key="song.id"
                      class="table-row"
                      :class="{ selected: selectedIds.includes(song.id), playing: player.currentSong?.id === song.id }"
                      :style="{ animationDelay: i * 30 + 'ms' }"
                    >
                      <td class="td-check">
                        <label class="checkbox-wrap">
                          <input type="checkbox" :checked="selectedIds.includes(song.id)" @change="toggleSelect(song.id)" />
                          <span class="checkbox-custom"></span>
                        </label>
                      </td>
                      <td class="td-song" @click="goToDetail(song.id)">
                        <div class="song-cell">
                          <div class="song-cover" :style="getCoverStyle(song)">
                            <svg v-if="!song.cover_url" width="13" height="13" viewBox="0 0 24 24" fill="rgba(255,255,255,0.7)">
                              <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
                            </svg>
                            <div v-if="player.currentSong?.id === song.id" class="cover-playing-overlay">
                              <span class="bar"></span><span class="bar"></span><span class="bar"></span>
                            </div>
                          </div>
                          <div class="song-info">
                            <p class="song-title" >{{ song.title }}</p>
                            <p class="song-meta-sub">{{ song.year ?? '' }} {{ song.is_explicit ? '🅴' : '' }} {{ song.is_featured ? '✦' : '' }}
                              <span
                                class="genre-tag"
                                :style="{
                                  borderColor: song.genre?.color || undefined,
                                  color: song.genre?.color || undefined
                                }"
                              >
                                {{ song.genre?.name }}
                              </span>
                            </p>
                          </div>
                        </div>
                      </td>
                      <td class="td-text">{{ song.artist?.name ?? '—' }}</td>
                      <!-- <td class="td-text td-muted">{{ song.album?.title ?? '—' }}</td> -->
                      <td>
                        <span class="quality-badge" :class="'quality--' + song.quality">{{ song.quality }}</span>
                      </td>
                      <td class="td-text td-mono">{{ song.duration_format }}</td>
                      <td>
                        <div class="plays-cell">
                          <div class="plays-bar-wrap">
                            <div class="plays-bar">
                              <div class="plays-fill" :style="{ width: getPlaysPercent(song.stats.total_plays) + '%' }"></div>
                            </div>
                          </div>
                          <span class="plays-num">{{ formatNumber(song.stats.total_plays) }}</span>
                        </div>
                      </td>
                      <td>
                        <span class="status-badge" :class="'status--' + song.status">
                          <span class="status-dot"></span>
                          {{ song.status }}
                        </span>
                      </td>
                      <td class="td-text td-muted td-mono">{{ formatDate(song.created_at) }}</td>
                      <td class="td-actions">
                        <div class="action-btns">
                          <button
                            class="act-btn act-btn--play"
                            :class="{ 'is-playing': player.currentSong?.id === song.id }"
                            :title="player.currentSong?.id === song.id ? 'Pause' : 'Play'"
                            @click="playSong(song)"
                          >
                            <svg v-if="player.currentSong?.id === song.id && player.isPlaying" width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                              <rect x="6" y="4" width="4" height="16" rx="1"/><rect x="14" y="4" width="4" height="16" rx="1"/>
                            </svg>
                            <svg v-else width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                              <polygon points="5 3 19 12 5 21 5 3"/>
                            </svg>
                          </button>
                          <button class="act-btn act-btn--edit" title="Edit" @click="updateSong(song.id)">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                            </svg>
                          </button>
                          <button class="act-btn act-btn--delete" title="Delete" @click="deleteSong(song.id)">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <polyline points="3 6 5 6 21 6"/>
                              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </TransitionGroup>
                </tbody>
              </table>
            </div>
          </div>

          <!-- GRID VIEW -->
          <div v-else key="grid" class="grid-view">
            <TransitionGroup name="card">
              <div
                v-for="(song, i) in songStore.songs"
                :key="song.id"
                class="song-card"
                :class="{ 'is-playing': player.currentSong?.id === song.id }"
                :style="{ animationDelay: i * 40 + 'ms' }"
              >
                <div class="card-cover" :style="getCoverStyle(song)">
                  <div v-if="!song.cover_url" class="card-cover-fallback">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="rgba(255,255,255,0.35)">
                      <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
                    </svg>
                  </div>
                  <div v-if="player.currentSong?.id === song.id" class="card-playing-indicator">
                    <span class="bar"></span><span class="bar"></span>
                    <span class="bar"></span><span class="bar"></span>
                  </div>
                  <div class="card-overlay">
                    <button class="card-play-btn" @click="playSong(song)">
                      <svg v-if="player.currentSong?.id === song.id && player.isPlaying" width="22" height="22" viewBox="0 0 24 24" fill="white">
                        <rect x="6" y="4" width="4" height="16" rx="1"/><rect x="14" y="4" width="4" height="16" rx="1"/>
                      </svg>
                      <svg v-else width="22" height="22" viewBox="0 0 24 24" fill="white">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                      </svg>
                    </button>
                  </div>
                  <div class="card-top-badges">
                    <span v-if="song.is_featured" class="card-badge card-badge--featured">✦ Featured</span>
                    <span v-if="song.is_explicit" class="card-badge card-badge--explicit">E</span>
                  </div>
                  <span class="card-duration">{{ song.duration_format }}</span>
                </div>

                <div class="card-body">
                  <div class="card-header-row">
                    <div class="card-title-group">
                      <p class="card-title" @click="goToDetail(song.id)">{{ song.title }}</p>
                      <p class="card-artist">{{ song.artist?.name ?? '—' }}</p>
                    </div>
                    <span class="status-badge status-badge--sm" :class="'status--' + song.status">
                      <span class="status-dot"></span>
                      {{ song.status }}
                    </span>
                  </div>
                  <div class="card-divider"></div>
                  <div class="card-meta-row">
                    <span class="quality-badge quality-badge--sm" :class="'quality--' + song.quality">{{ song.quality }}</span>
                    <div v-for="song in songStore.songs" :key="song.id">
                      <span
                        class="genre-tag"
                        :style="{
                          borderColor: song.genre?.color || undefined,
                          color: song.genre?.color || undefined
                        }"
                      >
                        {{ song.genre?.name }}
                      </span>
                    </div>
                    <div class="card-stats">
                      <span class="card-stat">
                        <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        {{ formatNumber(song.stats.total_plays) }}
                      </span>
                      <span class="card-stat">
                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                        {{ formatNumber(song.stats.total_likes) }}
                      </span>
                    </div>
                  </div>
                  <div class="card-footer-row">
                    <span class="card-date">{{ formatDate(song.created_at) }}</span>
                    <div class="action-btns">
                      <button class="act-btn act-btn--edit" title="Edit" @click="updateSong(song.id)">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                          <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                      </button>
                      <button class="act-btn act-btn--delete" title="Delete">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <polyline points="3 6 5 6 21 6"/>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </TransitionGroup>
          </div>
        </Transition>

        <!-- Empty state -->
        <Transition name="fade">
          <div v-if="!songStore.loading && songStore.songs.length === 0" class="empty-state">
            <div class="empty-illustration">
              <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
              </svg>
            </div>
            <p class="empty-title">No songs found</p>
            <p class="empty-sub">Try adjusting your search or clearing filters</p>
            <button v-if="hasActiveFilters" class="btn-retry" @click="clearAllFilters">Clear filters</button>
          </div>
        </Transition>

        <!-- Pagination -->
        <div class="pagination" v-if="songStore.meta && songStore.meta.last_page > 1">
          <span class="pagination-info">
            Page <strong>{{ songStore.meta.current_page }}</strong> of <strong>{{ songStore.meta.last_page }}</strong>
            <span class="pagination-sep">·</span>
            <strong>{{ songStore.meta.total }}</strong> songs
          </span>
          <div class="pagination-controls">
            <button class="page-btn page-btn--arrow" :disabled="songStore.meta.current_page === 1" @click="changePage(currentPage - 1)">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
            </button>
            <button
              v-for="p in pageNumbers" :key="p"
              class="page-btn"
              :class="{ active: p === currentPage, ellipsis: p === '...' }"
              @click="p !== '...' && changePage(p as number)"
            >{{ p }}</button>
            <button class="page-btn page-btn--arrow" :disabled="!songStore.hasNextPage" @click="changePage(currentPage + 1)">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
            </button>
          </div>
          <div class="per-page">
            <span class="per-page-label">Rows per page:</span>
            <select v-model="perPage" class="filter-select filter-select--sm" @change="onPerPageChange">
              <option :value="10">10</option>
              <option :value="20">20</option>
              <option :value="50">50</option>
            </select>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import router from '@/modules/router'
import { useSongStore } from '@/modules/admin/stores/songs/songsStore'
import { usePlayerStore } from '@/modules/admin/stores/songs/playerStore'
import type { Song, SongFilterParams } from '@/modules/admin/interfaces/songs/songs.interface'
import { useNotificationStore } from "@/store/notificationStore";
import { storeToRefs } from "pinia";
import Swal from 'sweetalert2';


type SortBy   = 'newest' | 'oldest' | 'title' | 'plays' | 'duration'
type ViewMode = 'table' | 'grid'

const songStore = useSongStore()
const player    = usePlayerStore()
const {  loading } = storeToRefs(songStore);
const notificationStore = useNotificationStore();

// ── UI state ──
const searchQuery     = ref('')
const selectedStatus  = ref('')
const selectedQuality = ref('')
const sortBy          = ref<SortBy>('newest')
const viewMode        = ref<ViewMode>('table')
const currentPage     = ref(1)
const perPage         = ref(20)
const selectedIds     = ref<number[]>([])

// ── Cover style ──
const gradients = [
  'linear-gradient(135deg,#1a1a2e,#16213e,#0f3460)',
  'linear-gradient(135deg,#2d1b69,#11998e)',
  'linear-gradient(135deg,#1a1a1a,#c94b4b)',
  'linear-gradient(135deg,#0f2027,#203a43,#2c5364)',
  'linear-gradient(135deg,#4a1942,#c94b4b)',
  'linear-gradient(135deg,#134e5e,#71b280)',
]
const getCoverStyle = (song: Song) => {
  if (song.cover_url) {
    return { backgroundImage: `url(${song.cover_url})`, backgroundSize: 'cover', backgroundPosition: 'center' }
  }
  return { background: gradients[song.id % gradients.length] }
}

// ── Computed ──
const hasActiveFilters = computed(() =>
  !!searchQuery.value || !!selectedStatus.value || !!selectedQuality.value
)
const maxPlays = computed(() =>
  Math.max(...songStore.songs.map(s => s.stats.total_plays), 1)
)
const allChecked = computed(() =>
  songStore.songs.length > 0 && songStore.songs.every(s => selectedIds.value.includes(s.id))
)
const someChecked = computed(() =>
  !allChecked.value && songStore.songs.some(s => selectedIds.value.includes(s.id))
)
const pageNumbers = computed<(number | string)[]>(() => {
  const pages: (number | string)[] = []
  const total = songStore.meta?.last_page ?? 1
  const cur   = currentPage.value
  if (total <= 7) {
    for (let i = 1; i <= total; i++) pages.push(i)
  } else {
    pages.push(1)
    if (cur > 3) pages.push('...')
    for (let i = Math.max(2, cur - 1); i <= Math.min(total - 1, cur + 1); i++) pages.push(i)
    if (cur < total - 2) pages.push('...')
    pages.push(total)
  }
  return pages
})

// ── Helpers ──
const getPlaysPercent = (plays: number) => Math.round((plays / maxPlays.value) * 100)
const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
  : n >= 1_000   ? (n / 1_000).toFixed(1) + 'K'
  : String(n)
const formatDate = (iso: string) =>
  new Date(iso).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' })

// ── Load songs ──
const buildParams = () => ({
  page:     currentPage.value,
  per_page: perPage.value,
  search:   searchQuery.value || undefined,
  status:   selectedStatus.value || undefined,
  quality:  selectedQuality.value || undefined,
  sort_by:  sortBy.value === 'newest' || sortBy.value === 'oldest' ? 'created_at'
          : sortBy.value === 'plays' ? 'total_plays'
          : sortBy.value,
  sort_dir: sortBy.value === 'oldest' ? 'asc' : 'desc',
} as const)

const loadSongs = async () => { await songStore.fetchSongs(buildParams() as SongFilterParams) }



function goToDetail(id: number) {
    router.push({
        name: "admin.songsmanager.detail",
        params: { id }
    });
}

function updateSong(id: number) {
    router.push({
        name: "admin.songsmanager.update",
        params: { id }
    });
}

const changePage = async (page: number) => {
  currentPage.value = page
  await loadSongs()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
const onFilterChange  = async () => { currentPage.value = 1; await loadSongs() }
const onPerPageChange = async () => { currentPage.value = 1; await loadSongs() }

let searchTimer: ReturnType<typeof setTimeout>
const onSearchInput = () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => { currentPage.value = 1; loadSongs() }, 400)
}
const clearAllFilters = () => {
  searchQuery.value = ''; selectedStatus.value = ''; selectedQuality.value = ''
  onFilterChange()
}

// ── Sort ──
const setSortBy = async (value: SortBy) => {
  sortBy.value = value; currentPage.value = 1; await loadSongs()
}

// ── Select ──
const toggleAll = (e: Event) => {
  const checked = (e.target as HTMLInputElement).checked
  if (checked) {
    selectedIds.value = [...new Set([...selectedIds.value, ...songStore.songs.map(s => s.id)])]
  } else {
    const ids = new Set(songStore.songs.map(s => s.id))
    selectedIds.value = selectedIds.value.filter(id => !ids.has(id))
  }
}
const toggleSelect = (id: number) => {
  const idx = selectedIds.value.indexOf(id)
  if (idx === -1) selectedIds.value.push(id)
  else selectedIds.value.splice(idx, 1)
}
const confirmBulkDelete = () => {
  if (confirm(`Delete ${selectedIds.value.length} selected songs? This cannot be undone.`)) {
    selectedIds.value = []
  }
}

const ViewAllSongs = () => {
    router.push({ name: "admin.songsmanager.all" });
}

// ── Play (delegate to playerStore) ──
const playSong = (song: Song) => {
  player.play(song, songStore.songs)
}

// ── Navigation ──
const ViewAddSong = () => router.push({ name: 'admin.songsmanager.add' })

//method
async function deleteSong(id: number) {
    try {
        const result = await Swal.fire({
            title: 'Delete song',
            text: 'Are you sure you want to delete this song? This action cannot be undone.',
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
        await songStore.fetchDelete(id);
        await songStore.fetchSongs();
        notificationStore.notify("Delete song successful", "success");

        router.push({name:"admin.songsmanager.all"});

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


// ── Lifecycle ──
onMounted(() => loadSongs())
</script>

<style scoped>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

.songs-management {
  background-color: #1b2325;
  min-height: 100vh;
  padding: 32px 36px;
  font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  color: #e2e8f0;
}

/* ── Header ── */
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 32px;
}

.title {
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(90deg, #00d2ff, #7b2ff7);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  font-size: 13px;
  color: #64748b;
  margin-top: 4px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.btn-add {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  border: none;
  border-radius: 10px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.2s;
}

.btn-add:hover {
  opacity: 0.85;
}

.btn-icon {
  display: flex;
  align-items: center;
}

.search-box {
  position: relative;
  display: flex;
  align-items: center;
}

.search-box input {
  background: #1a1f2e;
  border: 1px solid #2d3748;
  border-radius: 10px;
  padding: 10px 42px 10px 16px;
  color: #e2e8f0;
  font-size: 14px;
  width: 220px;
  outline: none;
  transition: border-color 0.2s;
}

.search-box input::placeholder {
  color: #4a5568;
}

.search-box input:focus {
  border-color: #0072ff;
}

.search-icon {
  position: absolute;
  right: 14px;
  color: #4a5568;
  pointer-events: none;
}

/* ── Stat Cards ── */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 18px;
  margin-bottom: 28px;
}

.stat-card {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 14px;
  padding: 22px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  border-top: 3px solid transparent;
  position: relative;
  overflow: hidden;
}

.stat-card--blue  { border-top-color: #00c6ff; }
.stat-card--green { border-top-color: #43e97b; }
.stat-card--purple{ border-top-color: #a78bfa; }
.stat-card--orange{ border-top-color: #f59e0b; }

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  color: #94a3b8;
}

.stat-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat-label {
  font-size: 12px;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #f1f5f9;
  line-height: 1.1;
}

.stat-change {
  font-size: 12px;
  color: #64748b;
}

.stat-change.positive {
  color: #43e97b;
}

/* ── Table Section ── */

/* ─────────────────────────────────────────
   TOOLBAR
───────────────────────────────────────── */
.songs-list-page {
  --bg:        #111418;
  --surface:   #181c22;
  --surface-2: #1e2530;
  --surface-3: #252d3a;
  --border:    #252d3a;
  --border-2:  #2e3847;
  --text-1:    #f0f4f8;
  --text-2:    #8b9ab0;
  --text-3:    #4a5568;
  --accent:    #3b82f6;
  --accent-2:  #60a5fa;
  --green:     #22c55e;
  --red:       #ef4444;
  --cyan:      #06b6d4;

  background: var(--bg);
  min-height: 100vh;
  padding: 28px 24px 120px;
  font-family: 'SF Pro Display', 'Segoe UI', system-ui, sans-serif;
  color: var(--text-1);
  position: relative;
  overflow-x: hidden;
  border-radius: 12px;
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

.toolbar {
  display: flex; align-items: center; justify-content: space-between;
  flex-wrap: wrap; gap: 10px; margin-bottom: 18px;
}
.toolbar__left, .toolbar__right { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }

.search-box { position: relative; display: flex; align-items: center; }
.search-icon { position: absolute; left: 11px; color: var(--text-3); pointer-events: none; }
.search-box input {
  background: var(--surface); border: 1px solid var(--border-2); border-radius: 10px;
  padding: 9px 32px 9px 34px; color: var(--text-1); font-size: 13px; width: 230px;
  outline: none; transition: all .2s;
}
.search-box input::placeholder { color: var(--text-3); }
.search-box input:focus { border-color: var(--accent); background: var(--surface-2); box-shadow: 0 0 0 3px rgba(59,130,246,.1); }
.search-clear {
  position: absolute; right: 10px; background: none; border: none;
  color: var(--text-3); cursor: pointer; display: flex; align-items: center; padding: 2px; transition: color .2s;
}
.search-clear:hover { color: var(--text-1); }

.filter-select {
  background: var(--surface); border: 1px solid var(--border-2); border-radius: 10px;
  padding: 9px 12px; color: var(--text-2); font-size: 13px; outline: none; cursor: pointer; transition: border-color .2s;
}
.filter-select:hover { border-color: var(--border); }
.filter-select:focus { border-color: var(--accent); }
.filter-select--sm { padding: 6px 10px; font-size: 12px; }

.filter-indicator { display: flex; align-items: center; gap: 6px; }
.filter-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--accent); animation: pulse-dot 2s infinite; }
@keyframes pulse-dot { 0%,100% { opacity: 1; } 50% { opacity: .4; } }
.filter-clear-all { background: none; border: none; color: var(--accent-2); font-size: 12px; cursor: pointer; padding: 0; transition: color .15s; }
.filter-clear-all:hover { color: var(--text-1); }

.view-toggle {
  display: flex; background: var(--surface); border: 1px solid var(--border-2);
  border-radius: 10px; overflow: hidden; padding: 3px; gap: 2px;
}
.view-btn {
  width: 30px; height: 30px; background: none; border: none; color: var(--text-3);
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  border-radius: 7px; transition: all .2s;
}
.view-btn.active { background: var(--surface-3); color: var(--accent-2); }
.view-btn:hover:not(.active) { color: var(--text-2); }

.bulk-actions { display: flex; align-items: center; gap: 6px; }
.bulk-count {
  font-size: 12px; color: var(--text-2); background: var(--surface-2);
  border: 1px solid var(--border-2); padding: 5px 10px; border-radius: 8px;
}
.bulk-btn {
  display: flex; align-items: center; gap: 5px;
  padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: 500; cursor: pointer; transition: all .2s;
}
.bulk-btn--danger { background: rgba(239,68,68,.1); color: #f87171; border: 1px solid rgba(239,68,68,.25); }
.bulk-btn--danger:hover { background: rgba(239,68,68,.2); }
.bulk-btn--neutral { background: var(--surface-2); color: var(--text-2); border: 1px solid var(--border-2); }
.bulk-btn--neutral:hover { border-color: var(--border); color: var(--text-1); }

/* ─────────────────────────────────────────
   SKELETON
───────────────────────────────────────── */
.skeleton-table { background: var(--surface); border-radius: 14px; overflow: hidden; border: 1px solid var(--border); }
.skeleton-row {
  display: flex; align-items: center; gap: 16px; padding: 14px 20px;
  border-bottom: 1px solid var(--border); animation: skeleton-pulse 1.6s ease-in-out infinite;
}
.skeleton-row:last-child { border-bottom: none; }
.skel { border-radius: 6px; background: var(--surface-3); flex-shrink: 0; }
.skel--check    { width: 15px; height: 15px; border-radius: 4px; }
.skel--cover    { width: 38px; height: 38px; border-radius: 8px; }
.skel--cover-lg { width: 100%; height: 140px; border-radius: 0; }
.skel--title    { width: 120px; height: 12px; }
.skel--sub      { width: 80px; height: 10px; margin-top: 6px; }
.skel--md       { width: 90px; height: 12px; }
.skel--sm       { width: 60px; height: 12px; }
.skel--badge    { width: 50px; height: 20px; border-radius: 20px; }
.skel--plays    { width: 80px; height: 12px; }
.skel-song-cell { display: flex; align-items: center; gap: 12px; flex: 1; min-width: 0; }
.skel-text-col  { flex: 1; }
.skeleton-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; }
.skeleton-card { background: var(--surface); border-radius: 14px; overflow: hidden; border: 1px solid var(--border); animation: skeleton-pulse 1.6s ease-in-out infinite; }
.skel-card-body { padding: 14px; display: flex; flex-direction: column; gap: 8px; }
@keyframes skeleton-pulse { 0%,100% { opacity: 1; } 50% { opacity: .5; } }

/* ─────────────────────────────────────────
   ERROR
───────────────────────────────────────── */
.error-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 80px 0; gap: 12px; text-align: center; }
.error-icon { color: var(--red); opacity: .7; }
.error-title { font-size: 16px; font-weight: 600; color: var(--text-2); }
.error-msg   { font-size: 13px; color: var(--text-3); max-width: 300px; }
.btn-retry {
  display: flex; align-items: center; gap: 7px; padding: 9px 18px; border-radius: 10px;
  background: var(--surface-2); border: 1px solid var(--border-2);
  color: var(--text-2); font-size: 13px; font-weight: 500; cursor: pointer; transition: all .2s; margin-top: 8px;
}
.btn-retry:hover { border-color: var(--accent); color: var(--accent-2); }

/* ─────────────────────────────────────────
   TABLE
───────────────────────────────────────── */
.table-section { background: var(--surface); border-radius: 14px; overflow: hidden; border: 1px solid var(--border); }
.table-wrapper { overflow-x: auto; }
.songs-table { width: 100%; border-collapse: collapse; font-size: 13px;  }
.songs-table thead tr { background: var(--surface-2); border-bottom: 1px solid var(--border-2); }
.songs-table thead th {
  padding: 11px 16px; text-align: left;
  font-size: 11.5px; font-weight: 600; color: var(--text-3); letter-spacing: 0.04em;
  white-space: nowrap; user-select: none;
}
.th-check { width: 44px; }
.th-actions { width: 110px; text-align: right; }
.th-sortable { cursor: pointer; }
.th-sortable:hover { color: var(--text-2); }
.th-inner { display: inline-flex; align-items: center; gap: 4px; }
.sort-icon { opacity: .3; transition: opacity .2s; }
.sort-icon.active { opacity: 1; color: var(--accent-2); }

.table-row { border-bottom: 1px solid var(--border); transition: background .15s; animation: row-in .3s ease both; }
.table-row:last-child { border-bottom: none; }
.table-row:hover { background: rgba(255,255,255,.02); }
.table-row.selected { background: rgba(59,130,246,.05); }
.table-row.playing  { background: rgba(34,197,94,.04); }
@keyframes row-in { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

.songs-table td { padding: 11px 16px; vertical-align: middle; }
.td-check { width: 44px; }
.td-song  { min-width: 200px; }
.td-text  { color: var(--text-2); white-space: nowrap; }
.td-muted { color: var(--text-3); }
.td-mono  { font-variant-numeric: tabular-nums; }
.td-actions { width: 110px; }

/* checkbox */
.checkbox-wrap { position: relative; display: inline-flex; align-items: center; cursor: pointer; }
.checkbox-wrap input[type="checkbox"] { position: absolute; opacity: 0; width: 0; height: 0; }
.checkbox-custom {
  width: 15px; height: 15px; border-radius: 4px;
  border: 1.5px solid var(--border-2); background: transparent;
  display: flex; align-items: center; justify-content: center; transition: all .15s;
}
.checkbox-wrap input:checked + .checkbox-custom { background: var(--accent); border-color: var(--accent); }
.checkbox-wrap input:checked + .checkbox-custom::after {
  content: ''; display: block; width: 4px; height: 7px;
  border-right: 1.5px solid #fff; border-bottom: 1.5px solid #fff;
  transform: rotate(45deg) translateY(-1px);
}
.checkbox-wrap input:indeterminate + .checkbox-custom { background: var(--accent); border-color: var(--accent); }
.checkbox-wrap input:indeterminate + .checkbox-custom::after {
  content: ''; display: block; width: 7px; height: 1.5px; background: #fff;
}

/* song cell */
.song-cell { display: flex; align-items: center; gap: 11px; }
.song-cover {
  width: 38px; height: 38px; border-radius: 8px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden;
}
.song-info { min-width: 0;  flex: 1;   }
.song-title {
  font-size: 13.5px; font-weight: 600; color: var(--text-1);
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 180px;
}
.song-meta-sub { font-size: 11px; color: var(--text-3); margin-top: 1px; }

/* playing bars */
.cover-playing-overlay {
  position: absolute; inset: 0; background: rgba(0,0,0,.55);
  display: flex; align-items: flex-end; justify-content: center; gap: 2px; padding-bottom: 6px;
}
.cover-playing-overlay .bar,
.card-playing-indicator .bar {
  width: 3px; border-radius: 2px; background: var(--green); animation: sound-bar .9s ease-in-out infinite;
}
.cover-playing-overlay .bar:nth-child(1) { height: 6px; animation-delay: 0s; }
.cover-playing-overlay .bar:nth-child(2) { height: 10px; animation-delay: .15s; }
.cover-playing-overlay .bar:nth-child(3) { height: 7px; animation-delay: .3s; }
@keyframes sound-bar { 0%,100% { transform: scaleY(.4); } 50% { transform: scaleY(1); } }

/* badges */
.quality-badge {
  display: inline-flex; align-items: center; padding: 3px 9px; border-radius: 6px;
  font-size: 11px; font-weight: 600; letter-spacing: 0.03em; border: 1px solid transparent;
}
.quality-badge--sm { padding: 2px 7px; font-size: 10.5px; }
.quality--standard { background: rgba(100,116,139,.12); color: #94a3b8; border-color: rgba(100,116,139,.2); }
.quality--high     { background: rgba(6,182,212,.1);   color: #22d3ee; border-color: rgba(6,182,212,.2); }
.quality--lossless { background: rgba(139,92,246,.1);  color: #a78bfa; border-color: rgba(139,92,246,.2); }

/* plays */
.plays-cell { display: flex; align-items: center; gap: 8px; }
.plays-bar-wrap { width: 48px; }
.plays-bar  { height: 3px; background: var(--surface-3); border-radius: 2px; overflow: hidden; }
.plays-fill { height: 100%; background: linear-gradient(90deg, var(--accent), var(--cyan)); border-radius: 2px; transition: width .3s; }
.plays-num  { font-size: 12px; color: var(--text-3); white-space: nowrap; font-variant-numeric: tabular-nums; }

/* status */
.status-badge {
  display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px;
  border-radius: 20px; font-size: 11.5px; font-weight: 600; text-transform: capitalize;
}
.status-badge--sm { padding: 3px 7px; font-size: 11px; }
.status-dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }
.status--published  { background: rgba(34,197,94,.1);  color: #4ade80; }
.status--draft      { background: rgba(100,116,139,.12); color: #64748b; }
.status--blocked    { background: rgba(239,68,68,.1);  color: #f87171; }
.status--processing { background: rgba(245,158,11,.1); color: #fbbf24; }

/* action buttons */
.action-btns { display: flex; align-items: center; gap: 4px; justify-content: flex-end; }
.act-btn {
  width: 28px; height: 28px; border-radius: 8px;
  border: 1px solid var(--border-2); background: var(--surface-2);
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; color: var(--text-3); transition: all .2s;
}
.act-btn:hover { transform: translateY(-1px); }
.act-btn--play:hover, .act-btn--play.is-playing { border-color: var(--green); color: var(--green); background: rgba(34,197,94,.08); }
.act-btn--edit:hover   { border-color: var(--accent); color: var(--accent-2); background: rgba(59,130,246,.08); }
.act-btn--delete:hover { border-color: var(--red); color: #f87171; background: rgba(239,68,68,.08); }

/* ─────────────────────────────────────────
   GRID VIEW
───────────────────────────────────────── */
.grid-view { display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr)); gap: 14px; }

.song-card {
  background: var(--surface); border-radius: 14px; overflow: hidden; border: 1px solid var(--border);
  transition: transform .2s, border-color .2s, box-shadow .2s; animation: card-in .35s ease both;
}
.song-card:hover { transform: translateY(-3px); border-color: var(--border-2); box-shadow: 0 8px 24px rgba(0,0,0,.3); }
.song-card.is-playing { border-color: rgba(34,197,94,.3); box-shadow: 0 0 0 1px rgba(34,197,94,.15); }
@keyframes card-in { from { opacity: 0; transform: translateY(10px) scale(.98); } to { opacity: 1; transform: translateY(0) scale(1); } }

.card-cover { height: 148px; position: relative; display: flex; align-items: center; justify-content: center; overflow: hidden; }
.card-cover-fallback { display: flex; align-items: center; justify-content: center; width: 100%; height: 100%; }

.card-playing-indicator { position: absolute; bottom: 10px; left: 12px; display: flex; align-items: flex-end; gap: 2px; height: 16px; }
.card-playing-indicator .bar:nth-child(1) { height: 8px;  animation-delay: 0s; }
.card-playing-indicator .bar:nth-child(2) { height: 14px; animation-delay: .2s; }
.card-playing-indicator .bar:nth-child(3) { height: 10px; animation-delay: .1s; }
.card-playing-indicator .bar:nth-child(4) { height: 6px;  animation-delay: .3s; }

.card-overlay {
  position: absolute; inset: 0; background: rgba(0,0,0,.45);
  display: flex; align-items: center; justify-content: center; opacity: 0; transition: opacity .2s;
}
.song-card:hover .card-overlay,
.song-card.is-playing .card-overlay { opacity: 1; }

.card-play-btn {
  width: 46px; height: 46px; border-radius: 50%;
  background: rgba(255,255,255,.15); border: 2px solid rgba(255,255,255,.5);
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; transition: all .2s; backdrop-filter: blur(4px);
}
.card-play-btn:hover { background: rgba(255,255,255,.3); transform: scale(1.05); }

.card-top-badges { position: absolute; top: 8px; left: 8px; display: flex; gap: 4px; align-items: center; }
.card-badge { font-size: 10px; font-weight: 700; padding: 2px 7px; border-radius: 5px; }
.card-badge--featured { background: rgba(251,191,36,.2); color: #fbbf24; }
.card-badge--explicit { background: rgba(239,68,68,.2);  color: #f87171; }

.card-duration {
  position: absolute; bottom: 8px; right: 8px;
  font-size: 11px; color: rgba(255,255,255,.85);
  background: rgba(0,0,0,.5); padding: 2px 7px; border-radius: 5px;
  font-variant-numeric: tabular-nums; backdrop-filter: blur(4px);
}

.card-body        { padding: 13px 14px; }
.card-header-row  { display: flex; justify-content: space-between; align-items: flex-start; gap: 8px; }
.card-title-group { min-width: 0; flex: 1; }
.card-title       { font-size: 13.5px; font-weight: 600; color: var(--text-1); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.card-artist      { font-size: 12px; color: var(--text-3); margin-top: 2px; }
.card-divider     { height: 1px; background: var(--border); margin: 10px 0; }
.card-meta-row    { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
.card-stats       { display: flex; gap: 10px; }
.card-stat        { display: flex; align-items: center; gap: 4px; font-size: 11.5px; color: var(--text-3); }
.card-footer-row  { display: flex; align-items: center; justify-content: space-between; }
.card-date        { font-size: 11px; color: var(--text-3); }

/* ─────────────────────────────────────────
   EMPTY
───────────────────────────────────────── */
.empty-state { display: flex; flex-direction: column; align-items: center; padding: 80px 0; gap: 10px; text-align: center; }
.empty-illustration { color: var(--surface-3); margin-bottom: 8px; }
.empty-title { font-size: 16px; font-weight: 600; color: var(--text-3); }
.empty-sub   { font-size: 13px; color: var(--text-3); opacity: .6; }

/* ─────────────────────────────────────────
   PAGINATION
───────────────────────────────────────── */
.pagination { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; margin-top: 18px; gap: 12px; }
.pagination-info { font-size: 13px; color: var(--text-3); }
.pagination-info strong { color: var(--text-2); }
.pagination-sep  { margin: 0 6px; }
.pagination-controls { display: flex; align-items: center; gap: 4px; }
.per-page       { display: flex; align-items: center; gap: 8px; }
.per-page-label { font-size: 12px; color: var(--text-3); white-space: nowrap; }

.page-btn {
  min-width: 32px; height: 32px; border-radius: 8px;
  border: 1px solid var(--border-2); background: var(--surface);
  color: var(--text-3); font-size: 13px; cursor: pointer;
  display: flex; align-items: center; justify-content: center; transition: all .2s; padding: 0 4px;
}
.page-btn--arrow { background: var(--surface-2); }
.page-btn.ellipsis { border-color: transparent; background: transparent; cursor: default; }
.page-btn:hover:not(:disabled):not(.ellipsis):not(.active) { border-color: var(--accent); color: var(--accent-2); }
.page-btn.active   { background: var(--accent); border-color: var(--accent); color: #fff; font-weight: 600; }
.page-btn:disabled { opacity: .3; cursor: not-allowed; }

/* ─────────────────────────────────────────
   TRANSITIONS
───────────────────────────────────────── */
.fade-enter-active, .fade-leave-active { transition: opacity .25s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

.view-switch-enter-active, .view-switch-leave-active { transition: opacity .2s ease, transform .2s ease; }
.view-switch-enter-from, .view-switch-leave-to { opacity: 0; transform: translateY(6px); }

.row-move, .card-move { transition: transform .3s ease; }

/* ─────────────────────────────────────────
   RESPONSIVE
───────────────────────────────────────── */
@media (max-width: 768px) {
  .songs-list-page { padding: 18px 14px 120px; }
  .page-header { flex-direction: column; align-items: flex-start; }
  .toolbar { flex-direction: column; align-items: stretch; }
  .toolbar__left, .toolbar__right { flex-wrap: wrap; }
  .search-box input { width: 100%; }
  .grid-view { grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); }
}

/* Action buttons */
.action-buttons {
  display: flex;
  align-items: center;
  gap: 6px;
}

.action-btn {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  border: 1px solid #2d3748;
  background: #1e2535;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: border-color 0.2s, background 0.2s;
  color: #94a3b8;
}

.action-btn--edit:hover {
  border-color: #00c6ff;
  color: #00c6ff;
  background: rgba(0, 198, 255, 0.08);
}

.action-btn--delete:hover {
  border-color: #f87171;
  color: #f87171;
  background: rgba(248, 113, 113, 0.08);
}

.action-btn--view:hover {
  border-color: #43e97b;
  color: #43e97b;
  background: rgba(67, 233, 123, 0.08);
}

/* ── Pagination ── */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid #1e2535;
}

.pagination-info {
  font-size: 13px;
  color: #4a5568;
}

.pagination-controls {
  display: flex;
  align-items: center;
  gap: 6px;
}

.page-btn {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  border: 1px solid #2d3748;
  background: #1e2535;
  color: #64748b;
  font-size: 13px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s, border-color 0.2s;
}

.page-btn:hover:not(:disabled) {
  border-color: #00c6ff;
  color: #00c6ff;
}

.page-btn.active {
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  border-color: transparent;
  color: #fff;
  font-weight: 600;
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.genre-tag {
  display: inline-block;
  padding: 4px 10px;
  font-size: 11px;
  font-weight: 500;
  border-radius: 999px;
  border: 1px solid;
  line-height: 1;
  white-space: nowrap;

  /* nền nhẹ theo màu */
  background-color: rgba(0, 0, 0, 0.05);
}

/* ── Responsive ── */
@media (max-width: 1024px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .songs-management {
    padding: 20px 16px;
  }

  .header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .stats-grid {
    grid-template-columns: 1fr 1fr;
  }
}
</style>