// services/songActionService.ts
import clientApi from '@/plugins/axios';

class SongActionService {
  // Định nghĩa các method riêng
  async likeSong(id: number, isLiked: boolean) {    
    return clientApi.post(`/songLike/${id}/like`, { is_liked: isLiked });
  }
  
  async shareSong(id: number) {
    return clientApi.post(`/songLike/${id}/share`, { shared: true });
  }
  
  async downloadSong(id: number, quality: string = 'standard') {
    return clientApi.post(`/songLike/${id}/download`, { quality });
  }
  
  async likeComment(commentId: number, isLiked: boolean) {
    return clientApi.post(`/comments/${commentId}/like`, { is_liked: isLiked });
  }
  async FollowArtist(id: number, is_followed: boolean) {    
    return clientApi.post(`/artists/${id}/follow`, { is_followed : is_followed });
  }
}

export default new SongActionService();