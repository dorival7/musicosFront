const sertanejoSunset = {
  id: "sertanejo-sunset",
  nome: "Sertanejo Sunset",

  width: 1080,
  height: 1920,

  colors: {
    backgroundTop: "#20252b",
    backgroundMiddle: "#4b2a1c",
    backgroundBottom: "#100a07",

    yellow: "#ffe000",
    white: "#ffffff",
    dark: "#111111",
    wood: "#63391f",
    red: "#df2025"
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
      y: 80,
      width: 400,
      fontSize: 145
    },

    weekday: {
      x: 70,
      y: 225,
      width: 330,
      height: 70,
      fontSize: 38
    },

    call: {
      x: 690,
      y: 115,
      width: 310,
      fontSize: 48,
      rotation: -5
    },

    showLabel: {
      x: 100,
      y: 1120,
      width: 880,
      fontSize: 50
    },

    artist: {
      x: 70,
      y: 1185,
      width: 940,
      height: 180,
      fontSize: 105,
      minFontSize: 48
    },

    establishmentLogo: {
      x: 440,
      y: 1380,
      width: 200,
      height: 200
    },

    establishment: {
      x: 100,
      y: 1590,
      width: 880,
      height: 105,
      fontSize: 55
    },

    city: {
      x: 100,
      y: 1710,
      width: 880,
      fontSize: 34
    },

    time: {
      x: 100,
      y: 1760,
      width: 880,
      fontSize: 55
    },

    extra: {
      x: 100,
      y: 1840,
      width: 880,
      height: 70,
      fontSize: 36
    }
  }
};

export default sertanejoSunset;