<template>
  <section v-if="premium.length || partners.length" class="seven-ads">
    <BContainer>
      <div class="section-heading">
        <div>
          <div class="section-kicker">PARCEIROS SEVEN SHOWS</div>
          <h2>Marcas que vivem a música com você</h2>
          <p>Produtos e serviços selecionados para quem vive de música.</p>
        </div>
        <span class="ad-label">PUBLICIDADE</span>
      </div>

      <div v-for="ad in premium" :key="ad.id" class="banner-wrap">
        <button v-if="hasImage(ad)" type="button" class="banner-ad" @click="openAd(ad)">
          <picture class="banner-media">
            <source media="(max-width: 767px)" :srcset="img(ad.mobileImageUrl || ad.desktopImageUrl)">
            <img :src="img(ad.desktopImageUrl || ad.mobileImageUrl)" alt="Publicidade">
          </picture>
        </button>
        <button v-if="ctaLabel(ad)" type="button" class="destination-cta" @click="openAd(ad)">
          <i :class="ctaIcon(ad)"></i><span>{{ ctaLabel(ad) }}</span>
        </button>
      </div>

      <div v-if="partners.length" class="partners-block">
        <div class="partners-scroll">
          <div v-for="ad in partners" :key="ad.id" class="partner-wrap">
            <button v-if="hasImage(ad)" class="partner-ad" type="button" @click="openAd(ad)">
              <img :src="img(ad.desktopImageUrl || ad.mobileImageUrl)" alt="Publicidade">
            </button>
            <button v-if="ctaLabel(ad)" type="button" class="destination-cta partner-cta" @click="openAd(ad)">
              <i :class="ctaIcon(ad)"></i><span>{{ ctaLabel(ad) }}</span>
            </button>
          </div>
        </div>
      </div>
    </BContainer>
  </section>
</template>

<script>
import axios from 'axios';
export default {
  name: 'PaidAdvertising',
  data() { return { ads: [], seen: new Set() }; },
  computed: {
    premium() { return this.ads.filter(x => x.position === 'HOME_PREMIUM'); },
    partners() { return this.ads.filter(x => x.position === 'HOME_PARTNERS'); }
  },
  async mounted() {
    try {
      const r = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/advertising/public/home`);
      this.ads = r.data || [];
      this.ads.forEach(a => this.impression(a));
    } catch (e) { console.warn('Publicidade indisponível.', e); }
  },
  methods: {
    hasImage(ad) { return Boolean(ad.desktopImageUrl || ad.mobileImageUrl); },
    img(u) {
      if (!u) return '';
      if (/^https?:/.test(u)) return u;
      const b = (process.env.VUE_APP_API_BASE_URL || '').replace(/\/api\/?$/, '');
      return `${b}${u.startsWith('/') ? '' : '/'}${u}`;
    },
    externalUrl(url) {
      if (!url) return '';
      return /^https?:\/\//i.test(url) ? url : `https://${url.replace(/^\/+/, '')}`;
    },
    destination(a) {
      if (a.websiteUrl) return { channel: 'website', label: 'Visite nosso site', icon: 'ri-global-line', url: this.externalUrl(a.websiteUrl) };
      if (a.whatsApp) return { channel: 'whatsapp', label: 'Fale conosco pelo WhatsApp', icon: 'ri-whatsapp-line', url: `https://wa.me/${a.whatsApp.replace(/\D/g, '')}?text=${encodeURIComponent(a.whatsAppMessage || 'Olá! Vi sua publicidade no Seven Shows e gostaria de mais informações.')}` };
      if (a.instagramUrl) return { channel: 'instagram', label: 'Visite nosso Instagram', icon: 'ri-instagram-line', url: this.externalUrl(a.instagramUrl) };
      if (a.destinationUrl) return { channel: 'facebook', label: 'Visite nosso Facebook', icon: 'ri-facebook-circle-line', url: this.externalUrl(a.destinationUrl) };
      return null;
    },
    ctaLabel(a) { const d = this.destination(a); return d ? d.label : ''; },
    ctaIcon(a) { const d = this.destination(a); return d ? d.icon : ''; },
    async impression(a) {
      if (this.seen.has(a.id)) return;
      this.seen.add(a.id);
      try { await axios.post(`${process.env.VUE_APP_API_BASE_URL}/advertising/public/${a.id}/impression`); }
      catch (e) { console.warn('Não foi possível registrar impressão da publicidade.', e); }
    },
    async openAd(a) {
      const d = this.destination(a);
      if (!d) return;
      window.open(d.url, '_blank', 'noopener,noreferrer');
      try { await axios.post(`${process.env.VUE_APP_API_BASE_URL}/advertising/public/${a.id}/click?channel=${encodeURIComponent(d.channel)}`); }
      catch (e) { console.warn('Não foi possível registrar clique da publicidade.', e); }
    }
  }
};
</script>

<style scoped>
.seven-ads{position:relative;background:linear-gradient(180deg,#080a10 0%,#0d0f16 50%,#080a10 100%);padding:64px 0 72px;border-top:1px solid rgba(255,255,255,.04)}
.section-heading{display:flex;align-items:flex-end;justify-content:space-between;gap:24px;margin-bottom:24px}.section-kicker{font-size:12px;font-weight:900;letter-spacing:1.4px;color:#ff6c22;margin-bottom:6px}.section-heading h2{margin:0;color:#fff;font-size:28px;font-weight:900;line-height:1.15}.section-heading p{margin:7px 0 0;color:#9da8bd;font-size:14px}.ad-label{font-size:9px;color:#737b8c;border:1px solid #303440;padding:5px 9px;border-radius:20px;letter-spacing:.8px}
.banner-wrap{margin-bottom:28px;text-align:center}.banner-ad{display:block;width:100%;padding:0;border:0;background:transparent;border-radius:18px;overflow:hidden;cursor:pointer;box-shadow:0 18px 50px rgba(0,0,0,.25)}.banner-media,.banner-media img{display:block;width:100%}.banner-media img{height:auto;aspect-ratio:16/5;object-fit:cover}.destination-cta{margin-top:14px;border:1px solid #303642;background:#151923;color:#fff;border-radius:999px;padding:10px 18px;font-weight:800;font-size:13px;display:inline-flex;align-items:center;gap:8px;transition:.2s}.destination-cta:hover{border-color:#ff6c22;transform:translateY(-1px)}.destination-cta i{font-size:19px}
.partners-block{margin-top:28px}.partners-scroll{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px}.partner-wrap{text-align:center;min-width:0}.partner-ad{display:block;width:100%;padding:0;border:0;background:transparent;border-radius:14px;overflow:hidden;cursor:pointer;box-shadow:0 10px 28px rgba(0,0,0,.22);transition:.2s}.partner-ad:hover{transform:translateY(-2px)}.partner-ad img{display:block;width:100%;aspect-ratio:16/9;object-fit:cover}.partner-cta{margin-top:10px}
@media(max-width:991px){.partners-scroll{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:767px){.seven-ads{padding:48px 0}.section-heading{align-items:flex-start;gap:12px}.section-heading h2{font-size:24px}.section-heading p{font-size:13px}.ad-label{flex-shrink:0}.banner-ad{border-radius:14px}.banner-media img{aspect-ratio:4/5}.destination-cta{width:100%;justify-content:center}.partners-scroll{display:flex;overflow-x:auto;padding-bottom:8px;scroll-snap-type:x mandatory}.partner-wrap{min-width:260px;scroll-snap-align:start}.partner-ad{min-width:0}}
</style>
