// ─────────────────────────────────────────────────────────────
//  countries.ts
//  Danh sách quốc gia theo chuẩn music platform (Spotify / Apple Music)
//  Chia theo region để dễ filter UI
// ─────────────────────────────────────────────────────────────

export interface Country {
  code: string        // ISO 3166-1 alpha-2
  name: string
  nativeName: string  // tên bản địa
  flag: string        // emoji flag
  region: CountryRegion
  currency: string    // ISO 4217
  dialCode: string    // e.g. "+84"
  timezone: string    // IANA timezone (primary)
  musicMarket: boolean // có trong Spotify/Apple Music market list
}

export type CountryRegion =
  | 'southeast_asia'
  | 'east_asia'
  | 'south_asia'
  | 'oceania'
  | 'north_america'
  | 'latin_america'
  | 'europe'
  | 'middle_east'
  | 'africa'

export const COUNTRIES: Country[] = [
  // ── Southeast Asia ──────────────────────────────────────────
  {
    code: 'VN', name: 'Vietnam',          nativeName: 'Việt Nam',
    flag: '🇻🇳', region: 'southeast_asia',
    currency: 'VND', dialCode: '+84',    timezone: 'Asia/Ho_Chi_Minh', musicMarket: true
  },
  {
    code: 'TH', name: 'Thailand',         nativeName: 'ประเทศไทย',
    flag: '🇹🇭', region: 'southeast_asia',
    currency: 'THB', dialCode: '+66',    timezone: 'Asia/Bangkok',      musicMarket: true
  },
  {
    code: 'ID', name: 'Indonesia',        nativeName: 'Indonesia',
    flag: '🇮🇩', region: 'southeast_asia',
    currency: 'IDR', dialCode: '+62',    timezone: 'Asia/Jakarta',      musicMarket: true
  },
  {
    code: 'PH', name: 'Philippines',      nativeName: 'Pilipinas',
    flag: '🇵🇭', region: 'southeast_asia',
    currency: 'PHP', dialCode: '+63',    timezone: 'Asia/Manila',       musicMarket: true
  },
  {
    code: 'MY', name: 'Malaysia',         nativeName: 'Malaysia',
    flag: '🇲🇾', region: 'southeast_asia',
    currency: 'MYR', dialCode: '+60',    timezone: 'Asia/Kuala_Lumpur', musicMarket: true
  },
  {
    code: 'SG', name: 'Singapore',        nativeName: 'Singapore',
    flag: '🇸🇬', region: 'southeast_asia',
    currency: 'SGD', dialCode: '+65',    timezone: 'Asia/Singapore',    musicMarket: true
  },
  {
    code: 'MM', name: 'Myanmar',          nativeName: 'မြန်မာ',
    flag: '🇲🇲', region: 'southeast_asia',
    currency: 'MMK', dialCode: '+95',    timezone: 'Asia/Rangoon',      musicMarket: true
  },
  {
    code: 'KH', name: 'Cambodia',         nativeName: 'កម្ពុជា',
    flag: '🇰🇭', region: 'southeast_asia',
    currency: 'KHR', dialCode: '+855',   timezone: 'Asia/Phnom_Penh',   musicMarket: true
  },
  {
    code: 'LA', name: 'Laos',             nativeName: 'ລາວ',
    flag: '🇱🇦', region: 'southeast_asia',
    currency: 'LAK', dialCode: '+856',   timezone: 'Asia/Vientiane',    musicMarket: false
  },
  {
    code: 'BN', name: 'Brunei',           nativeName: 'Brunei',
    flag: '🇧🇳', region: 'southeast_asia',
    currency: 'BND', dialCode: '+673',   timezone: 'Asia/Brunei',       musicMarket: true
  },
  {
    code: 'TL', name: 'Timor-Leste',      nativeName: 'Timor-Leste',
    flag: '🇹🇱', region: 'southeast_asia',
    currency: 'USD', dialCode: '+670',   timezone: 'Asia/Dili',         musicMarket: false
  },

  // ── East Asia ───────────────────────────────────────────────
  {
    code: 'JP', name: 'Japan',            nativeName: '日本',
    flag: '🇯🇵', region: 'east_asia',
    currency: 'JPY', dialCode: '+81',    timezone: 'Asia/Tokyo',        musicMarket: true
  },
  {
    code: 'KR', name: 'South Korea',      nativeName: '대한민국',
    flag: '🇰🇷', region: 'east_asia',
    currency: 'KRW', dialCode: '+82',    timezone: 'Asia/Seoul',        musicMarket: true
  },
  {
    code: 'TW', name: 'Taiwan',           nativeName: '台灣',
    flag: '🇹🇼', region: 'east_asia',
    currency: 'TWD', dialCode: '+886',   timezone: 'Asia/Taipei',       musicMarket: true
  },
  {
    code: 'HK', name: 'Hong Kong',        nativeName: '香港',
    flag: '🇭🇰', region: 'east_asia',
    currency: 'HKD', dialCode: '+852',   timezone: 'Asia/Hong_Kong',    musicMarket: true
  },
  {
    code: 'MO', name: 'Macau',            nativeName: '澳門',
    flag: '🇲🇴', region: 'east_asia',
    currency: 'MOP', dialCode: '+853',   timezone: 'Asia/Macau',        musicMarket: true
  },
  {
    code: 'CN', name: 'China',            nativeName: '中国',
    flag: '🇨🇳', region: 'east_asia',
    currency: 'CNY', dialCode: '+86',    timezone: 'Asia/Shanghai',     musicMarket: false
  },
  {
    code: 'MN', name: 'Mongolia',         nativeName: 'Монгол',
    flag: '🇲🇳', region: 'east_asia',
    currency: 'MNT', dialCode: '+976',   timezone: 'Asia/Ulaanbaatar',  musicMarket: true
  },

  // ── South Asia ──────────────────────────────────────────────
  {
    code: 'IN', name: 'India',            nativeName: 'भारत',
    flag: '🇮🇳', region: 'south_asia',
    currency: 'INR', dialCode: '+91',    timezone: 'Asia/Kolkata',      musicMarket: true
  },
  {
    code: 'PK', name: 'Pakistan',         nativeName: 'پاکستان',
    flag: '🇵🇰', region: 'south_asia',
    currency: 'PKR', dialCode: '+92',    timezone: 'Asia/Karachi',      musicMarket: true
  },
  {
    code: 'BD', name: 'Bangladesh',       nativeName: 'বাংলাদেশ',
    flag: '🇧🇩', region: 'south_asia',
    currency: 'BDT', dialCode: '+880',   timezone: 'Asia/Dhaka',        musicMarket: true
  },
  {
    code: 'LK', name: 'Sri Lanka',        nativeName: 'ශ්‍රී ලංකා',
    flag: '🇱🇰', region: 'south_asia',
    currency: 'LKR', dialCode: '+94',    timezone: 'Asia/Colombo',      musicMarket: true
  },
  {
    code: 'NP', name: 'Nepal',            nativeName: 'नेपाल',
    flag: '🇳🇵', region: 'south_asia',
    currency: 'NPR', dialCode: '+977',   timezone: 'Asia/Kathmandu',    musicMarket: true
  },

  // ── Oceania ─────────────────────────────────────────────────
  {
    code: 'AU', name: 'Australia',        nativeName: 'Australia',
    flag: '🇦🇺', region: 'oceania',
    currency: 'AUD', dialCode: '+61',    timezone: 'Australia/Sydney',  musicMarket: true
  },
  {
    code: 'NZ', name: 'New Zealand',      nativeName: 'New Zealand',
    flag: '🇳🇿', region: 'oceania',
    currency: 'NZD', dialCode: '+64',    timezone: 'Pacific/Auckland',  musicMarket: true
  },
  {
    code: 'FJ', name: 'Fiji',             nativeName: 'Fiji',
    flag: '🇫🇯', region: 'oceania',
    currency: 'FJD', dialCode: '+679',   timezone: 'Pacific/Fiji',      musicMarket: true
  },
  {
    code: 'PG', name: 'Papua New Guinea', nativeName: 'Papua New Guinea',
    flag: '🇵🇬', region: 'oceania',
    currency: 'PGK', dialCode: '+675',   timezone: 'Pacific/Port_Moresby', musicMarket: false
  },

  // ── North America ───────────────────────────────────────────
  {
    code: 'US', name: 'United States',    nativeName: 'United States',
    flag: '🇺🇸', region: 'north_america',
    currency: 'USD', dialCode: '+1',     timezone: 'America/New_York',  musicMarket: true
  },
  {
    code: 'CA', name: 'Canada',           nativeName: 'Canada',
    flag: '🇨🇦', region: 'north_america',
    currency: 'CAD', dialCode: '+1',     timezone: 'America/Toronto',   musicMarket: true
  },
  {
    code: 'MX', name: 'Mexico',           nativeName: 'México',
    flag: '🇲🇽', region: 'north_america',
    currency: 'MXN', dialCode: '+52',    timezone: 'America/Mexico_City', musicMarket: true
  },

  // ── Latin America ───────────────────────────────────────────
  {
    code: 'BR', name: 'Brazil',           nativeName: 'Brasil',
    flag: '🇧🇷', region: 'latin_america',
    currency: 'BRL', dialCode: '+55',    timezone: 'America/Sao_Paulo', musicMarket: true
  },
  {
    code: 'AR', name: 'Argentina',        nativeName: 'Argentina',
    flag: '🇦🇷', region: 'latin_america',
    currency: 'ARS', dialCode: '+54',    timezone: 'America/Argentina/Buenos_Aires', musicMarket: true
  },
  {
    code: 'CO', name: 'Colombia',         nativeName: 'Colombia',
    flag: '🇨🇴', region: 'latin_america',
    currency: 'COP', dialCode: '+57',    timezone: 'America/Bogota',    musicMarket: true
  },
  {
    code: 'CL', name: 'Chile',            nativeName: 'Chile',
    flag: '🇨🇱', region: 'latin_america',
    currency: 'CLP', dialCode: '+56',    timezone: 'America/Santiago',  musicMarket: true
  },
  {
    code: 'PE', name: 'Peru',             nativeName: 'Perú',
    flag: '🇵🇪', region: 'latin_america',
    currency: 'PEN', dialCode: '+51',    timezone: 'America/Lima',      musicMarket: true
  },
  {
    code: 'EC', name: 'Ecuador',          nativeName: 'Ecuador',
    flag: '🇪🇨', region: 'latin_america',
    currency: 'USD', dialCode: '+593',   timezone: 'America/Guayaquil', musicMarket: true
  },

  // ── Europe ──────────────────────────────────────────────────
  {
    code: 'GB', name: 'United Kingdom',   nativeName: 'United Kingdom',
    flag: '🇬🇧', region: 'europe',
    currency: 'GBP', dialCode: '+44',    timezone: 'Europe/London',     musicMarket: true
  },
  {
    code: 'DE', name: 'Germany',          nativeName: 'Deutschland',
    flag: '🇩🇪', region: 'europe',
    currency: 'EUR', dialCode: '+49',    timezone: 'Europe/Berlin',     musicMarket: true
  },
  {
    code: 'FR', name: 'France',           nativeName: 'France',
    flag: '🇫🇷', region: 'europe',
    currency: 'EUR', dialCode: '+33',    timezone: 'Europe/Paris',      musicMarket: true
  },
  {
    code: 'ES', name: 'Spain',            nativeName: 'España',
    flag: '🇪🇸', region: 'europe',
    currency: 'EUR', dialCode: '+34',    timezone: 'Europe/Madrid',     musicMarket: true
  },
  {
    code: 'IT', name: 'Italy',            nativeName: 'Italia',
    flag: '🇮🇹', region: 'europe',
    currency: 'EUR', dialCode: '+39',    timezone: 'Europe/Rome',       musicMarket: true
  },
  {
    code: 'NL', name: 'Netherlands',      nativeName: 'Nederland',
    flag: '🇳🇱', region: 'europe',
    currency: 'EUR', dialCode: '+31',    timezone: 'Europe/Amsterdam',  musicMarket: true
  },
  {
    code: 'SE', name: 'Sweden',           nativeName: 'Sverige',
    flag: '🇸🇪', region: 'europe',
    currency: 'SEK', dialCode: '+46',    timezone: 'Europe/Stockholm',  musicMarket: true
  },
  {
    code: 'NO', name: 'Norway',           nativeName: 'Norge',
    flag: '🇳🇴', region: 'europe',
    currency: 'NOK', dialCode: '+47',    timezone: 'Europe/Oslo',       musicMarket: true
  },
  {
    code: 'DK', name: 'Denmark',          nativeName: 'Danmark',
    flag: '🇩🇰', region: 'europe',
    currency: 'DKK', dialCode: '+45',    timezone: 'Europe/Copenhagen', musicMarket: true
  },
  {
    code: 'FI', name: 'Finland',          nativeName: 'Suomi',
    flag: '🇫🇮', region: 'europe',
    currency: 'EUR', dialCode: '+358',   timezone: 'Europe/Helsinki',   musicMarket: true
  },
  {
    code: 'PL', name: 'Poland',           nativeName: 'Polska',
    flag: '🇵🇱', region: 'europe',
    currency: 'PLN', dialCode: '+48',    timezone: 'Europe/Warsaw',     musicMarket: true
  },
  {
    code: 'PT', name: 'Portugal',         nativeName: 'Portugal',
    flag: '🇵🇹', region: 'europe',
    currency: 'EUR', dialCode: '+351',   timezone: 'Europe/Lisbon',     musicMarket: true
  },
  {
    code: 'CH', name: 'Switzerland',      nativeName: 'Schweiz',
    flag: '🇨🇭', region: 'europe',
    currency: 'CHF', dialCode: '+41',    timezone: 'Europe/Zurich',     musicMarket: true
  },
  {
    code: 'BE', name: 'Belgium',          nativeName: 'België',
    flag: '🇧🇪', region: 'europe',
    currency: 'EUR', dialCode: '+32',    timezone: 'Europe/Brussels',   musicMarket: true
  },
  {
    code: 'AT', name: 'Austria',          nativeName: 'Österreich',
    flag: '🇦🇹', region: 'europe',
    currency: 'EUR', dialCode: '+43',    timezone: 'Europe/Vienna',     musicMarket: true
  },
  {
    code: 'IE', name: 'Ireland',          nativeName: 'Ireland',
    flag: '🇮🇪', region: 'europe',
    currency: 'EUR', dialCode: '+353',   timezone: 'Europe/Dublin',     musicMarket: true
  },
  {
    code: 'GR', name: 'Greece',           nativeName: 'Ελλάδα',
    flag: '🇬🇷', region: 'europe',
    currency: 'EUR', dialCode: '+30',    timezone: 'Europe/Athens',     musicMarket: true
  },
  {
    code: 'RO', name: 'Romania',          nativeName: 'România',
    flag: '🇷🇴', region: 'europe',
    currency: 'RON', dialCode: '+40',    timezone: 'Europe/Bucharest',  musicMarket: true
  },
  {
    code: 'CZ', name: 'Czech Republic',   nativeName: 'Česká republika',
    flag: '🇨🇿', region: 'europe',
    currency: 'CZK', dialCode: '+420',   timezone: 'Europe/Prague',     musicMarket: true
  },
  {
    code: 'HU', name: 'Hungary',          nativeName: 'Magyarország',
    flag: '🇭🇺', region: 'europe',
    currency: 'HUF', dialCode: '+36',    timezone: 'Europe/Budapest',   musicMarket: true
  },
  {
    code: 'SK', name: 'Slovakia',         nativeName: 'Slovensko',
    flag: '🇸🇰', region: 'europe',
    currency: 'EUR', dialCode: '+421',   timezone: 'Europe/Bratislava', musicMarket: true
  },
  {
    code: 'UA', name: 'Ukraine',          nativeName: 'Україна',
    flag: '🇺🇦', region: 'europe',
    currency: 'UAH', dialCode: '+380',   timezone: 'Europe/Kiev',       musicMarket: true
  },
  {
    code: 'TR', name: 'Turkey',           nativeName: 'Türkiye',
    flag: '🇹🇷', region: 'europe',
    currency: 'TRY', dialCode: '+90',    timezone: 'Europe/Istanbul',   musicMarket: true
  },

  // ── Middle East ─────────────────────────────────────────────
  {
    code: 'SA', name: 'Saudi Arabia',     nativeName: 'المملكة العربية السعودية',
    flag: '🇸🇦', region: 'middle_east',
    currency: 'SAR', dialCode: '+966',   timezone: 'Asia/Riyadh',       musicMarket: true
  },
  {
    code: 'AE', name: 'UAE',              nativeName: 'الإمارات العربية المتحدة',
    flag: '🇦🇪', region: 'middle_east',
    currency: 'AED', dialCode: '+971',   timezone: 'Asia/Dubai',        musicMarket: true
  },
  {
    code: 'EG', name: 'Egypt',            nativeName: 'مصر',
    flag: '🇪🇬', region: 'middle_east',
    currency: 'EGP', dialCode: '+20',    timezone: 'Africa/Cairo',      musicMarket: true
  },
  {
    code: 'QA', name: 'Qatar',            nativeName: 'قطر',
    flag: '🇶🇦', region: 'middle_east',
    currency: 'QAR', dialCode: '+974',   timezone: 'Asia/Qatar',        musicMarket: true
  },
  {
    code: 'KW', name: 'Kuwait',           nativeName: 'الكويت',
    flag: '🇰🇼', region: 'middle_east',
    currency: 'KWD', dialCode: '+965',   timezone: 'Asia/Kuwait',       musicMarket: true
  },
  {
    code: 'BH', name: 'Bahrain',          nativeName: 'البحرين',
    flag: '🇧🇭', region: 'middle_east',
    currency: 'BHD', dialCode: '+973',   timezone: 'Asia/Bahrain',      musicMarket: true
  },
  {
    code: 'OM', name: 'Oman',             nativeName: 'عُمان',
    flag: '🇴🇲', region: 'middle_east',
    currency: 'OMR', dialCode: '+968',   timezone: 'Asia/Muscat',       musicMarket: true
  },
  {
    code: 'IL', name: 'Israel',           nativeName: 'ישראל',
    flag: '🇮🇱', region: 'middle_east',
    currency: 'ILS', dialCode: '+972',   timezone: 'Asia/Jerusalem',    musicMarket: true
  },
  {
    code: 'JO', name: 'Jordan',           nativeName: 'الأردن',
    flag: '🇯🇴', region: 'middle_east',
    currency: 'JOD', dialCode: '+962',   timezone: 'Asia/Amman',        musicMarket: true
  },

  // ── Africa ──────────────────────────────────────────────────
  {
    code: 'ZA', name: 'South Africa',     nativeName: 'South Africa',
    flag: '🇿🇦', region: 'africa',
    currency: 'ZAR', dialCode: '+27',    timezone: 'Africa/Johannesburg', musicMarket: true
  },
  {
    code: 'NG', name: 'Nigeria',          nativeName: 'Nigeria',
    flag: '🇳🇬', region: 'africa',
    currency: 'NGN', dialCode: '+234',   timezone: 'Africa/Lagos',      musicMarket: true
  },
  {
    code: 'GH', name: 'Ghana',            nativeName: 'Ghana',
    flag: '🇬🇭', region: 'africa',
    currency: 'GHS', dialCode: '+233',   timezone: 'Africa/Accra',      musicMarket: true
  },
  {
    code: 'KE', name: 'Kenya',            nativeName: 'Kenya',
    flag: '🇰🇪', region: 'africa',
    currency: 'KES', dialCode: '+254',   timezone: 'Africa/Nairobi',    musicMarket: true
  },
  {
    code: 'TZ', name: 'Tanzania',         nativeName: 'Tanzania',
    flag: '🇹🇿', region: 'africa',
    currency: 'TZS', dialCode: '+255',   timezone: 'Africa/Dar_es_Salaam', musicMarket: true
  },
  {
    code: 'MA', name: 'Morocco',          nativeName: 'المغرب',
    flag: '🇲🇦', region: 'africa',
    currency: 'MAD', dialCode: '+212',   timezone: 'Africa/Casablanca', musicMarket: true
  },
  {
    code: 'ET', name: 'Ethiopia',         nativeName: 'ኢትዮጵያ',
    flag: '🇪🇹', region: 'africa',
    currency: 'ETB', dialCode: '+251',   timezone: 'Africa/Addis_Ababa', musicMarket: false
  },
  {
    code: 'SN', name: 'Senegal',          nativeName: 'Sénégal',
    flag: '🇸🇳', region: 'africa',
    currency: 'XOF', dialCode: '+221',   timezone: 'Africa/Dakar',      musicMarket: true
  },
]

