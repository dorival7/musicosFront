const sertanejoSunset = {
  id: "sertanejo-sunset",
  nome: "Sertanejo Sunset",
  versao: 3,

  width: 1080,
  height: 1920,

  colors: {
    backgroundTop: "#171b20",
    backgroundMiddle: "#4a281b",
    backgroundBottom: "#090706",

    yellow: "#ffe000",
    white: "#ffffff",
    dark: "#111111",
    wood: "#63391f",
    woodLight: "#c58a4b",
    parchment: "#fff4dd",
    red: "#e31b23",

    sunset: "#d88a2d",
    sunsetSoft: "rgba(216,138,45,0.18)",
    amber: "#f0a43c",
    panel: "rgba(20,11,7,0.78)",
    panelBorder: "rgba(255,224,0,0.34)"
  },

  typography: {
    date: "Bebas Neue",
    weekday: "Oswald",
    call: "Pacifico",
    showLabel: "Permanent Marker",
    artist: "Permanent Marker",
    establishment: "Bebas Neue",
    info: "Oswald",
    extra: "Permanent Marker"
  },

  effects: {
    sun: {
      x: 700,
      y: 500,
      radius: 215
    },

    atmosphere: {
      leftX: 40,
      leftY: 300,
      rightX: 1040,
      rightY: 380
    },

    artistShadow: {
      x: 540,
      y: 1190,
      radiusX: 270,
      radiusY: 55
    }
  },

  layers: {
    artistPhoto: {
      x: 110,
      y: 300,
      width: 860,
      height: 920
    },

    date: {
      x: 65,
      y: 70,
      width: 400,
      fontSize: 145
    },

    weekday: {
      x: 70,
      y: 220,
      width: 330,
      height: 70,
      fontSize: 38
    },

    call: {
      x: 675,
      y: 105,
      width: 330,
      fontSize: 48,
      rotation: -5
    },

    showLabel: {
      x: 100,
      y: 1110,
      width: 880,
      fontSize: 54
    },

    artist: {
      x: 55,
      y: 1165,
      width: 970,
      height: 205,
      fontSize: 105,
      minFontSize: 48
    },

    establishmentLogo: {
      x: 440,
      y: 1390,
      width: 200,
      height: 200
    },

    establishment: {
      x: 205,
      y: 1495,
      width: 670,
      height: 105,
      fontSize: 58
    },

    city: {
      x: 120,
      y: 1668,
      width: 840,
      fontSize: 38
    },

    time: {
      x: 120,
      y: 1668,
      width: 840,
      fontSize: 44
    },

    extra: {
      x: 100,
      y: 1755,
      width: 880,
      height: 86,
      fontSize: 42
    }
  }
};

export default sertanejoSunset;
