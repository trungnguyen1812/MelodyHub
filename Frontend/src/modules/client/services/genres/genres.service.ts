import clientApi from '@/plugins/axios';

class GenreService {

    async getAllGenres() {
        const res = await clientApi.get("/genres");
        return res.data;
    }

    async getGenreDetail(slug: string) {
        const res = await clientApi.get(`/genres/${slug}`);
        return res.data;
    }
}

export default new GenreService();