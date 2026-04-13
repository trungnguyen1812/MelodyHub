// types/genre-statistics.interface.ts
export interface GenreStatistics {
    total_genres: number;
    new_genres_this_month: number;
    new_genres_last_month: number;
    growth_percentage: number;
    status: 'increase' | 'decrease';
}

export interface ApiResponse<T> {
    success: boolean;
    message: string;
    data: T;
}

export interface StatCardProps {
    title: string;
    value: number | string;
    change?: string;
    changeType?: 'positive' | 'negative';
    iconType: 'total' | 'new' | 'growth';
}

export interface FormattedGenreStatistics {
    totalGenres: {
        value: number;
        label: string;
        change: string;
        changeType: 'positive' | 'negative';
        iconType: 'total';
    };
    newGenresThisMonth: {
        value: number;
        label: string;
        change: string;
        changeType: 'positive' | 'negative';
        iconType: 'new';
    };
    growth: {
        value: string;
        label: string;
        change: string;
        changeType: 'positive' | 'negative';
        iconType: 'growth';
    };
}