// types/album-statistics.interface.ts
export interface AlbumStatistics {
    total_albums: number;
    new_albums_this_month: number;
    new_albums_last_month: number;
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

export interface FormattedAlbumStatistics {
    totalAlbums: {
        value: number;
        label: string;
        change: string;
        changeType: 'positive' | 'negative';
        iconType: 'total';
    };
    newAlbumsThisMonth: {
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