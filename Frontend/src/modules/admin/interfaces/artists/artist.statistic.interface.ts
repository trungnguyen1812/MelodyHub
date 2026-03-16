// types/artist-statistics.interface.ts
export interface ArtistStatistics {
    total_artists: number;
    new_artists_this_month: number;
    new_artists_last_month: number;
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

export interface FormattedArtistStatistics {
    totalArtists: {
        value: number;
        label: string;
        change: string;
        changeType: 'positive' | 'negative';
        iconType: 'total';
    };
    newArtistsThisMonth: {
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