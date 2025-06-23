import { PiniaPluginContext } from 'pinia';

export function piniaPersistPlugin(context: PiniaPluginContext) {
    const storeId = context.store.$id;
    const savedState = localStorage.getItem(`pinia_${storeId}`);
    
    if (savedState) {
        // Khôi phục state từ localStorage
        context.store.$patch(JSON.parse(savedState));
        
        // Nếu là auth store và có token, set vào axios
        if (storeId === 'adminAuth') {
            const { token } = JSON.parse(savedState);
            if (token) {
                context.store.token = token;
            }
        }
    }

    context.store.$subscribe((mutation, state) => {
        // Lưu state vào localStorage
        localStorage.setItem(`pinia_${storeId}`, JSON.stringify(state));
        
        // Nếu là auth store, cập nhật token trong axios
        if (storeId === 'adminAuth' && 'token' in state) {
            const http = require('@/utils/http').default;
            if (state.token) {
                http.defaults.headers.common['Authorization'] = `Bearer ${state.token}`;
            } else {
                delete http.defaults.headers.common['Authorization'];
            }
        }
    });
}