// ─────────────────────────────────────────────────────────────
//  Helpers
// ─────────────────────────────────────────────────────────────

/** Chỉ lấy các nước có trong music market (Spotify/Apple Music) */
export const MUSIC_MARKET_COUNTRIES = COUNTRIES.filter(c => c.musicMarket)

/** Group theo region để render UI theo nhóm */
export const COUNTRIES_BY_REGION = COUNTRIES.reduce((acc, country) => {
  if (!acc[country.region]) acc[country.region] = []
  acc[country.region].push(country)
  return acc
}, {} as Record<CountryRegion, Country[]>)

/** Label hiển thị cho từng region */
export const REGION_LABELS: Record<CountryRegion, string> = {
  southeast_asia: 'Southeast Asia',
  east_asia:      'East Asia',
  south_asia:     'South Asia',
  oceania:        'Oceania',
  north_america:  'North America',
  latin_america:  'Latin America',
  europe:         'Europe',
  middle_east:    'Middle East',
  africa:         'Africa',
}

/** Tìm country theo code */
export function getCountryByCode(code: string): Country | undefined {
  return COUNTRIES.find(c => c.code === code)
}

/** Lấy display string: flag + name */
export function getCountryDisplay(code: string): string {
  const c = getCountryByCode(code)
  return c ? `${c.flag} ${c.name}` : code
}

export type CountryCode = (typeof COUNTRIES)[number]['code']