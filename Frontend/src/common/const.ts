// src/commons/constants.ts

/**
 * Enum mã phản hồi từ server
 */
export enum ResponseCode {
  SUCCESS = 0,
  SYSTEM_ERROR = 1,
  NOT_FOUND = 2,
  INVALID = 3,
  UNAUTHORIZED = 4,
}

/**
 * Loại hình ảnh upload
 */
export enum UploadImageType {
  AVATAR = 'Avatar',
  COVER = 'Cover',
  ARTIST = 'Artist',
  PLAYLIST = 'Playlist',
}

/**
 * Kiểu dữ liệu hiển thị / xử lý
 */
export enum DataType {
  DATE = 'DATE',
  DATE_TIME = 'DATE_TIME',
  NUMBER = 'NUMBER',
  TEXT = 'TEXT',
}

/**
 * Phân loại tài khoản người dùng
 */
export enum AccountType {
  SYS_ADMIN = 1,
  ADMIN = 2,
  USER = 3,
  GUEST = 4,
}

/**
 * Tên các khóa trong Cookie / LocalStorage
 */
export enum CookieKey {
  ACCESS_TOKEN = 'auth.access_token',
  REFRESH_TOKEN = 'auth.refresh_token',
  USER_INFO = 'auth.user_info',
}

/**
 * Kiểu import dữ liệu
 */
export enum ImportType {
  WITHOUT_DATA = 1,
  WITH_DATA = 2,
}

/**
 * Thông điệp hệ thống hiển thị cho người dùng
 */
export enum SystemMessage {
  LOGOUT_CONFIRM_TITLE = 'Đăng xuất',
  LOGOUT_CONFIRM_MESSAGE = 'Kết thúc phiên đăng nhập. Vui lòng xác nhận.',

  DELETE_CONFIRM = 'Bạn có chắc muốn xóa mục này không?',
  UPLOAD_CONFIRM = 'Bạn có chắc muốn cập nhật không?',

  ERROR_NO_FILE = 'Vui lòng chọn tệp.',
  ERROR_API = 'Đã xảy ra lỗi. Vui lòng thử lại sau.',
}

/**
 * Loại popup được hiển thị
 */
export enum PopupType {
  VIEW = 'VIEW',
  CREATE = 'CREATE',
  EDIT = 'EDIT',
}

/**
 * Các chế độ phát nhạc
 */
export enum PlayerMode {
  REPEAT = 'REPEAT',
  SHUFFLE = 'SHUFFLE',
  LOOP = 'LOOP',
  NORMAL = 'NORMAL',
}

/**
 * Trạng thái bài hát hoặc playlist
 */
export enum ContentStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  DRAFT = 'DRAFT',
}

/**
 * Các hằng số khác
 */
export const ERROR_CLASS = 'error';
export const ONE_HOUR_MS = 60 * 60 * 1000;
export const DEFAULT_LANGUAGE = 'vi';
