// Dữ liệu mẫu (sau này gọi API thật)
const allArtists = [
  {
    id: 1,
    name: "Sơn Tùng M-TP",
    slug: "SonTungMtp",
    songs: [
      { id: 1, title: "Lạc Trôi", duration: "3:45" },
      { id: 2, title: "Chạy Ngay Đi", duration: "4:10" },
    ],
  },
  // ... các artist khác
];

export async function getSongsByArtistSlug(slug: string) {
  const artist = allArtists.find((a) => a.slug === slug);
  return artist ? artist.songs : [];
}

export async function getArtistBySlug(slug: string) {
  return allArtists.find((a) => a.slug === slug) || null;
}
