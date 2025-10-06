/// <reference types="vite/client" />

interface Window {
  invokeNative?: (native: string, ...args: any[]) => void;
  GetParentResourceName?: () => string;
}
