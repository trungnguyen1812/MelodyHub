#!/bin/bash
# MelodyHub Migration Generator Script
# Run with: bash create_all_migrations.sh

tables=(
activity_logs
albums
artists
cache
cache_locks
comments
copyright_claims
downloads
failed_jobs
genre_song
genres
job_batches
jobs
migrations
notifications
partner_applications
payments
permissions
personal_access_tokens
playlist_songs
playlists
recommendations
reports
role_permission
roles
song_likes
song_plays
songs
subscriptions
system_settings
user_statistics
users
)

for table in "${tables[@]}"; do
  php artisan make:migration create_${table}_table
done
