export type CopyrightType =
    | 'author'
    | 'performer'
    | 'producer'
    | 'publisher'
    | 'exclusive'
    | 'non_exclusive'
    | 'creative_commons'
    | 'public_domain';

export type CopyrightStatus = 'active' | 'expired' | 'pending' | 'disputed' | 'revoked';

export interface CopyrightFormData {
    song_id: number | string;
    partner_id?: number | string;
    copyright_type: CopyrightType;
    owner_name: string;
    registration_number?: string;
    registration_date?: string;
    registration_country?: string;
    valid_from: string;
    valid_until?: string;
    territory?: string;
    rights_included?: string; // JSON string
    document_url?: string;
    notes?: string;
    status?: CopyrightStatus;
    verified_at?: string;
    verified_by?: number;
    contract_file?: File;
}

export interface Copyright {
    id: number;
    song_id: number;
    partner_id: number;
    copyright_type: CopyrightType;
    owner_name: string;
    registration_number: string | null;
    registration_date: string | null;
    registration_country: string | null;
    valid_from: string;
    valid_until: string | null;
    territory: string | null;
    rights_included: string | null; // JSON string
    document_url: string | null;
    notes: string | null;
    status: CopyrightStatus;
    verified_at: string | null;
    verified_by: number | null;
    created_at: string;
    updated_at: string;

    // Relationships
    partner?: {
        id: number;
        name: string;
        user_id: number;
        status: string;
    };
    song?: {
        id: number;
        title: string;
        cover_url?: string | null;
        artist?: {
            id: number;
            name: string;
        };
    };
}
