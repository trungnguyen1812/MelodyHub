interface Song {
  id?: number;
  title: string;
  artist: string;
  popularity: number;
  cover?: string;
  image?: string;
  duration?: string;
  plays?: number[];
  totalPlays?: string;
  album?: string;
  releaseDate?: string;
  genre?: string[];
  isExplicit?: boolean;
  lyrics?: boolean;
}