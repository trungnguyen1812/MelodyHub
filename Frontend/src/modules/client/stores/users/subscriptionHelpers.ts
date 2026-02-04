// @/utils/subscriptionHelpers.ts
import type { SubscriptionPlan } from '@/modules/client/interfaces/users/SubscriptionPlan';

export class SubscriptionFormatter {
  // Convert audio quality to text
  static getAudioQualityText(quality: string): string {
    const qualityMap: Record<string, string> = {
      standard: 'Standard Quality (128kbps)',
      high: 'High Quality (320kbps)',
      lossless: 'Lossless Quality (FLAC)',
      master: 'Master Quality (Hi-Res)',
    };
    return qualityMap[quality] || 'Standard Quality';
  }

  // Convert boolean to yes/no text
  static getBooleanText(
    value: boolean,
    positiveText: string,
    negativeText: string
  ): string {
    return value ? positiveText : negativeText;
  }

  // Format price
  static formatPrice(price: number, currency: string): string {
    if (price === 0) return 'Free';

    const symbols: Record<string, string> = {
      VND: '₫',
      USD: '$',
      EUR: '€',
    };
    const symbol = symbols[currency] || currency;

    return `${symbol}${price.toLocaleString('en-US')}`;
  }

  // Get duration text
  static getDurationText(days: number): string {
    if (days === 0) return 'Lifetime';
    if (days === 30) return 'month';
    if (days === 365) return 'year';
    if (days === 7) return 'week';
    return `${days} days`;
  }

  // Playlist limit text
  static getPlaylistText(maxPlaylists: number): string {
    if (maxPlaylists >= 9999) return 'Unlimited playlists';
    if (maxPlaylists === 0) return 'No playlists allowed';
    return `Up to ${maxPlaylists} playlists`;
  }

  // Songs per playlist text
  static getSongsPerPlaylistText(maxSongs: number): string {
    if (maxSongs >= 9999) return 'Unlimited songs';
    if (maxSongs === 0) return 'No songs allowed';
    return `Up to ${maxSongs} songs per playlist`;
  }

  // Offline downloads text
  static getOfflineDownloadsText(plan: SubscriptionPlan): string {
    if (!plan.can_download) return 'Offline downloads not available';
    if (plan.max_offline_downloads >= 9999)
      return 'Unlimited offline downloads';
    if (plan.max_offline_downloads === 0)
      return 'Limited offline downloads';
    return `Download up to ${plan.max_offline_downloads} songs`;
  }

  // Device limit text
  static getDeviceText(maxDevices: number): string {
    if (maxDevices >= 9999) return 'Unlimited devices';
    if (maxDevices === 1) return '1 device';
    return `Up to ${maxDevices} devices`;
  }

  // Badge text
  static getBadgeText(plan: SubscriptionPlan): string {
    if (plan.name === 'free') return 'Free';
    if (plan.is_featured) return 'Most Popular';
    if (plan.trial_days > 0) return `${plan.trial_days}-day Trial`;
    if (plan.price > 0) return 'Premium';
    return '';
  }

  // Badge class
  static getBadgeClass(plan: SubscriptionPlan): string {
    if (plan.name === 'free') return 'badge-free';
    if (plan.is_featured) return 'badge-popular';
    if (plan.trial_days > 0) return 'badge-trial';
    if (plan.price > 0) return 'badge-premium';
    return '';
  }

  // Button text
  static getButtonText(plan: SubscriptionPlan): string {
    if (plan.name === 'free') return 'Get Started';
    if (plan.trial_days > 0) return `Start ${plan.trial_days}-day Trial`;
    if (plan.price === 0) return 'Subscribe Now';
    return 'Upgrade Now';
  }

  // Button class
  static getButtonClass(plan: SubscriptionPlan): string {
    if (plan.name === 'free') return 'btn-free';
    if (plan.is_featured) return 'btn-primary';
    if (plan.trial_days > 0) return 'btn-trial';
    return 'btn-secondary';
  }

  // Feature icon
  static getFeatureIcon(value: boolean): string {
    return value ? 'fas fa-check' : 'fas fa-times';
  }

  // Feature icon color
  static getFeatureIconColor(value: boolean): string {
    return value ? 'text-success' : 'text-muted';
  }
}
