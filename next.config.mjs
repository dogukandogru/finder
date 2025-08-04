/** @type {import('next').NextConfig} */
const nextConfig = {
  // DigitalOcean deployment için
  output: 'standalone',
  
  // Dış erişim için
  serverExternalPackages: [],
  
  // Asset optimizasyonu
  images: {
    unoptimized: true,
  },
  
  // Production için
  poweredByHeader: false,
  
  // Redirect trailing slashes
  trailingSlash: false,
};

export default nextConfig;
