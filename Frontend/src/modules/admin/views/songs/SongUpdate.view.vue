<template>
  <div class="songs-manager">
    <!-- Header -->
    <div class="manager-header">
      <h1>Songs Manager</h1>
      <button class="btn-add">
        <i class="fas fa-plus"></i> Add Song
      </button>
    </div>

    <!-- Search -->
    <div class="search-section">
      <input 
        type="text" 
        placeholder="Search songs..."
      />
    </div>

    <!-- Filter Tabs -->
    <div class="filter-tabs">
      <button class="filter-btn active">All Songs</button>
      <button class="filter-btn">Favorites</button>
      <button class="filter-btn">Recently Added</button>
    </div>

    <!-- Songs Table -->
    <div class="songs-table">
      <!-- Table Header -->
      <div class="table-header">
        <div class="col-title">Title</div>
        <div class="col-artist">Artist</div>
        <div class="col-album">Album</div>
        <div class="col-duration">Duration</div>
        <div class="col-actions">Actions</div>
      </div>

      <!-- Song Items -->
      <div class="song-item">
        <div class="col-title">Bohemian Rhapsody</div>
        <div class="col-artist">Queen</div>
        <div class="col-album">A Night at the Opera</div>
        <div class="col-duration">5:55</div>
        <div class="col-actions">
          <button class="action-btn play">▶</button>
          <button class="action-btn edit">✎</button>
          <button class="action-btn delete">🗑</button>
        </div>
      </div>

      <div class="song-item">
        <div class="col-title">Hotel California</div>
        <div class="col-artist">Eagles</div>
        <div class="col-album">Hotel California</div>
        <div class="col-duration">6:30</div>
        <div class="col-actions">
          <button class="action-btn play">▶</button>
          <button class="action-btn edit">✎</button>
          <button class="action-btn delete">🗑</button>
        </div>
      </div>

      <div class="song-item">
        <div class="col-title">Shape of You</div>
        <div class="col-artist">Ed Sheeran</div>
        <div class="col-album">÷</div>
        <div class="col-duration">3:53</div>
        <div class="col-actions">
          <button class="action-btn play">▶</button>
          <button class="action-btn edit">✎</button>
          <button class="action-btn delete">🗑</button>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div class="empty-state">
      <p>No songs found</p>
      <button class="btn-add-first">Add your first song</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SongsManagerView'
}
</script>

<style scoped>
.songs-manager {
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Header */
.manager-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.manager-header h1 {
  font-size: 28px;
  margin: 0;
  color: #333;
}

.btn-add {
  background: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.btn-add:hover {
  background: #0056b3;
}

/* Search */
.search-section {
  margin-bottom: 20px;
}

.search-section input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
  box-sizing: border-box;
}

.search-section input:focus {
  outline: none;
  border-color: #007bff;
}

/* Filter Tabs */
.filter-tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 24px;
}

.filter-btn {
  padding: 8px 16px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 20px;
  cursor: pointer;
  font-size: 14px;
}

.filter-btn.active {
  background: #007bff;
  color: white;
  border-color: #007bff;
}

/* Songs Table */
.songs-table {
  background: white;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  overflow: hidden;
}

.table-header {
  display: grid;
  grid-template-columns: 3fr 2fr 2fr 1fr 1.5fr;
  padding: 15px;
  background: #f8f9fa;
  border-bottom: 1px solid #dee2e6;
  font-weight: 600;
  color: #495057;
}

.song-item {
  display: grid;
  grid-template-columns: 3fr 2fr 2fr 1fr 1.5fr;
  padding: 15px;
  border-bottom: 1px solid #eee;
  align-items: center;
}

.song-item:hover {
  background: #f8f9fa;
}

/* Actions */
.col-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 4px 8px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.action-btn.play:hover {
  background: #28a745;
  color: white;
  border-color: #28a745;
}

.action-btn.edit:hover {
  background: #ffc107;
  color: white;
  border-color: #ffc107;
}

.action-btn.delete:hover {
  background: #dc3545;
  color: white;
  border-color: #dc3545;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #666;
}

.empty-state p {
  font-size: 16px;
  margin-bottom: 16px;
}

.btn-add-first {
  background: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.btn-add-first:hover {
  background: #0056b3;
}

/* Responsive */
@media (max-width: 768px) {
  .table-header {
    display: none;
  }

  .song-item {
    grid-template-columns: 1fr;
    gap: 10px;
    padding: 20px;
  }

  .col-actions {
    justify-content: flex-start;
  }
}
</style>